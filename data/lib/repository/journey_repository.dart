// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:data/api/location/journey/journey.dart';
import 'package:data/api/location/location.dart';
import 'package:data/domain/location_data_extension.dart';
import 'package:data/log/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../api/location/journey/api_journey_service.dart';
import '../storage/location_caches.dart';

const MIN_DISTANCE = 150.0; // 150 meters
const MIN_TIME_DIFFERENCE = 5 * 60 * 1000; // 5 minutes
const MIN_DISTANCE_FOR_MOVING = 10.0; // 10 meters
const MIN_UPDATE_INTERVAL_MINUTE = 60 * 1000; // 1 minute

final journeyRepositoryProvider = Provider((ref) => JourneyRepository(
      ref.read(journeyServiceProvider),
    ));

class JourneyRepository {
  final ApiJourneyService journeyService;
  final LocationCache locationCache = LocationCache();
  Timer? _steadyLocationTimer;

  JourneyRepository(this.journeyService);

  Future<void> saveLocationJourney({
    required LocationData extractedLocation,
    required String userId,
    bool? fromHomeViewModel,
  }) async {
    try {
      var lastKnownJourney =
          await getLastKnownLocation(userId, extractedLocation);

      // Check and save location journey on day changed
      checkAndSaveJourneyOnDayChange(
          extractedLocation: extractedLocation,
          lastKnownJourney: lastKnownJourney,
          userId: userId,
          fromHomeViewModel: fromHomeViewModel);

      // to get all route position between location a -> b for moving user journey
      locationCache.addLocation(extractedLocation, userId);

      // Check add add extracted location to last five locations to calculate geometric median
      await _checkAndSaveLastFiveLocations(extractedLocation, userId);

      // Check and save location journey based on user state i.e., steady or moving
      await _checkAndSaveLocationJourney(
          userId, extractedLocation, lastKnownJourney);

      _cancelSteadyLocationTimer();
      _startSteadyLocationTimer(extractedLocation, userId);
    } catch (error, stack) {
      logger.e(
          'Journey Repository: Error while save journey, $extractedLocation',
          error: error,
          stackTrace: stack);
    }
  }

  /// Start or restart the 5-minute timer when the user is steady.
  void _startSteadyLocationTimer(LocationData position, String userId) async {
    var lastLocation =
        locationCache.getLastJourney(userId)?.toLocationFromSteadyJourney();
    var lastLocationJourney = await getLastKnownLocation(userId, position);
    if (lastLocation != null &&
        _isSameLocation(position, lastLocation) ||
        lastLocationJourney.isSteadyLocation()) {
      return;
    }

    _steadyLocationTimer = Timer(const Duration(minutes: 5), () async {
      try {
        await _saveSteadyLocation(position, userId);
        _cancelSteadyLocationTimer();
        locationCache.clearLocationCache(); // removing previous journey routes to get latest location route for next journey from start point to end
      } catch (e, stack) {
        logger.e('Error saving steady location for user $userId: $e',
            stackTrace: stack);
      }
    });
  }

