//ignore_for_file: constant_identifier_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/storage/location_caches.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../api/location/journey/api_journey_service.dart';
import '../api/location/journey/journey.dart';
import '../api/location/location.dart';
import '../log/logger.dart';

const MIN_TIME_DIFFERENCE = 5 * 60 * 1000;
const MIN_DISTANCE = 100.0;

class JourneyRepository {
  late ApiJourneyService _journeyService;

  final LocationCache _locationCache = LocationCache();

  JourneyRepository(FirebaseFirestore fireStore) {
    _journeyService = ApiJourneyService(fireStore);
  }

  Future<int> getUserState(String userId, LocationData locationPosition) async {
    try {
      var locationData = await _getLocationData(userId);
      if (locationData != null) {
        _checkAndUpdateLastFiveMinLocation(
          userId,
          locationData,
          locationPosition,
        );
      } else {
        final latLng =
            LatLng(locationPosition.latitude, locationPosition.longitude);
        final locations = [
          ApiLocation(
            id: const Uuid().v4(),
            user_id: userId,
            latitude: latLng.latitude,
            longitude: latLng.longitude,
            created_at: DateTime.now().millisecondsSinceEpoch,
          ),
        ];
        _locationCache.putLastFiveLocations(locations, userId);
        logger.i('add location in cache $locations', time: DateTime.now());
      }
      locationData = await _getLocationData(userId);
      final userState = _getCurrentUserState(locationData, locationPosition);
      return userState;
    } catch (error, stack) {
      logger.e(
        'JourneyRepository: Error while getting user state',
        error: error,
        stackTrace: stack,
      );
      return USER_STATE_STEADY;
    }
  }

  int _getCurrentUserState(
      List<ApiLocation>? locationData, LocationData locationPosition) {
    if (locationData == null || locationData.isEmpty) {
      return USER_STATE_STEADY;
    }

    LatLng median = geometricMedian(locationData.map((loc) => LatLng(loc.latitude, loc.longitude)).toList());

    double distanceToMedian = _distanceBetween(LatLng(locationPosition.latitude, locationPosition.longitude), median);
    if (distanceToMedian > MIN_DISTANCE) {
      logger.i('Update as Moving state', time: DateTime.now());
      return USER_STATE_MOVING;
    } else {
      logger.i('Update as steady state', time: DateTime.now());
      return USER_STATE_STEADY;
    }
  }

  void _checkAndUpdateLastFiveMinLocation(String userId,
      List<ApiLocation> locationData, LocationData locationPosition) async {
    final locations = locationData;

    if (locations.isEmpty) {
      await _updateLocationData(locations, locationPosition, userId);
    } else {
      final latest = (locations.length == 1)
          ? locations.first
          : locations.reduce((current, next) =>
              current.created_at! > next.created_at! ? current : next);

      if (latest.created_at! < DateTime.now().millisecondsSinceEpoch - 60000) {
        final latLng =
            LatLng(locationPosition.latitude, locationPosition.longitude);
        final updated = List<ApiLocation>.from(locations);
        updated.removeWhere((loc) =>
            locationPosition.timestamp.millisecondsSinceEpoch -
                loc.created_at! >
            MIN_TIME_DIFFERENCE);
        updated.add(ApiLocation(
          id: const Uuid().v4(),
          user_id: userId,
          latitude: latLng.latitude,
          longitude: latLng.longitude,
          created_at: DateTime.now().millisecondsSinceEpoch,
        ));
        await _updateLocationData(updated, locationPosition, userId);
      }
    }
  }

  Future<List<ApiLocation>?> _getLocationData(String userId) async {
    return _locationCache.getLastFiveLocations(userId);
  }

  Future<void> _updateLocationData(List<ApiLocation> locations,
      LocationData locationPosition, String userId) async {
    _locationCache.putLastFiveLocations(locations, userId);
    logger.i('Update location data $locations', time: DateTime.now());
  }

