import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'location_service.dart';

const int locationUpdateInterval = 10000; // milliseconds
const int locationUpdateDistance = 10; // meters

final locationManagerProvider =
    Provider((ref) => LocationManager(ref.read(locationServiceProvider)));

class LocationManager {
  final LocationService locationService;

  Timer? _timer;

  LocationManager(this.locationService);

  Future<bool> isServiceRunning() async {
    final service = FlutterBackgroundService();
    return await service.isRunning();
  }

  Future<Position?> getLastLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) return null;

    if (await Permission.location.isDenied) {
      await Permission.location.request();
      if (await Permission.location.isDenied) {
        return null;
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  void startService(String userId) async {
    print('XXX start tracking');
    final service = FlutterBackgroundService();
    await service.configure(
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
    print('XXX after config');
    service.startService();

    print('XXX start service');
    // startLocationTracking(userId);
  }

  static Future<void> onStart(ServiceInstance service) async {

    WidgetsFlutterBinding.ensureInitialized();
    print("This is exAMPLE");

    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title: "Background Location Service",
        content: "Your location is being tracked",
      );
    }

    // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    // final prefs = await SharedPreferences.getInstance();
    // final locationService = LocationService(FirebaseFirestore.instance);

    String userId = '';
    // final String? encodedUser = prefs.getString("user_account");
    // if(encodedUser != null){
    //   final user = jsonDecode(encodedUser);
    //   userId = user['id'];
    // }

    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: locationUpdateDistance,
      ),
    ).listen((position) async {
     print('XXX user id:$userId');
      // locationService.saveCurrentLocation(userId, position.latitude,
      //     position.longitude, DateTime.now().millisecondsSinceEpoch, 0);
    });
    service.on('stopService').listen((event) {
      service.stopSelf();
    });
  }

  void startLocationTracking(String userId) {
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: locationUpdateDistance,
      ),
    ).listen((position) async {
      _timer?.cancel();
      _timer = Timer(const Duration(milliseconds: 5000), () {
        print('XXX position:$position');
        updateUserLocation(userId, position);
      });
    });
  }

  void updateUserLocation(String userId, Position position) async {
    await locationService.saveCurrentLocation(
      userId,
      position.latitude,
      position.longitude,
      DateTime.now().millisecondsSinceEpoch,
      0,
    );
  }

  void stopService() {
    FlutterBackgroundService().invoke("stopService");
  }

  static bool onIosBackground(ServiceInstance service) {
    WidgetsFlutterBinding.ensureInitialized();
    onStart(service);
    return true;
  }
}
