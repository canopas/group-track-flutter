// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/api/location/journey/journey.dart';
import 'package:data/api/location/location.dart';
import 'package:data/domain/location_data_extension.dart';
import 'package:data/log/logger.dart';
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
      print("XXX first in saveLocationJourney");
      _steadyLocationTimer?.cancel();
      _steadyLocationTimer = null;

      var lastKnownJourney =
          await getLastKnownLocation(userId, extractedLocation);

      // Check and save location journey on day changed
      print("XXX check on day change");

      checkAndSaveJourneyOnDayChange(
          extractedLocation: extractedLocation,
          lastKnownJourney: lastKnownJourney,
          userId: userId);

      // to get all route position between location a -> b for moving user journey
      print("XXX add location");

      locationCache.addLocation(extractedLocation, userId);

      // Check add add extracted location to last five locations to calculate geometric median
      await _checkAndSaveLastFiveLocations(extractedLocation, userId);

      // Check and save location journey based on user state i.e., steady or moving
      await _checkAndSaveLocationJourney(
          userId, extractedLocation, lastKnownJourney);

      _startSteadyLocationTimer(extractedLocation, userId);
      print("XXX .........exit location update journey............");
    } catch (error, stack) {
      logger.e(
          'Journey Repository: Error while save journey, $extractedLocation',
          error: error,
          stackTrace: stack);
    }
  }

  // Start or restart the 5-minute timer when the user is steady.
  void _startSteadyLocationTimer(LocationData position, String userId) async {
    var lastLocation =
        locationCache.getLastJourney(userId)?.toLocationFromSteadyJourney();
    var lastLocationJourney = await getLastKnownLocation(userId, position);
    if (lastLocation != null && _isSameLocation(position, lastLocation) ||
        lastLocationJourney.isSteadyLocation()) {
      print("XXX time return");
      return;
    }

    _steadyLocationTimer = Timer(const Duration(minutes: 5), () async {
      try {
        print("XXX timer call to set steady location");
        await _saveSteadyLocation(position, userId, lastLocationJourney);
        // removing previous journey routes to get latest location route for next journey from start point to end
        locationCache.clearLocationCache();
      } catch (e, stack) {
        logger.e('Error saving steady location for user $userId: $e',
            stackTrace: stack);
      }
    });
  }

  bool _isSameLocation(LocationData loc1, LocationData loc2) {
    return loc1.latitude == loc2.latitude && loc1.longitude == loc2.longitude;
  }

  Future<void> _saveSteadyLocation(LocationData position, String userId,
      ApiLocationJourney? lastLocation) async {
    var lastKnownJourney = await getLastKnownLocation(userId, position);

    if (lastKnownJourney.id != lastLocation?.id) return;
    if (lastKnownJourney.isSteadyLocation()) return;

    var locations = locationCache.getLastFiveLocations(userId);

    var geometricMedian =
        locations.isNotEmpty ? _geometricMedian(locations) : null;

    double distance = _distanceBetween(geometricMedian ?? position,
        lastKnownJourney.toLocationFromSteadyJourney());
    await _saveJourneyOnJourneyStopped(
        userId, position, lastKnownJourney, distance);
  }

  Future<void> checkAndSaveJourneyOnDayChange(
      {required LocationData? extractedLocation,
      required ApiLocationJourney lastKnownJourney,
      required String userId}) async {
    bool dayChanged = _isDayChanged(extractedLocation, lastKnownJourney);
    bool isOnlyOneDayChange =
        _isOnlyOneDayChanged(extractedLocation, lastKnownJourney);

    print("XXX is day changed $dayChanged, $isOnlyOneDayChange");
    if (dayChanged && isOnlyOneDayChange) {
      print("XXX in if");

      _updateJourneyOnDayChanged(userId, lastKnownJourney);
    } else if (dayChanged && extractedLocation != null) {
      print("XXX in else");

      _saveJourneyOnDayChanged(userId, extractedLocation);
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
    String newJourneyId = await journeyService.saveCurrentJourney(
      userId: userId,
      fromLatitude: extractedLocation.latitude,
      fromLongitude: extractedLocation.longitude,
    );

    var newJourney = extractedLocation
        .toLocationJourney(userId, newJourneyId)
        .copyWith(id: newJourneyId);

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
      print("XXX get lastKnownJourney 1");
      // Return last location journey if available from cache
      return lastKnownJourney;
    } else {
      // Here, means no location journey available in cache
      // Fetch last location journey from remote database and save it to cache
      print("XXX call api for get lastKnownJourney else");

      lastKnownJourney = await journeyService.getLastJourneyLocation(userId);

      if (lastKnownJourney != null) {
        print("XXX get api data lastKnownJourney");

        locationCache.putLastJourney(lastKnownJourney, userId);
        return lastKnownJourney;
      } else {
        print("XXX api data null for lastKnownJourney create new");

        // Here, means no location journey available in remote database as well
        // Possibly user is new or no location journey available
        // Save extracted location as new location journey with steady state in cache

        String newJourneyId = await journeyService.saveCurrentJourney(
          userId: userId,
          fromLatitude: extractedLocation?.latitude ?? 0,
          fromLongitude: extractedLocation?.longitude ?? 0,
          created_at: DateTime.now().millisecondsSinceEpoch,
        );
        var locationJourney =
            extractedLocation!.toLocationJourney(userId, newJourneyId);
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
    print("XXX _checkAndSaveLocationJourney");
    var locations = locationCache.getLastFiveLocations(userId);
    for (var location in locations) {
      print(
          "XXX get last five location: ${location.latitude},${location.longitude}");
    }

    var geometricMedian =
        locations.isNotEmpty ? _geometricMedian(locations) : null;

    double distance = lastKnownJourney.isSteadyLocation()
        ? _distanceBetween(geometricMedian ?? extractedLocation,
            lastKnownJourney.toLocationFromSteadyJourney())
        : _distanceBetween(geometricMedian ?? extractedLocation,
            lastKnownJourney.toLocationFromMovingJourney());

    final timeDifference = (geometricMedian?.timestamp.millisecondsSinceEpoch ??
            extractedLocation.timestamp.millisecondsSinceEpoch) -
        (lastKnownJourney.update_at ?? 0);

    print(
        "XXX checkAndSaveLocationJourney: $geometricMedian, $lastKnownJourney");
    print("XXX check item :$distance,:$timeDifference");
    if (lastKnownJourney.isSteadyLocation()) {
      print("XXX get in steady");
      if (distance > MIN_DISTANCE) {
        // Here, means last known journey is steady and and now user has started moving
        // Save journey for moving user and update cache as well:
        print("XXX get in steady distance is more then 150");
        await _saveJourneyWhenUserStartsMoving(userId, extractedLocation,
            lastKnownJourney, distance, timeDifference);
      }
    } else {
      // Here, means last known journey is moving and user is still moving
      // Save journey for moving user and update last known journey.
      // Note: Need to use lastKnownJourney.id as journey id because we are updating the journey
      print("XXX get in else");

      if (distance > MIN_DISTANCE_FOR_MOVING) {
        print("XXX get in moving");

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
    journeyService.updateLastLocationJourney(
        userId,
        lastKnownJourney.copyWith(
            update_at: DateTime.now().millisecondsSinceEpoch));

    String newJourneyId = await journeyService.saveCurrentJourney(
      userId: userId,
      fromLatitude: lastKnownJourney.from_latitude,
      fromLongitude: lastKnownJourney.from_longitude,
      toLatitude: extractedLocation.latitude,
      toLongitude: extractedLocation.longitude,
      routeDistance: distance,
      routeDuration: duration,
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
      route_duration: duration,
      created_at: DateTime.now().millisecondsSinceEpoch,
      update_at: DateTime.now().millisecondsSinceEpoch,
    );

    locationCache.putLastJourney(journey, userId);
    locationCache.putLastJourneyUpdatedTime(
        DateTime.now().millisecondsSinceEpoch, userId);
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
    );

    final lastJourneyUpdatedTime =
        locationCache.getLastJourneyUpdatedTime(userId);
    final timeDifference = journey.update_at! - lastJourneyUpdatedTime;

    if (timeDifference >= MIN_UPDATE_INTERVAL_MINUTE) {
      await journeyService.updateLastLocationJourney(userId, journey);
      locationCache.putLastJourneyUpdatedTime(
          DateTime.now().millisecondsSinceEpoch, userId);
    }
    locationCache.putLastJourney(journey, userId);
  }

  /// Save journey when user stops moving i.e., state changes from moving to steady
  Future<void> _saveJourneyOnJourneyStopped(
      String userId,
      LocationData extractedLocation,
      ApiLocationJourney lastKnownJourney,
      double distance) async {
    print("XXX _saveJourneyOnJourneyStopped");
    var movingJourney = lastKnownJourney.copyWith(
      to_latitude: extractedLocation.latitude,
      to_longitude: extractedLocation.longitude,
      route_distance: distance + (lastKnownJourney.route_distance ?? 0),
      route_duration: (lastKnownJourney.update_at ?? 0) -
          (lastKnownJourney.created_at ?? 0),
    );

    print("XXX save steady location:$movingJourney");

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
      created_at: lastKnownJourney.update_at,
    );
    print("XXX update steady to cache location:$steadyJourney");

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
      LocationData extractedLocation, String userId) async {
    print("XXX save last five locations");
    var lastFiveLocations = locationCache.getLastFiveLocations(userId);
    print("XXX last five locations:$lastFiveLocations");
    lastFiveLocations.add(extractedLocation);
    locationCache.putLastFiveLocations(lastFiveLocations, userId);
  }

  double distance(LocationData loc1, LocationData loc2) {
    final latDiff = loc1.latitude - loc2.latitude;
    final lngDiff = loc1.longitude - loc2.longitude;
    return sqrt(latDiff * latDiff + lngDiff * lngDiff);
  }

  LocationData _geometricMedian(List<LocationData> locations) {
    return locations.reduce((candidate, current) {
      double candidateSum = locations
          .map((location) => distance(candidate, location))
          .reduce((a, b) => a + b);
      double currentSum = locations
          .map((location) => distance(current, location))
          .reduce((a, b) => a + b);

      return candidateSum < currentSum ? candidate : current;
    });
  }
}