  Future<void> saveUserJourney(int userSate, String userId, LocationData locationPosition) async {
    final lastJourney = _locationCache.getLastJourney(userId);

    try {
      if (lastJourney == null) {
        await _journeyService.saveCurrentJourney(
          userId: userId,
          fromLatitude: locationPosition.latitude,
          fromLongitude: locationPosition.longitude,
        );
        logger.i('Save location journey when user last journey is null: $locationPosition', time: DateTime.now());
      } else if (userSate == USER_STATE_MOVING) {
        await _saveJourneyForMovingUser(userId, lastJourney, locationPosition);
        logger.i('Save location journey when user is in moving state: $locationPosition, last journey: $lastJourney', time: DateTime.now());
      } else if (userSate == USER_STATE_STEADY) {
        await _saveJourneyForSteadyUser(userId, lastJourney, locationPosition);
        logger.i('Save location journey when user is in steady state: $locationPosition, last journey $lastJourney', time: DateTime.now());
      }
    } catch (error, stack) {
      logger.e(
        'JourneyRepository: Error while saving user journey',
        error: error,
        stackTrace: stack,
      );
    }
  }

  Future<void> _saveJourneyForMovingUser(
    String userId,
    ApiLocationJourney lastJourney,
    LocationData locationPosition,
  ) async {
    final extractedLocation =
        LatLng(locationPosition.latitude, locationPosition.longitude);
    final movingDistance = _distanceBetween(
      extractedLocation,
      LatLng(lastJourney.to_latitude ?? 0.0, lastJourney.to_longitude ?? 0.0),
    );
    final steadyDistance = _distanceBetween(
      extractedLocation,
      LatLng(lastJourney.from_latitude, lastJourney.from_longitude),
    );

    if (lastJourney.isSteadyLocation()) {
      await _journeyService.saveCurrentJourney(
        userId: userId,
        fromLatitude: lastJourney.from_latitude,
        fromLongitude: lastJourney.from_longitude,
        toLatitude: locationPosition.latitude,
        toLongitude: locationPosition.longitude,
        routeDistance: steadyDistance,
        routeDuration: locationPosition.timestamp.millisecondsSinceEpoch -
            lastJourney.update_at!,
      );
    } else {
      final updatedRoutes = List<JourneyRoute>.from(lastJourney.routes)
        ..add(JourneyRoute(
          latitude: extractedLocation.latitude,
          longitude: extractedLocation.longitude,
        ));

      await _journeyService.updateLastLocationJourney(
        userId,
        lastJourney.copyWith(
          to_latitude: extractedLocation.latitude,
          to_longitude: extractedLocation.longitude,
          route_distance: (lastJourney.route_distance ?? 0.0) + movingDistance,
          route_duration: locationPosition.timestamp.millisecondsSinceEpoch -
              lastJourney.created_at!,
          routes: updatedRoutes,
          update_at: DateTime.now().millisecondsSinceEpoch,
        ),
      );
      _locationCache.putLastJourney(lastJourney, userId);
    }
  }

