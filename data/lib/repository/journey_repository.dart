// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/api/location/journey/journey.dart';
import 'package:data/api/location/location.dart';
import 'package:data/log/logger.dart';
import 'package:data/service/location_manager.dart';
import 'package:geolocator/geolocator.dart';

import '../api/location/journey/api_journey_service.dart';
import '../storage/location_caches.dart';

const MIN_DISTANCE = 150.0; // 150 meters
const MIN_TIME_DIFFERENCE = 5 * 60 * 1000; // 5 minutes
const MIN_DISTANCE_FOR_MOVING = 10.0; // 10 meters
const MIN_UPDATE_INTERVAL_MINUTE = 60 * 1000; // 1 minute

class JourneyRepository {
  static JourneyRepository? _instance;

  final ApiJourneyService journeyService;
  final LocationCache locationCache = LocationCache.instance;
  Timer? _steadyLocationTimer;

  JourneyRepository(this.journeyService);

  static JourneyRepository get instance {
    _instance ??= JourneyRepository(
      ApiJourneyService(FirebaseFirestore.instance),
    );
    return _instance!;
  }

  Future<void> saveLocationJourney({
    required LocationData extractedLocation,
    required String userId,
  }) async {
    try {
      _steadyLocationTimer?.cancel();
      _steadyLocationTimer = null;

      var lastKnownJourney =
          await getLastKnownLocation(userId, extractedLocation);

      // Check and save location journey on day changed
      await checkAndSaveJourneyOnDayChange(
          extractedLocation: extractedLocation,
          lastKnownJourney: lastKnownJourney,
          userId: userId);

      // Check add add extracted location to last five locations to calculate geometric median
      await _checkAndSaveLastFiveLocations(extractedLocation, userId);

      // Check and save location journey based on user state i.e., steady or moving
      await _checkAndSaveLocationJourney(
          userId, extractedLocation, lastKnownJourney);

      await _startSteadyLocationTimer(extractedLocation, userId);
    } catch (error, stack) {
      logger.e(
          'Journey Repository: Error while save journey, $extractedLocation',
          error: error,
          stackTrace: stack);
    }
  }

  // Start or restart the 5-minute timer when the user is steady.
  Future<void> _startSteadyLocationTimer(
      LocationData position, String userId) async {
    var lastLocation =
        locationCache.getLastJourney(userId)?.toLocationFromSteadyJourney();
    var lastLocationJourney = await getLastKnownLocation(userId, position);
    if (lastLocation == null || lastLocationJourney.isSteady()) {
      return;
    }

    _steadyLocationTimer = Timer(const Duration(minutes: 5), () async {
      try {
        await _saveSteadyLocation(position, userId);
      } catch (e, stack) {
        logger.e('Error saving steady location for user $userId: $e',
            stackTrace: stack);
      }
    });
  }

  Future<void> _saveSteadyLocation(LocationData position, String userId) async {
    var lastKnownJourney = await getLastKnownLocation(userId, position);
    if (lastKnownJourney.isSteady()) return;
    await _saveJourneyOnJourneyStopped(userId, position, lastKnownJourney);
  }

  Future<void> checkAndSaveJourneyOnDayChange(
      {required LocationData? extractedLocation,
      required ApiLocationJourney lastKnownJourney,
      required String userId}) async {
    bool dayChanged = _isDayChanged(extractedLocation, lastKnownJourney);
    bool isOnlyOneDayChange =
        _isOnlyOneDayChanged(extractedLocation, lastKnownJourney);

    if (dayChanged && isOnlyOneDayChange) {
      await _updateJourneyOnDayChanged(userId, lastKnownJourney);
    } else if (dayChanged && extractedLocation != null) {
      await _saveJourneyOnDayChanged(userId, extractedLocation);
    }
  }

  Future<void> _updateJourneyOnDayChanged(
      String userId, ApiLocationJourney lastKnownJourney) async {
    await journeyService.updateLastLocationJourney(
      userId,
      lastKnownJourney.copyWith(
        update_at: DateTime.now().millisecondsSinceEpoch,
      ),
    );

    final newJourney = lastKnownJourney.copyWith(
      created_at: DateTime.now().millisecondsSinceEpoch,
      update_at: DateTime.now().millisecondsSinceEpoch,
    );

    locationCache.putLastJourney(newJourney, userId);
  }

  Future<void> _saveJourneyOnDayChanged(
      String userId, LocationData extractedLocation) async {
    final newJourney = await journeyService.saveCurrentJourney(
        userId: userId,
        fromLatitude: extractedLocation.latitude,
        fromLongitude: extractedLocation.longitude,
        type: JOURNEY_TYPE_STEADY);

    locationCache.putLastJourney(newJourney, userId);
  }

