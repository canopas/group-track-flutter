import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/api/location/journey/api_journey_service.dart';
import 'package:data/api/location/location.dart';
import 'package:data/log/logger.dart';
import 'package:data/repository/journey_repository.dart';
import 'package:data/service/location_manager.dart';
import 'package:data/service/location_service.dart';
import 'package:data/service/network_service.dart';
import 'package:data/storage/preferences_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yourspace_flutter/firebase_options.dart';
import 'package:yourspace_flutter/ui/app.dart';

import 'domain/fcm/notification_handler.dart';

const platform = MethodChannel('com.grouptrack/location');
late final LocationService locationService;
late final JourneyRepository journeyRepository;
late final ApiJourneyService journeyService;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    // Workaround for https://github.com/flutter/flutter/issues/35162
    await FlutterDisplayMode.setHighRefreshRate();
  }

  final container = await _initContainer();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

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

void updateSpaceUserNetworkState(
    RemoteMessage message, NetworkService networkService) {
  final String? userId =
      message.data[NotificationNetworkStatusConst.KEY_USER_ID];
  final bool isTypeNetworkStatus = message
      .data[NotificationNetworkStatusConst.NOTIFICATION_TYPE_NETWORK_STATUS];
  if (userId != null && isTypeNetworkStatus) {
    networkService.updateUserNetworkState(userId);
  }
}

void updateCurrentUserState(RemoteMessage message, NetworkService networkService) async {
  final String? userId = message.data[NotificationUpdateStateConst.KEY_USER_ID];
  final bool isTypeUpdateState =
      message.data[NotificationUpdateStateConst.NOTIFICATION_TYPE_UPDATE_STATE];
  if (userId != null && isTypeUpdateState) {
    networkService.updateUserNetworkState(userId);
  }
  if (userId != null) {
    final lastKnownJourney = await journeyRepository.getLastKnownLocation(userId, null);
    journeyRepository.checkAndSaveJourneyOnDayChange(null, lastKnownJourney, userId);
  }
}

Future<ProviderContainer> _initContainer() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (!kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    await FirebaseCrashlytics.instance.setCustomKey("app_type", "flutter");
  }

  locationService = LocationService(FirebaseFirestore.instance);
  journeyService = ApiJourneyService(FirebaseFirestore.instance);
  journeyRepository = JourneyRepository(journeyService);

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
    final Map<String, dynamic> locationData =
        Map<String, dynamic>.from(call.arguments);

    final LocationData locationPosition = LocationData(
      latitude: locationData['latitude'],
      longitude: locationData['longitude'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(
          locationData['timestamp'].toInt()),
    );

    await _updateUserLocationWithIOS(locationPosition);
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

@pragma('vm:entry-point')
Future<void> onStart(ServiceInstance service) async {
  if (Platform.isIOS) return;
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
  locationService = LocationService(FirebaseFirestore.instance);
  journeyService = ApiJourneyService(FirebaseFirestore.instance);
  journeyRepository = JourneyRepository(journeyService);
  final userId = await _getUserIdFromPreferences();

  if (userId != null) {
    _startLocationUpdates();
    _timer = Timer.periodic(
        const Duration(milliseconds: LOCATION_UPDATE_INTERVAL), (timer) {
      if (Platform.isAndroid) {
        _updateUserLocation(userId, _position);
      }
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

Future<void> _updateUserLocationWithIOS(LocationData locationPosition) async {
  final userId = await _getUserIdFromPreferences();
  if (userId != null) {
    try {
      await locationService.saveCurrentLocation(userId, locationPosition);

      await journeyRepository.saveLocationJourney(locationPosition, userId);
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
  Position? position,
) async {
  final isSame = _previousPosition?.latitude == position?.latitude &&
      _previousPosition?.longitude == position?.longitude;

  if (isSame || position == null) return;
  _previousPosition = position;

  try {
    final locationData = LocationData(
      latitude: position.latitude,
      longitude: position.longitude,
      timestamp: position.timestamp,
    );
    await locationService.saveCurrentLocation(userId, locationData);

    await journeyRepository.saveLocationJourney(locationData, userId);
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

