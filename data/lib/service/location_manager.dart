// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/api/auth/auth_models.dart';
import 'package:data/repository/journey_repository.dart';
import 'package:data/service/location_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/location/location.dart';
import '../log/logger.dart';

const MOVING_DISTANCE = 10; // meters
const STEADY_DISTANCE = 50; // meters

final locationManagerProvider = Provider((ref) => LocationManager(
      ref.read(locationServiceProvider),
      ref.read(journeyRepositoryProvider),
    ));

final bgService = FlutterBackgroundService();
const locationMethodChannel = MethodChannel('com.grouptrack/location');

class LocationManager {
  final LocationService _locationService;
  final JourneyRepository _journeyRepository;

  LocationManager(this._locationService, this._journeyRepository);

  StreamSubscription<Position>? positionSubscription;
  Position? _lastPosition;
  Position? _movingPosition;
  bool isMoving = false;
  bool isTrackingStarted = false;
  int movingDistance = STEADY_DISTANCE;

  Future<bool> isServiceRunning() async {
    return await bgService.isRunning();
  }

  Future<Position?> getLastLocation({Duration? timeout}) async {
    if (!await Geolocator.isLocationServiceEnabled()) return null;

    if (await Permission.location.isDenied) return null;

    return await Geolocator.getCurrentPosition(timeLimit: timeout);
  }

  void startService() async {
    if (isTrackingStarted) return;

    if (Platform.isIOS) {
      await locationMethodChannel.invokeMethod('startTracking');
    }
    if (Platform.isAndroid) await bgService.startService();
    isTrackingStarted = true;
  }

  void stopTrackingService() async {
    if (Platform.isIOS) {
      await locationMethodChannel.invokeMethod('stopTracking');
    }
    positionSubscription?.cancel();
    positionSubscription = null;
    if (Platform.isAndroid) bgService.invoke("stopService");
    isTrackingStarted = false;
  }

  Future<ApiUser?> _getUserFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedUser = prefs.getString("user_account");
    return encodedUser != null
        ? ApiUser.fromJson(jsonDecode(encodedUser))
        : null;
  }

  void startTracking() async {
    if (!await Permission.location.isGranted) return;

    positionSubscription?.cancel();

    final user = await _getUserFromPreferences();
    if (user == null) return;

    positionSubscription = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high, distanceFilter: movingDistance),
    ).listen((position) {
      if (_lastPosition == null) {
        _updateUserLocation(position);
      } else if (isMoving) {
        updateMovingJourney(position);
      } else {
        updateSteadyJourney(position);
      }
    });
  }

  void updateMovingJourney(Position position) async {
    final timeDifference =
        position.timestamp.difference(_lastPosition!.timestamp).inSeconds;
    final distance = _distanceBetween(_lastPosition!, position);

    if (_lastPosition == null || timeDifference >= 10 || distance >= 10) {
      _updateUserLocation(position);
    }
  }

  void updateSteadyJourney(Position position) async {
    final distance = _distanceBetween(_lastPosition!, position);

    if (_movingPosition != null) {
      final movingDistance = _distanceBetween(_movingPosition!, position);
      if (movingDistance > STEADY_DISTANCE && distance > STEADY_DISTANCE) {
        updateLocationRequest(true);
      }
    } else if (distance > STEADY_DISTANCE) {
      _movingPosition = position;
    }
  }

  void _updateUserLocation(Position? position) {
    if (position == null ||
        (position.latitude == 0 && position.longitude == 0)) {
      return;
    }
    final locationData = LocationData(
      latitude: position.latitude,
      longitude: position.longitude,
      timestamp: position.timestamp,
    );
    _lastPosition = position;
    updateUserLocation(locationData);
  }

  Future<void> updateUserLocation(LocationData locationPosition) async {
    final user = await _getUserFromPreferences();
    if (user == null) return;

    try {
      print("XXX updateUserLocation ${locationPosition}");
      await saveLocation(locationPosition);

      await _journeyRepository.saveLocationJourney(
          extractedLocation: locationPosition, userId: user.id);
    } catch (error, stack) {
      logger.e(
        'Error while updating user location and journey',
        error: error,
        stackTrace: stack,
      );
    }
  }

  double _distanceBetween(Position position1, Position position2) {
    return Geolocator.distanceBetween(
      position1.latitude,
      position1.longitude,
      position2.latitude,
      position2.longitude,
    );
  }

  void updateLocationRequest(bool isMoving) {
    if (Platform.isIOS) return;
    positionSubscription?.cancel();
    positionSubscription = null;
    _movingPosition = null;
    this.isMoving = isMoving;
    movingDistance = isMoving ? MOVING_DISTANCE : STEADY_DISTANCE;
    startTracking();
  }

  Future<void> saveLocation(LocationData location) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final user = await _getUserFromPreferences();
      if (user == null) return;

      final passKey = prefs.getString("user_passkey");
      if (passKey == null) return;

      await _locationService.saveCurrentLocation(user, location, passKey);
    } catch (e, s) {
      logger.d("Failed to save encrypted location", error: e, stackTrace: s);
    }
  }
}
