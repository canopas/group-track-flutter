// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:convert';

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
import '../storage/location_caches.dart';

const MOVING_DISTANCE = 10; // meters
const STEADY_DISTANCE = 50; // meters

final locationManagerProvider = Provider((ref) => LocationManager.instance);

final bgService = FlutterBackgroundService();

class LocationManager {
  static LocationManager? _instance;

  final LocationService _locationService;
  final JourneyRepository _journeyRepository;
  final LocationCache locationCache = LocationCache();

  LocationManager(this._locationService, this._journeyRepository);

  static LocationManager get instance {
    _instance ??= LocationManager(
      LocationService(FirebaseFirestore.instance),
      JourneyRepository.instance,
    );
    return _instance!;
  }

  StreamSubscription<Position>? positionSubscription;
  Position? _movingPosition;
  Position? _lastPosition;
  bool isSteady = false;

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

    print("XXX Start tracking...");
    positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter:
              MOVING_DISTANCE // isSteady ? STEADY_DISTANCE : MOVING_DISTANCE,
          ),
    ).listen((position) {
      final timeDifference = _lastPosition != null
          ? position.timestamp.difference(_lastPosition!.timestamp).inSeconds
          : 0;

      final distance = _lastPosition != null
          ? _distanceBetween(_lastPosition!, position)
          : 0;

      print("XXX location update distance $distance --- timeDifference $timeDifference");


      if (_lastPosition == null ||
          timeDifference >= 10 ||
          distance >= MOVING_DISTANCE) {
        print("XXX _updateUserLocation $position");
        _updateUserLocation(position);
      }
      // else if (timeDifference > 10) {
      //    _manageSteadyLocationUpdates(userId, position);
      //  }
    });
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
        await _locationService.saveCurrentLocation(userId, locationPosition);

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

  void _resetLocationSetting(bool state) async {
    isSteady = state;
    _movingPosition = null;

    startTracking();
  }

  void _manageSteadyLocationUpdates(String userId, Position position) {
    if (isSteady) {
      _handleSteadyToMovingLocation(userId, position);
    } else {
      _updateUserLocation(position);
    }
  }

  void _handleSteadyToMovingLocation(String userId, Position position) {
    if (_lastPosition == null) return;

    final distance = _distanceBetween(_lastPosition!, position);

    if (_movingPosition != null) {
      final movingDistance = _distanceBetween(_movingPosition!, position);

      if (movingDistance > STEADY_DISTANCE && distance > STEADY_DISTANCE) {
        _resetLocationSetting(false);
        _updateUserLocation(_movingPosition);
      }
    } else if (distance > STEADY_DISTANCE) {
      _movingPosition = position;
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
}
