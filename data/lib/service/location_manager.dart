import 'dart:async';

import 'package:data/service/permission_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

const int locationUpdateInterval = 10000; // milliseconds
const double locationUpdateDistance = 10.0; // meters

final locationManagerProvider =
    Provider((ref) => LocationManager(ref.read(permissionServiceProvider)));

class LocationManager {
  final PermissionService permissionService;
  final backGroundService = FlutterBackgroundService();
  Position? _lastLocation;
  Timer? _locationUpdateTimer;

  LocationManager(this.permissionService);

  Stream<Position> getLiveGeoLocatorData() {
    LocationSettings locationSettings;

    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: locationUpdateDistance.toInt(),
        intervalDuration: const Duration(milliseconds: locationUpdateInterval)
      );
    }  else {
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );
    }

    return Geolocator.getPositionStream(locationSettings: locationSettings);
  }

  void configure() {
    getLiveGeoLocatorData().listen((position) {

      final distance = Geolocator.distanceBetween(
        _lastLocation!.latitude,
        _lastLocation!.longitude,
        position.latitude,
        position.longitude,
      );
      print('Location distance:$distance update: $position');
        _lastLocation = position;
    });
    // Geolocator.getPositionStream(
    //   locationSettings: LocationSettings(
    //     accuracy: LocationAccuracy.best,
    //     distanceFilter: locationUpdateDistance.toInt(),
    //     timeLimit: Duration(seconds: 10)
    //   ),
    // ).listen((Position position) {
    //   print('Location update: $position');
    //   _lastLocation = position;
    //   // Handle location update here
    // });
  }

  Future<Position?> getLastLocation() async {
    if (!await permissionService.isLocationServiceEnabled()) {
      return null;
    }

    if (await Permission.location.isDenied) {
      await Permission.location.request();
      if (await Permission.location.isDenied) {
        return null;
      }
    }

    final lastLocation = await Geolocator.getLastKnownPosition();
    return lastLocation;
  }

  void stopLocationTracking() {
    _locationUpdateTimer?.cancel();
    stopService();
  }

  void startService() async {
    await backGroundService.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        isForegroundMode: true,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
    );
    backGroundService.startService();
  }

  void stopService() {
    FlutterBackgroundService().invoke("stopService");
  }

  static void onStart(ServiceInstance service) {
    WidgetsFlutterBinding.ensureInitialized();

    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title: "Background Location Service",
        content: "Your location is being tracked",
      );
      service.setAsForegroundService();
      service.setAsBackgroundService();
    }

    service.on('stopService').listen((event) {
      service.stopSelf();
    });
  }

  static bool onIosBackground(ServiceInstance service) {
    WidgetsFlutterBinding.ensureInitialized();
    onStart(service);
    return true;
  }
}