  Future<void> _saveJourneyForSteadyUser(
    String userId,
    ApiLocationJourney lastJourney,
    LocationData locationPosition,
  ) async {
    final extractedLocation =
        LatLng(locationPosition.latitude, locationPosition.longitude);
    final lastLatLng = (lastJourney.isSteadyLocation())
        ? LatLng(lastJourney.from_latitude, lastJourney.from_longitude)
        : LatLng(lastJourney.to_latitude!, lastJourney.to_longitude!);
    final distance = _distanceBetween(extractedLocation, lastLatLng);
    final timeDifference = locationPosition.timestamp.millisecondsSinceEpoch -
        (lastJourney.update_at ?? lastJourney.created_at!);

    if (timeDifference > MIN_TIME_DIFFERENCE && distance > MIN_DISTANCE) {
      if (lastJourney.isSteadyLocation()) {
        await _journeyService.updateLastLocationJourney(
          userId = userId,
          lastJourney.copyWith(
              update_at: DateTime.now().millisecondsSinceEpoch),
        );
        logger.i('update user journey when last loc is steady, check condition 1: $lastJourney', time: DateTime.now());
      } else {
        await _journeyService.saveCurrentJourney(
          userId: userId,
          fromLatitude: lastJourney.to_latitude!,
          fromLongitude: lastJourney.to_longitude!,
          created_at: lastJourney.update_at,
        );
        logger.i('save user current journey when last loc is not steady, check condition 1: $lastJourney', time: DateTime.now());
      }
      await _journeyService.saveCurrentJourney(
        userId: userId,
        fromLatitude: lastJourney.to_latitude ?? lastJourney.from_latitude,
        fromLongitude: lastJourney.to_longitude ?? lastJourney.from_longitude,
        toLatitude: locationPosition.latitude,
        toLongitude: locationPosition.longitude,
        routeDistance: distance,
        routeDuration: locationPosition.timestamp.millisecondsSinceEpoch -
            lastJourney.update_at!,
        created_at: lastJourney.update_at,
        updated_at: DateTime.now().millisecondsSinceEpoch,
      );
      logger.i('save user current journey outside if else condition, check condition 1: $lastJourney', time: DateTime.now());
    } else if (timeDifference < MIN_TIME_DIFFERENCE &&
        distance > MIN_DISTANCE) {
      final updatedRoutes = List<JourneyRoute>.from(lastJourney.routes)
        ..add(JourneyRoute(
          latitude: extractedLocation.latitude,
          longitude: extractedLocation.longitude,
        ));

      await _journeyService.updateLastLocationJourney(
          userId,
          lastJourney.copyWith(
            to_latitude: extractedLocation.latitude,
            to_longitude: extractedLocation.longitude,
            route_distance: distance,
            routes: updatedRoutes,
            route_duration: locationPosition.timestamp.millisecondsSinceEpoch -
                lastJourney.created_at!,
            update_at: DateTime.now().millisecondsSinceEpoch,
          ));
      logger.i('update location for steady user: $lastJourney', time: DateTime.now());
    } else if (timeDifference > MIN_TIME_DIFFERENCE &&
        distance < MIN_DISTANCE) {
      if (lastJourney.isSteadyLocation()) {
        await _journeyService.updateLastLocationJourney(
          userId = userId,
          lastJourney.copyWith(
              update_at: DateTime.now().millisecondsSinceEpoch),
        );
        logger.i('update user journey when last loc is steady, check condition 2: $lastJourney', time: DateTime.now());
      } else {
        await _journeyService.saveCurrentJourney(
          userId: userId,
          fromLatitude: locationPosition.latitude,
          fromLongitude: locationPosition.longitude,
          created_at: DateTime.now().millisecondsSinceEpoch,
        );
        logger.i('save user current journey outside if else condition, check condition 2: $lastJourney', time: DateTime.now());
      }
    } else if (timeDifference < MIN_TIME_DIFFERENCE &&
        distance < MIN_DISTANCE) {
      await _journeyService.updateLastLocationJourney(
        userId = userId,
        lastJourney.copyWith(update_at: DateTime.now().millisecondsSinceEpoch),
      );
      logger.i('update user journey when last loc is steady, check condition 3: $lastJourney', time: DateTime.now());
    }
    _locationCache.putLastJourney(lastJourney, userId);
    uploadLogFileToFirebase();
  }

  double _distanceBetween(LatLng startLocation, LatLng endLocation) {
    return Geolocator.distanceBetween(
      startLocation.latitude,
      startLocation.longitude,
      endLocation.latitude,
      endLocation.longitude,
    );
  }

  LatLng geometricMedian(List<LatLng> locations) {
    if (locations.isEmpty) {
      return const LatLng(0, 0);
    }
    LatLng result = locations.reduce((candidate, location) {
      double candidateSum = locations.map((loc) => Geolocator.distanceBetween(
        candidate.latitude,
        candidate.longitude,
        loc.latitude,
        loc.longitude,
      )).reduce((a, b) => a + b);

      double locationSum = locations.map((loc) => Geolocator.distanceBetween(
        location.latitude,
        location.longitude,
        loc.latitude,
        loc.longitude
      )).reduce((a, b) => a + b);
      return candidateSum < locationSum ? candidate : location;
    });
    return result;
  }

  Future<void> uploadLogFileToFirebase() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final logFile = File('${directory.path}/app.log');

      if (await logFile.exists()) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('logs/${DateTime.now().toIso8601String()}-app.log');

        // Upload the log file
        await storageRef.putFile(logFile);
        logger.i('Log file uploaded to Firebase Storage');
      } else {
        logger.w('Log file not found');
      }
    } catch (e) {
      logger.e('Error uploading log file: $e');
    }
  }
}

extension LocationListExtensions on List<ApiLocation> {
  bool isMoving(LocationData locationPosition) {
    return any((location) {
      final newLocation =
          LatLng(locationPosition.latitude, locationPosition.longitude);
      final lastLocation = LatLng(location.latitude, location.longitude);
      final distance = Geolocator.distanceBetween(
        lastLocation.latitude,
        lastLocation.longitude,
        newLocation.latitude,
        newLocation.longitude,
      );
      return distance > MIN_DISTANCE;
    });
  }
}