  bool _isSameLocation(LocationData loc1, LocationData loc2) {
    return loc1.latitude == loc2.latitude && loc1.longitude == loc2.longitude;
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

  Future<void> checkAndSaveJourneyOnDayChange({required LocationData? extractedLocation,
      required ApiLocationJourney lastKnownJourney, required String userId, bool? fromHomeViewModel}) async {
    if (fromHomeViewModel ?? false) return;
    bool dayChanged = _isDayChanged(extractedLocation, lastKnownJourney);
    bool isOnlyOneDayChange = _isOnlyOneDayChanged(extractedLocation, lastKnownJourney);

    if (dayChanged && isOnlyOneDayChange) {
      _updateJourneyOnDayChanged(userId, lastKnownJourney);
    } else if (dayChanged && extractedLocation != null) {
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
        var locationJourney = extractedLocation!.toLocationJourney(userId, newJourneyId);
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
    print('check and save location journey');

    if (lastKnownJourney.isSteadyLocation()) {
      print('distance between form steady location ${_distanceBetween(extractedLocation, lastKnownJourney.toLocationFromSteadyJourney())}');
      print('to location from steady journey = ${lastKnownJourney.toLocationFromSteadyJourney().latitude} - ${lastKnownJourney.toLocationFromSteadyJourney().longitude}');
    } else {
      print('distance between from moving location ${_distanceBetween(extractedLocation, lastKnownJourney.toLocationFromMovingJourney())}');
      print('to location from moving journey = ${lastKnownJourney.toLocationFromMovingJourney().latitude} - ${lastKnownJourney.toLocationFromMovingJourney().longitude}');
    }

    double distance = lastKnownJourney.isSteadyLocation()
        ? _distanceBetween(extractedLocation,
            lastKnownJourney.toLocationFromSteadyJourney())
        : _distanceBetween(extractedLocation,
            lastKnownJourney.toLocationFromMovingJourney());

    print(distance);
    if (lastKnownJourney.isSteadyLocation()) {
      if (distance > MIN_DISTANCE) {
        // Here, means last known journey is steady and and now user has started moving
        // Save journey for moving user and update cache as well:

        print('save journey hen user start moving');
        await _saveJourneyWhenUserStartsMoving(
            userId, extractedLocation, lastKnownJourney, distance);
      }
    } else {
        // Here, means last known journey is moving and user is still moving
        // Save journey for moving user and update last known journey.
        // Note: Need to use lastKnownJourney.id as journey id because we are updating the journey

        if (distance > MIN_DISTANCE_FOR_MOVING) {
          print('update journey for continued moving user');
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
      routeDuration: null,
      created_at: extractedLocation.timestamp.millisecondsSinceEpoch,
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
      created_at: extractedLocation.timestamp.millisecondsSinceEpoch,
      update_at: DateTime.now().millisecondsSinceEpoch,
    );

    locationCache.putLastJourney(journey, userId);
    locationCache.putLastJourneyUpdatedTime(DateTime.now().millisecondsSinceEpoch, userId);
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
      update_at: extractedLocation.timestamp.millisecondsSinceEpoch,
    );

    final lastJourneyUpdatedTime = locationCache.getLastJourneyUpdatedTime(userId);
    final timeDifference = journey.update_at! - lastJourneyUpdatedTime;

    if (timeDifference >= MIN_UPDATE_INTERVAL_MINUTE) {
      await journeyService.updateLastLocationJourney(userId, journey);
      locationCache.putLastJourneyUpdatedTime(DateTime.now().millisecondsSinceEpoch, userId);
    }
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
      created_at: lastKnownJourney.update_at,
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

  bool _isOnlyOneDayChanged(LocationData? extractedLocation, ApiLocationJourney lastKnownJourney) {
    final lastKnownDate = DateTime.fromMillisecondsSinceEpoch(lastKnownJourney.update_at!).toLocal();
    final currentDate = DateTime.fromMillisecondsSinceEpoch(
      extractedLocation?.timestamp.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch,
    ).toLocal();

    final daysPassed = currentDate.difference(lastKnownDate).inDays;

    return daysPassed == 1;
  }

  bool _isDayChanged( LocationData? extractedLocation, ApiLocationJourney lastKnownJourney) {
    final lastKnownTime = DateTime.fromMillisecondsSinceEpoch(lastKnownJourney.update_at!);
    final currentTime = DateTime.fromMillisecondsSinceEpoch(
      extractedLocation?.timestamp.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch,
    );

    final lastKnownDay = lastKnownTime.day;
    final currentDay = currentTime.day;

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
    var lastFiveLocations = locationCache.getLastFiveLocations(userId);
    lastFiveLocations.add(extractedLocation);
    locationCache.putLastFiveLocations(lastFiveLocations, userId);
  }
}