  /// Get last known location journey from cache
  /// If not available, fetch from remote database and save it to cache
  /// If not available in remote database as well, save extracted location as new location journey
  /// with steady state in cache as well as remote database
  ///
  Future<ApiLocationJourney> getLastKnownLocation(
      String userId, LocationData? extractedLocation) async {
    var lastKnownJourney = locationCache.getLastJourney(userId);

    if (lastKnownJourney != null) {
      // Return last location journey if available from cache
      return lastKnownJourney;
    } else {
      // Here, means no location journey available in cache
      // Fetch last location journey from remote database and save it to cache
      lastKnownJourney = await journeyService.getLastJourneyLocation(userId);

      if (lastKnownJourney != null) {
        locationCache.putLastJourney(lastKnownJourney, userId);
        return lastKnownJourney;
      } else {
        // Here, means no location journey available in remote database as well
        // Possibly user is new or no location journey available
        // Save extracted location as new location journey with steady state in cache

        final newJourney = await journeyService.saveCurrentJourney(
            userId: userId,
            fromLatitude: extractedLocation?.latitude ?? 0,
            fromLongitude: extractedLocation?.longitude ?? 0,
            created_at: DateTime.now().millisecondsSinceEpoch,
            type: JOURNEY_TYPE_STEADY);

        locationCache.putLastJourney(newJourney, userId);
        return newJourney;
      }
    }
  }

  /// Figure out the state of user i.e., steady or moving and save location journey accordingly.
  Future<void> _checkAndSaveLocationJourney(
      String userId,
      LocationData extractedLocation,
      ApiLocationJourney lastKnownJourney) async {
    var locations = locationCache.getLastFiveLocations(userId);
    var geometricMedian =
        locations.isNotEmpty ? _geometricMedianCalculation(locations) : null;

    double distance = 0;

    if (lastKnownJourney.isSteady()) {
      distance = _distanceBetween(geometricMedian ?? extractedLocation,
          lastKnownJourney.toLocationFromSteadyJourney());
    } else if (lastKnownJourney.isMoving()) {
      distance = _distanceBetween(geometricMedian ?? extractedLocation,
          lastKnownJourney.toLocationFromMovingJourney());
    }

    final timeDifference =
        (extractedLocation.timestamp.millisecondsSinceEpoch) -
            (lastKnownJourney.update_at ?? 0);

    if (lastKnownJourney.isSteady()) {
      if (distance > MIN_DISTANCE) {
        // Here, means last known journey is steady and and now user has started moving
        // Save journey for moving user and update cache as well:
        await _saveJourneyWhenUserStartsMoving(userId, extractedLocation,
            lastKnownJourney, distance, timeDifference);
      }
    } else {
      // Here, means last known journey is moving and user is still moving
      // Save journey for moving user and update last known journey.
      // Note: Need to use lastKnownJourney.id as journey id because we are updating the journey
      if (distance < MIN_DISTANCE && timeDifference > MIN_TIME_DIFFERENCE) {
        await _saveJourneyOnJourneyStopped(
            userId, extractedLocation, lastKnownJourney,
            distance: distance);
      } else if (distance > MIN_DISTANCE) {
        await _updateJourneyForContinuedMovingUser(
            userId, extractedLocation, lastKnownJourney, distance);
      }
    }
  }

  /// Save journey when user starts moving i.e., state changes from steady to moving
  Future<void> _saveJourneyWhenUserStartsMoving(
      String userId,
      LocationData extractedLocation,
      ApiLocationJourney lastKnownJourney,
      double distance,
      int duration) async {
    final lastFiveLocations = locationCache.getLastFiveLocations(userId);

    await journeyService.updateLastLocationJourney(
        userId,
        lastKnownJourney.copyWith(
            update_at: DateTime.now().millisecondsSinceEpoch));

    final newJourney = await journeyService.saveCurrentJourney(
        userId: userId,
        fromLatitude: lastKnownJourney.from_latitude,
        fromLongitude: lastKnownJourney.from_longitude,
        toLatitude: extractedLocation.latitude,
        toLongitude: extractedLocation.longitude,
        routes: lastFiveLocations
            .map((location) => JourneyRoute(
                latitude: location.latitude, longitude: location.longitude))
            .toList(),
        routeDistance: distance,
        routeDuration: duration,
        type: JOURNEY_TYPE_MOVING);

    locationCache.putLastJourney(newJourney, userId);
  }

