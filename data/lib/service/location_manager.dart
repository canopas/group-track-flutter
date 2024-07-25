// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'dart:async';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

const LOCATION_UPDATE_INTERVAL = 10000; // milliseconds
const LOCATION_UPDATE_DISTANCE = 10; // meters

final locationManagerProvider = Provider((ref) => LocationManager());

class LocationManager {
  LocationManager();

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

  void stopService() {
    FlutterBackgroundService().invoke("stopService");
  }
}
