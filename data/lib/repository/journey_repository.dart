// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:data/api/location/journey/journey.dart';
import 'package:data/api/location/location.dart';
import 'package:data/log/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../api/location/journey/api_journey_service.dart';
import '../storage/location_caches.dart';

const MIN_DISTANCE = 150.0; // 150 meters
const MIN_TIME_DIFFERENCE = 5 * 60 * 1000; // 5 minutes

final journeyRepositoryProvider = Provider((ref) => JourneyRepository(
      ref.read(journeyServiceProvider),
    ));

class JourneyRepository {
  final ApiJourneyService journeyService;
  final LocationCache locationCache = LocationCache();
  Timer? _steadyLocationTimer;

  JourneyRepository(this.journeyService);

  Future<void> saveLocationJourney(
    LocationData extractedLocation,
    String userId,
  ) async {
    try {
      _cancelSteadyLocationTimer();
      _startSteadyLocationTimer(extractedLocation, userId);

      var lastKnownJourney = await getLastKnownLocation(userId, extractedLocation);
      addJourneyOnDayChange(extractedLocation, lastKnownJourney, userId);

      locationCache.addLocation(extractedLocation, userId); // to get all route position between location a -> b for moving user journey

      // Check add add extracted location to last five locations to calculate geometric median
      await _checkAndSaveLastFiveLocations(extractedLocation, userId);

      // Check and save location journey based on user state i.e., steady or moving
      await _checkAndSaveLocationJourney(
          userId, extractedLocation, lastKnownJourney);
    } catch (error, stack) {
      logger.e(
          'Journey Repository: Error while save journey, $extractedLocation',
          error: error,
          stackTrace: stack);
    }
  }

  /// Start or restart the 5-minute timer when the user is steady.
  void _startSteadyLocationTimer(LocationData position, String userId) {
    var lastLocation = locationCache.getLastJourney(userId)?.toPositionFromSteadyJourney();
    var lastLocationJourney = locationCache.getLastJourney(userId);
    if (lastLocation != null && _isSameLocation(position, lastLocation) && lastLocationJourney!.isSteadyLocation()) {
      return;
    }

    _steadyLocationTimer = Timer(const Duration(minutes: 5), () async {
      try {
        await _saveSteadyLocation(position, userId);
        _cancelSteadyLocationTimer();
        locationCache.clearLocationCache(); // removing previous journey routes to get latest location route for next journey from start point to end
      } catch (e, stack) {
        logger.e('Error saving steady location for user $userId: $e', stackTrace: stack);
      }
    });
  }

  bool _isSameLocation(LocationData loc1, LocationData loc2) {
    return loc1.latitude == loc2.latitude &&
        loc1.longitude == loc2.longitude;
  }

  Future<void> _saveSteadyLocation(LocationData position, String userId) async {
    var lastKnownJourney = await getLastKnownLocation(userId, position);
    await _saveJourneyOnJourneyStopped(userId, position, lastKnownJourney, 0);
  }

  /// Cancel the timer if the user starts moving or a new location arrives before 5 minutes.
  void _cancelSteadyLocationTimer() {
    if (_steadyLocationTimer != null) {
      _steadyLocationTimer?.cancel();
      _steadyLocationTimer = null;
    }
  }

  Future<void> addJourneyOnDayChange(LocationData? extractedLocation, ApiLocationJourney lasKnownJourney, String userId) async {
    bool isDayChanged = this.isDayChanged(extractedLocation, lasKnownJourney);

    if (isDayChanged) {
      // Day is changed between last known journey and current location
      // Just save again the last known journey in remote database with updated day i.e., current time
      await _saveJourneyOnDayChanged(userId, lasKnownJourney);
      return;
    }
  }

  bool isDayChanged(LocationData? extractedLocation, ApiLocationJourney lastKnownJourney) {
    var lastKnownDate =
        DateTime.fromMillisecondsSinceEpoch(lastKnownJourney.update_at!);
    var extractedDate = DateTime.fromMillisecondsSinceEpoch(extractedLocation?.timestamp.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch);

    return lastKnownDate.day != extractedDate.day;
  }