  /// Update journey for continued moving user i.e., state is moving and user is still moving
  Future<void> _updateJourneyForContinuedMovingUser(
    String userId,
    LocationData extractedLocation,
    ApiLocationJourney lastKnownJourney,
    double distance,
  ) async {
    var journey = ApiLocationJourney(
        id: lastKnownJourney.id,
        user_id: userId,
        from_latitude: lastKnownJourney.from_latitude,
        from_longitude: lastKnownJourney.from_longitude,
        to_latitude: extractedLocation.latitude,
        to_longitude: extractedLocation.longitude,
        route_distance: distance + (lastKnownJourney.route_distance ?? 0),
        route_duration: (lastKnownJourney.update_at ?? 0) -
            (lastKnownJourney.created_at ?? 0),
        routes: lastKnownJourney.routes +
            [
              JourneyRoute(
                latitude: extractedLocation.latitude,
                longitude: extractedLocation.longitude,
              )
            ],
        created_at: lastKnownJourney.created_at,
        update_at: DateTime.now().millisecondsSinceEpoch,
        type: JOURNEY_TYPE_MOVING);

    await journeyService.updateLastLocationJourney(userId, journey);
    locationCache.putLastJourney(journey, userId);
  }

  /// Save journey when user stops moving i.e., state changes from moving to steady
  Future<void> _saveJourneyOnJourneyStopped(String userId,
      LocationData extractedLocation, ApiLocationJourney lastKnownJourney,
      {double? distance}) async {
    final routeDistance = (distance ??
            _distanceBetween(lastKnownJourney.toLocationFromMovingJourney(),
                extractedLocation)) +
        (lastKnownJourney.route_distance ?? 0);

    var movingJourney = lastKnownJourney.copyWith(
      to_latitude: extractedLocation.latitude,
      to_longitude: extractedLocation.longitude,
      route_distance: routeDistance,
      route_duration: (lastKnownJourney.update_at ?? 0) -
          (lastKnownJourney.created_at ?? 0),
      routes: lastKnownJourney.routes +
          [
            JourneyRoute(
              latitude: extractedLocation.latitude,
              longitude: extractedLocation.longitude,
            )
          ],
    );

    LocationManager.instance.updateLocationRequest(false);

    journeyService.updateLastLocationJourney(userId, movingJourney);

    // Save journey for steady user and update cache as well:
    var newJourney = await journeyService.saveCurrentJourney(
        userId: userId,
        fromLatitude: extractedLocation.latitude,
        fromLongitude: extractedLocation.longitude,
        created_at: lastKnownJourney.update_at,
        type: JOURNEY_TYPE_STEADY);

    locationCache.putLastJourney(newJourney, userId);
  }

  bool _isOnlyOneDayChanged(
      LocationData? extractedLocation, ApiLocationJourney lastKnownJourney) {
    final lastKnownDate = DateTime.fromMillisecondsSinceEpoch(
            lastKnownJourney.update_at ?? DateTime.now().millisecondsSinceEpoch,
            isUtc: true)
        .toLocal();
    final currentDate = DateTime.fromMillisecondsSinceEpoch(
            extractedLocation?.timestamp.millisecondsSinceEpoch ??
                DateTime.now().millisecondsSinceEpoch,
            isUtc: true)
        .toLocal();

    final daysPassed = currentDate.difference(lastKnownDate).inDays;
    return daysPassed == 1;
  }

  bool _isDayChanged(
      LocationData? extractedLocation, ApiLocationJourney lastKnownJourney) {
    DateTime lastKnownDate = DateTime.fromMillisecondsSinceEpoch(
        lastKnownJourney.update_at ?? DateTime.now().millisecondsSinceEpoch);
    int lastKnownDay = lastKnownDate.day;

    DateTime currentDate = extractedLocation != null
        ? DateTime.fromMillisecondsSinceEpoch(
            extractedLocation.timestamp.millisecondsSinceEpoch)
        : DateTime.now();
    int currentDay = currentDate.day;

    return lastKnownDay != currentDay;
  }

  double _distanceBetween(LocationData loc1, LocationData loc2) {
    return Geolocator.distanceBetween(
      loc1.latitude,
      loc1.longitude,
      loc2.latitude,
      loc2.longitude,
    );
  }

  Future<void> _checkAndSaveLastFiveLocations(
    LocationData extractedLocation,
    String userId,
  ) async {
    var lastFiveLocations =
        locationCache.getLastFiveLocations(userId).take(4).toList();
    lastFiveLocations.insert(0, extractedLocation);

    locationCache.putLastFiveLocations(lastFiveLocations, userId);
  }

  double _distance(LocationData loc1, LocationData loc2) {
    final latDiff = loc1.latitude - loc2.latitude;
    final lngDiff = loc1.longitude - loc2.longitude;
    return sqrt(latDiff * latDiff + lngDiff * lngDiff);
  }

  LocationData _geometricMedianCalculation(List<LocationData> locations) {
    return locations.reduce((candidate, current) {
      double candidateSum = locations
          .map((location) => _distance(candidate, location))
          .reduce((a, b) => a + b);
      double currentSum = locations
          .map((location) => _distance(current, location))
          .reduce((a, b) => a + b);
      return candidateSum < currentSum ? candidate : current;
    });
  }
}
