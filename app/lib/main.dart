import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:battery_plus/battery_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/log/logger.dart';
import 'package:data/repository/journey_repository.dart';
import 'package:data/service/battery_service.dart';
import 'package:data/service/location_manager.dart';
import 'package:data/service/location_service.dart';
import 'package:data/service/network_service.dart';
import 'package:data/storage/preferences_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yourspace_flutter/firebase_options.dart';
import 'package:yourspace_flutter/ui/app.dart';

import 'domain/fcm/notification_handler.dart';

const platform = MethodChannel('com.yourspace/location');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    // Workaround for https://github.com/flutter/flutter/issues/35162
    await FlutterDisplayMode.setHighRefreshRate();
  }

  final container = await _initContainer();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  startService();

  platform.setMethodCallHandler(_handleLocationUpdates);

  runApp(
    UncontrolledProviderScope(container: container, child: const App()),
  );
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  final networkService = NetworkService(FirebaseFirestore.instance);
  updateSpaceUserNetworkState(message, networkService);
  updateCurrentUserState(message, networkService);
}

void updateSpaceUserNetworkState(RemoteMessage message, NetworkService networkService) {
  final String? userId = message.data[NotificationNetworkStatusConst.KEY_USER_ID];
  final bool isTypeNetworkStatus = message.data[NotificationNetworkStatusConst.NOTIFICATION_TYPE_NETWORK_STATUS];
  if (userId != null && isTypeNetworkStatus) {
    networkService.updateUserNetworkState(userId);
  }
}

void updateCurrentUserState(RemoteMessage message, NetworkService networkService) {
  final String? userId = message.data[NotificationUpdateStateConst.KEY_USER_ID];
  final bool isTypeUpdateState = message.data[NotificationUpdateStateConst.NOTIFICATION_TYPE_UPDATE_STATE];
  if (userId != null && isTypeUpdateState) {
    networkService.updateUserNetworkState(userId);
  }}

Future<ProviderContainer> _initContainer() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final prefs = await SharedPreferences.getInstance();

  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
    ],
  );
  return container;
}

Future<String?> _getUserIdFromPreferences() async {
  final prefs = await SharedPreferences.getInstance();
  final encodedUser = prefs.getString("user_account");
  if (encodedUser != null) {
    final user = jsonDecode(encodedUser);
    return user['id'];
  }
  return null;
}

Future<void> _handleLocationUpdates(MethodCall call) async {
  if (call.method == 'onLocationUpdate') {
    final Map<String, dynamic> locationData = Map<String, dynamic>.from(call.arguments);

    final double latitude = locationData['latitude'];
    final double longitude = locationData['longitude'];
    final DateTime timestamp = locationData['timestamp'];

    _updateUserLocationWithIOS(latitude, longitude, timestamp);
  }
}

void startService() async {
  await bgService.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: false,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: false,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );

  final isLocationPermission = await Permission.location.isGranted;
  if (isLocationPermission) {
    bgService.startService();
  }
}

StreamSubscription<Position>? positionSubscription;
Timer? _timer;
Position? _position;
Position? _previousPosition;
int? _batteryLevel;

@pragma('vm:entry-point')
Future<void> onStart(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  final isLocationPermission = await Permission.location.isGranted;
  if (!isLocationPermission) return;

  if (service is AndroidServiceInstance) {
    service.setForegroundNotificationInfo(
      title: "Your space Location",
      content: "Location is being tracked",
    );
    service.setAsForegroundService();
  }

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final locationService = LocationService(FirebaseFirestore.instance);
  final journeyRepository = JourneyRepository(FirebaseFirestore.instance);
  final batteryService = BatteryService(FirebaseFirestore.instance);
  final userId = await _getUserIdFromPreferences();
  final battery = Battery();

  if (userId != null) {
    _startLocationUpdates();
    _timer = Timer.periodic(
        const Duration(milliseconds: LOCATION_UPDATE_INTERVAL), (timer) {
      if (Platform.isAndroid) {
        _updateUserLocation(
            userId, locationService, journeyRepository, _position);
      }
      userBatteryLevel(userId, battery, batteryService);
    });
  }

  service.on('stopService').listen((event) {
    _timer?.cancel();
    positionSubscription?.cancel();
    service.stopSelf();
  });
}

void _startLocationUpdates() {
  positionSubscription = Geolocator.getPositionStream(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: LOCATION_UPDATE_DISTANCE,
    ),
  ).listen((position) {
    _position = position;
  });
}

void _updateUserLocationWithIOS(double latitude, double longitude, DateTime timestamp) async {
  final userId = await _getUserIdFromPreferences();
  if (userId != null) {
    final locationService = LocationService(FirebaseFirestore.instance);
    final journeyRepository = JourneyRepository(FirebaseFirestore.instance);

    try {
      final userState = await journeyRepository.getUserState(userId, latitude, longitude, timestamp);

      await locationService.saveCurrentLocation(
        userId,
        LatLng(latitude, longitude),
        DateTime.now().millisecondsSinceEpoch,
        userState,
      );

      await journeyRepository.saveUserJourney(userState, userId, latitude, longitude, timestamp);
    } catch (error, stack) {
      logger.e(
        'Error while updating user location and journey from native iOS location data',
        error: error,
        stackTrace: stack,
      );
    }
  }
}

void _updateUserLocation(
  String userId,
  LocationService locationService,
  JourneyRepository journeyRepository,
  Position? position,
) async {
  final isSame = _previousPosition?.latitude == position?.latitude &&
      _previousPosition?.longitude == position?.longitude;

  if (isSame || position == null) return;
  _previousPosition = position;

  try {
    final userState = await journeyRepository.getUserState(userId, position.latitude, position.longitude, position.timestamp);

    await locationService.saveCurrentLocation(
      userId,
      LatLng(position.latitude, position.longitude),
      DateTime.now().millisecondsSinceEpoch,
      userState,
    );

    await journeyRepository.saveUserJourney(userState, userId, position.latitude, position.longitude, position.timestamp);
  } catch (error, stack) {
    logger.e(
      'Main: error while getting ot update user location and journey',
      error: error,
      stackTrace: stack,
    );
  }
}

@pragma('vm:entry-point')
bool onIosBackground(ServiceInstance service) {
  onStart(service);
  return true;
}

void userBatteryLevel(
  String userId,
  Battery battery,
  BatteryService batteryService,
) async {
  try {
    final level = await battery.batteryLevel;
    if (level != _batteryLevel) {
      await batteryService.updateBatteryPct(userId, level);
      _batteryLevel = level;
    }
  } catch (error, stack) {
    logger.e(
      'Main: error while getting or updating battery level',
      error: error,
      stackTrace: stack,
    );
  }
}