  Future<void> _saveJourneyOnDayChanged(
      String userId, ApiLocationJourney lastKnownJourney) async {
    String newJourneyId = await journeyService.saveCurrentJourney(
      userId: userId,
      fromLatitude: lastKnownJourney.from_latitude,
      fromLongitude: lastKnownJourney.from_longitude,
      toLatitude: lastKnownJourney.to_latitude ?? 0,
      toLongitude: lastKnownJourney.to_longitude ?? 0,
      routeDistance: lastKnownJourney.route_distance,
      routes: lastKnownJourney.routes,
      routeDuration: lastKnownJourney.route_duration,
    );

    var newJourney = lastKnownJourney.copyWith(
      id: newJourneyId,
      created_at: DateTime.now().millisecondsSinceEpoch,
      update_at: DateTime.now().millisecondsSinceEpoch,
    );

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

        String newJourneyId = await journeyService.saveCurrentJourney(
          userId: userId,
          fromLatitude: extractedLocation?.latitude ?? 0,
          fromLongitude: extractedLocation?.longitude ?? 0,
          created_at: DateTime.now().millisecondsSinceEpoch,
        );
        var locationJourney = ApiLocationJourney.fromPosition(
            extractedLocation ??
                LocationData(
                    latitude: 0, longitude: 0, timestamp: DateTime.now()),
            userId,
            newJourneyId);
        locationCache.putLastJourney(locationJourney, userId);
        return locationJourney;
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

    double distance = lastKnownJourney.isSteadyLocation()
        ? _distanceBetween(geometricMedian ?? extractedLocation,
            lastKnownJourney.toPositionFromSteadyJourney())
        : _distanceBetween(geometricMedian ?? extractedLocation,
            lastKnownJourney.toPositionFromMovingJourney());

    if (lastKnownJourney.isSteadyLocation()) {
      if (distance > MIN_DISTANCE) {
        // Here, means last known journey is steady and and now user has started moving
        // Save journey for moving user and update cache as well:

        await _saveJourneyWhenUserStartsMoving(
            userId, extractedLocation, lastKnownJourney, distance);
      }
    } else {
      if (distance > MIN_DISTANCE) {
        // Here, means last known journey is moving and user is still moving
        // Save journey for moving user and update last known journey.
        // Note: Need to use lastKnownJourney.id as journey id because we are updating the journey

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
      double distance) async {
    String newJourneyId = await journeyService.saveCurrentJourney(
      userId: userId,
      fromLatitude: lastKnownJourney.from_latitude,
      fromLongitude: lastKnownJourney.from_longitude,
      toLatitude: extractedLocation.latitude,
      toLongitude: extractedLocation.longitude,
      routeDistance: distance,
      routeDuration: null,
    );

    var journey = ApiLocationJourney(
      id: newJourneyId,
      user_id: userId,
      from_latitude: lastKnownJourney.from_latitude,
      from_longitude: lastKnownJourney.from_longitude,
      to_latitude: extractedLocation.latitude,
      to_longitude: extractedLocation.longitude,
      routes: _getRoute(userId),
      route_distance: distance,
      route_duration: null,
      created_at: lastKnownJourney.created_at,
      update_at: DateTime.now().millisecondsSinceEpoch,
    );

    locationCache.putLastJourney(journey, userId);
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
      routes: _getRoute(userId),
      created_at: lastKnownJourney.created_at,
      update_at: DateTime.now().millisecondsSinceEpoch,
    );

    await journeyService.updateLastLocationJourney(userId, journey);
    locationCache.putLastJourney(journey, userId);
  }

  /// Save journey when user stops moving i.e., state changes from moving to steady
  Future<void> _saveJourneyOnJourneyStopped(
      String userId,
      LocationData extractedLocation,
      ApiLocationJourney lastKnownJourney,
      double distance) async {
    var movingJourney = ApiLocationJourney(
      id: lastKnownJourney.id,
      user_id: userId,
      from_latitude: lastKnownJourney.from_latitude,
      from_longitude: lastKnownJourney.from_longitude,
      to_latitude: extractedLocation.latitude,
      to_longitude: extractedLocation.longitude,
      route_distance: distance + (lastKnownJourney.route_distance ?? 0),
      route_duration: (lastKnownJourney.update_at ?? 0) -
          (lastKnownJourney.created_at ?? 0),
      routes: _getRoute(userId),
      created_at: lastKnownJourney.created_at,
      update_at: lastKnownJourney.update_at,
    );

    journeyService.updateLastLocationJourney(userId, movingJourney);

    // Save journey for steady user and update cache as well:
    var newJourneyId = await journeyService.saveCurrentJourney(
      userId: userId,
      fromLatitude: extractedLocation.latitude,
      fromLongitude: extractedLocation.longitude,
      created_at: lastKnownJourney.update_at,
    );

    var steadyJourney = ApiLocationJourney(
      id: newJourneyId,
      user_id: userId,
      from_latitude: extractedLocation.latitude,
      from_longitude: extractedLocation.longitude,
      created_at: DateTime.now().millisecondsSinceEpoch,
      update_at: DateTime.now().millisecondsSinceEpoch,
    );

    locationCache.putLastJourney(steadyJourney, userId);
  }

  List<JourneyRoute> _getRoute(String userId) {
    var locations = locationCache.getLocations(userId);

    return locations.map((location) {
      return JourneyRoute(
        latitude: location.latitude,
        longitude: location.longitude,
      );
    }).toList();
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
      LocationData extractedLocation, String userId) async {
    var lastFiveLocations = locationCache.getLastFiveLocations(userId);
    lastFiveLocations.add(extractedLocation);
    locationCache.putLastFiveLocations(lastFiveLocations, userId);
  }

  LocationData _geometricMedianCalculation(List<LocationData> locations) {
    LocationData result = locations.reduce((candidate, location) {
      double candidateSum = locations.fold(
          0.0, (sum, loc) => sum + _distanceBetween(candidate, loc));
      double locationSum = locations.fold(
          0.0, (sum, loc) => sum + _distanceBetween(location, loc));

      return candidateSum < locationSum ? candidate : location;
    });

    return result;
  }
}
