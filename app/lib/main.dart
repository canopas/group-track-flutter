import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:battery_plus/battery_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/api/location/journey/api_journey_service.dart';
import 'package:data/api/location/location.dart';
import 'package:data/log/logger.dart';
import 'package:data/repository/journey_repository.dart';
import 'package:data/service/battery_service.dart';
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
late final BatteryService batteryService;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    // Workaround for https://github.com/flutter/flutter/issues/35162
    await FlutterDisplayMode.setHighRefreshRate();
  }

  final container = await _initContainer();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  _initializeService();

  if (Platform.isAndroid) _startService();

  if (Platform.isIOS) platform.setMethodCallHandler(_handleLocationUpdates);

  runApp(
    UncontrolledProviderScope(container: container, child: const App()),
  );
}

Future<ProviderContainer> _initContainer() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (!kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    await FirebaseCrashlytics.instance.setCustomKey("app_type", "flutter");
  }

  final prefs = await SharedPreferences.getInstance();

  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
    ],
  );
  return container;
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  final networkService = NetworkService(FirebaseFirestore.instance);
  _updateSpaceUserNetworkState(message, networkService);
  _updateCurrentUserState(message, networkService);
}

void _updateSpaceUserNetworkState(
    RemoteMessage message, NetworkService networkService) {
  final String? userId =
      message.data[NotificationNetworkStatusConst.KEY_USER_ID];
  final bool isTypeNetworkStatus = message
      .data[NotificationNetworkStatusConst.NOTIFICATION_TYPE_NETWORK_STATUS];
  if (userId != null && isTypeNetworkStatus) {
    networkService.updateUserNetworkState(userId);
  }
}

void _updateCurrentUserState(
    RemoteMessage message, NetworkService networkService) async {
  final String? userId = message.data[NotificationUpdateStateConst.KEY_USER_ID];
  final bool isTypeUpdateState =
      message.data[NotificationUpdateStateConst.NOTIFICATION_TYPE_UPDATE_STATE];
  if (userId != null && isTypeUpdateState) {
    networkService.updateUserNetworkState(userId);
  }
  if (userId != null) {
    final lastKnownJourney =
        await journeyRepository.getLastKnownLocation(userId, null);
    journeyRepository.checkAndSaveJourneyOnDayChange(
        null, lastKnownJourney, userId);
  }

  if (Platform.isIOS) _userBatteryLevel(userId!);
}

// iOS location updates in background
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

// Android Location updates in background
void _startService() async {
  await bgService.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: false,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(autoStart: false),
  );

  if (await Permission.location.isGranted) {
    bgService.startService();
  }
}

StreamSubscription<Position>? positionSubscription;
Timer? _timer;
Position? _previousPosition;
Position? _movingPosition;
int? _batteryLevel;
bool isSteady = true;
int distanceFilter = 10;

@pragma('vm:entry-point')
Future<void> onStart(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!await Permission.location.isGranted) return;

  if (service is AndroidServiceInstance) {
    service.setForegroundNotificationInfo(
      title: "Your space Location",
      content: "Location is being tracked",
    );
    service.setAsForegroundService();
  }

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  _initializeService();
  final userId = await _getUserIdFromPreferences();

  if (userId != null) _startLocationUpdates(userId);

  service.on('stopService').listen((event) {
    _timer?.cancel();
    positionSubscription?.cancel();
    service.stopSelf();
  });
}

void _initializeService() {
  locationService = LocationService(FirebaseFirestore.instance);
  journeyService = ApiJourneyService(FirebaseFirestore.instance);
  journeyRepository = JourneyRepository(journeyService);
  batteryService = BatteryService(FirebaseFirestore.instance);
}

void _startLocationUpdates(String userId) {
  positionSubscription = Geolocator.getPositionStream(
    locationSettings: AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: distanceFilter,
        intervalDuration: const Duration(seconds: 10)),
  ).listen((position) {

    print("XXX new location:$position");

    if (_previousPosition == null) {
      _updateUserLocation(userId, position);
    } else {
      _manageSteadyLocationUpdates(userId, position);
    //   final distance = Geolocator.distanceBetween(
    //     position.latitude,
    //     position.longitude,
    //     _previousPosition!.latitude,
    //     _previousPosition!.longitude,
    //   );
    //
    //   final timeDifference =
    //       position.timestamp.difference(_previousPosition!.timestamp).inSeconds;
    //   print("XXX time:$timeDifference, $distance");

    // if (distance > LOCATION_UPDATE_DISTANCE || timeDifference > 10) {

    }
    // }
  });
}

void _manageSteadyLocationUpdates(String userId, Position position) {
  final difference =
      position.timestamp.difference(_previousPosition!.timestamp).inMinutes;

  if (isSteady) {
    print("XXX is steady true");
    final distance = _distanceBetween(_previousPosition!, position);
    if (_movingPosition != null) {
      print("XXX moving location not null");
      final movingDistance = _distanceBetween(_movingPosition!, position);
      if (movingDistance > 50 && distance > 50) {
        print("XXX reset and update moving location");
        resetLocationConfig(userId);
        _updateUserLocation(userId, _movingPosition);
        _movingPosition = null;
      }
    } else if (distance > 50) {
      print("XXX update moving location");
      _movingPosition = position;
    }
  } else if (difference > 5) {
    print("XXX difference is more then 5 min");
    if (distanceFilter == 50) return;
    print("XXX distanceFilter is not 50");
    resetLocationConfig(userId);
  } else {
    print("XXX update location last");
    _updateUserLocation(userId, position);
  }
}

void resetLocationConfig(String userId) {
  isSteady = !isSteady;
  distanceFilter = (distanceFilter == 50 ? 10 : 50);
  positionSubscription?.cancel();
  positionSubscription = null;
  _startLocationUpdates(userId);
}

double _distanceBetween(Position position1, Position position2) {
  return Geolocator.distanceBetween(
    position1.latitude,
    position1.longitude,
    position2.latitude,
    position2.longitude,
  );
}

void _updateUserLocation(String userId, Position? position) async {
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
    _userBatteryLevel(userId);
  } catch (error, stack) {
    logger.e(
      'Main: error while getting ot update user location and journey',
      error: error,
      stackTrace: stack,
    );
  }
}

Future<String?> _getUserIdFromPreferences() async {
  final prefs = await SharedPreferences.getInstance();
  final encodedUser = prefs.getString("user_account");
  return encodedUser != null ? jsonDecode(encodedUser)['id'] : null;
}

void _userBatteryLevel(String userId) async {
  try {
    final level = await Battery().batteryLevel;
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
