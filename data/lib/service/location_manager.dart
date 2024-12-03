// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/repository/journey_repository.dart';
import 'package:data/service/location_service.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/location/location.dart';
import '../log/logger.dart';

const MOVING_DISTANCE = 10; // meters
const STEADY_DISTANCE = 50; // meters

final locationManagerProvider = Provider((ref) => LocationManager.instance);

final bgService = FlutterBackgroundService();

class LocationManager {
  static LocationManager? _instance;

  final LocationService _locationService;
  final JourneyRepository _journeyRepository;

  LocationManager(this._locationService, this._journeyRepository);

  static LocationManager get instance {
    _instance ??= LocationManager(
      LocationService(FirebaseFirestore.instance),
      JourneyRepository.instance,
    );
    return _instance!;
  }

  StreamSubscription<Position>? positionSubscription;
  Position? _lastPosition;
  Position? _movingPosition;
  bool isMoving = false;
  int movingDistance = STEADY_DISTANCE;

  Future<bool> isServiceRunning() async {
    return await bgService.isRunning();
  }

  Future<Position?> getLastLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) return null;

    if (await Permission.location.isDenied) return null;

    return await Geolocator.getCurrentPosition();
  }

  void startService() async {
    await bgService.startService();
  }

  void stopTrackingService() async {
    positionSubscription?.cancel();
    positionSubscription = null;
    bgService.invoke("stopService");
  }

  Future<String?> _getUserIdFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedUser = prefs.getString("user_account");
    return encodedUser != null ? jsonDecode(encodedUser)['id'] : null;
  }

  void startTracking() async {
    if (!await Permission.location.isGranted) return;

    positionSubscription?.cancel();

    final userId = await _getUserIdFromPreferences();
    if (userId == null) return;

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
    if (position == null) return;
    final locationData = LocationData(
      latitude: position.latitude,
      longitude: position.longitude,
      timestamp: position.timestamp,
    );
    _lastPosition = position;
    updateUserLocation(locationData);
  }

  Future<void> updateUserLocation(LocationData locationPosition) async {
    final userId = await _getUserIdFromPreferences();
    if (userId != null) {
      try {
        await _locationService.saveCurrentLocation(userId: userId, locationData: locationPosition);

        await _journeyRepository.saveLocationJourney(
            extractedLocation: locationPosition, userId: userId);
      } catch (error, stack) {
        logger.e(
          'Error while updating user location and journey',
          error: error,
          stackTrace: stack,
        );
      }
    }
  }

  void onCurrentStateChangeRequest(String userId) async {
    final lastKnownJourney =
        await _journeyRepository.getLastKnownLocation(userId, null);
    _journeyRepository.checkAndSaveJourneyOnDayChange(
        extractedLocation: null,
        lastKnownJourney: lastKnownJourney,
        userId: userId);
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
}
