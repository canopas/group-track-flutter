// ignore_for_file: constant_identifier_names

import 'dart:math';

import 'package:data/api/location/location.dart';
import 'package:geolocator/geolocator.dart';

import '../api/location/journey/journey.dart';

const MIN_DISTANCE = 100.0; // 100 meters
const MIN_TIME_DIFFERENCE = 5 * 60 * 1000; // 5 minutes
const MIN_DISTANCE_FOR_MOVING = 10.0; // 10 meters
const MIN_UPDATE_INTERVAL_MINUTE = 30000; // 30 secs

({ApiLocationJourney? updatedJourney, ApiLocationJourney? newJourney})?
    getJourney(String userId,
        {required LocationData newLocation,
        ApiLocationJourney? lastKnownJourney,
        required List<LocationData> lastLocations}) {
  if (lastKnownJourney == null) {
    return (
      updatedJourney: null,
      newJourney: ApiLocationJourney(
        user_id: userId,
        from_latitude: newLocation.latitude,
        from_longitude: newLocation.longitude,
        type: JOURNEY_TYPE_STEADY,
        created_at: DateTime.now().millisecondsSinceEpoch,
        update_at: DateTime.now().millisecondsSinceEpoch,
      )
    );
  }
  var geometricMedian = lastLocations.isNotEmpty
      ? _geometricMedianCalculation(lastLocations)
      : null;

  double distance = 0;

  if (lastKnownJourney.isSteady()) {
    distance = _distanceBetween(geometricMedian ?? newLocation,
        lastKnownJourney.toLocationFromSteadyJourney());
  } else if (lastKnownJourney.isMoving()) {
    distance = _distanceBetween(geometricMedian ?? newLocation,
        lastKnownJourney.toLocationFromMovingJourney());
  }

  final timeDifference = (newLocation.timestamp.millisecondsSinceEpoch) -
      (lastKnownJourney.update_at ?? 0);

  bool dayChanged = _isDayChanged(newLocation, lastKnownJourney);

  if (lastKnownJourney.isSteady() && distance < MIN_DISTANCE && dayChanged) {
    final updateJourney = lastKnownJourney.copyWith(
      from_latitude: newLocation.latitude,
      from_longitude: newLocation.longitude,
      update_at: DateTime.now().millisecondsSinceEpoch,
    );
    return (updatedJourney: updateJourney, newJourney: null);
  }

  /* Manage journey
  1. lastKnownJourney is null, create a new journey
  2. If user is stationary
     a. update the journey with the last location and update the update_at
     b. If distance > 150,
        - update the journey with the last location and update the update_at
        - create a new moving journey
  3. If user is moving
      a. If distance > 150, update the last location, route and update_at
      b. If distance < 150 and time diff between two location updates > 5 mins,
          - update the journey with the last location and update the update_at, and stop the journey
          - create a new stationary journey */

  if (lastKnownJourney.isSteady()) {
    if (distance > MIN_DISTANCE) {
      // update last steady journey
      final updatedJourney = lastKnownJourney.copyWith(
        from_latitude: newLocation.latitude,
        from_longitude: newLocation.longitude,
        update_at: DateTime.now().millisecondsSinceEpoch,
      );

      // create new moving journey
      final newJourney = ApiLocationJourney(
        user_id: userId,
        from_latitude: lastKnownJourney.from_latitude,
        from_longitude: lastKnownJourney.from_longitude,
        to_latitude: newLocation.latitude,
        to_longitude: newLocation.longitude,
        type: JOURNEY_TYPE_MOVING,
        route_distance: distance,
        route_duration: timeDifference,
        created_at: DateTime.now().millisecondsSinceEpoch,
        update_at: DateTime.now().millisecondsSinceEpoch,
      );

      return (updatedJourney: updatedJourney, newJourney: newJourney);
    } else if (distance < MIN_DISTANCE &&
        timeDifference > MIN_UPDATE_INTERVAL_MINUTE) {
      final updateJourney = lastKnownJourney.copyWith(
        from_latitude: newLocation.latitude,
        from_longitude: newLocation.longitude,
        update_at: DateTime.now().millisecondsSinceEpoch,
      );
      return (updatedJourney: updateJourney, newJourney: null);
    }
  } else {
    // Save journey when user stops moving i.e., state changes from moving to stationary
    if (timeDifference > MIN_TIME_DIFFERENCE) {
      // update last moving journey
      final updatedJourney = lastKnownJourney.copyWith(
        to_latitude: newLocation.latitude,
        to_longitude: newLocation.longitude,
        route_distance: distance,
        route_duration: (lastKnownJourney.update_at ?? 0) -
            (lastKnownJourney.created_at ?? 0),
        routes: lastKnownJourney.routes +
            [
              JourneyRoute(
                latitude: newLocation.latitude,
                longitude: newLocation.longitude,
              )
            ],
      );

      // create new steady journey
      final newJourney = ApiLocationJourney(
        user_id: userId,
        from_latitude: newLocation.latitude,
        from_longitude: newLocation.longitude,
        type: JOURNEY_TYPE_STEADY,
        created_at: lastKnownJourney.update_at ?? DateTime.now().millisecondsSinceEpoch,
        update_at: DateTime.now().millisecondsSinceEpoch,
      );
      return (updatedJourney: updatedJourney, newJourney: newJourney);
    } else if (distance > MIN_DISTANCE_FOR_MOVING &&
        timeDifference > MIN_UPDATE_INTERVAL_MINUTE) {
      // Update journey for continued moving user i.e., state is moving and user is still moving
      final updatedJourney = lastKnownJourney.copyWith(
        to_latitude: newLocation.latitude,
        to_longitude: newLocation.longitude,
        route_distance: distance + (lastKnownJourney.route_distance ?? 0),
        route_duration: (lastKnownJourney.update_at ?? 0) -
            (lastKnownJourney.created_at ?? 0),
        routes: lastKnownJourney.routes +
            [
              JourneyRoute(
                latitude: newLocation.latitude,
                longitude: newLocation.longitude,
              )
            ],
        update_at: DateTime.now().millisecondsSinceEpoch,
      );

      return (updatedJourney: updatedJourney, newJourney: null);
    }
  }

  return null;
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

double _distance(LocationData loc1, LocationData loc2) {
  final latDiff = loc1.latitude - loc2.latitude;
  final lngDiff = loc1.longitude - loc2.longitude;
  return sqrt(latDiff * latDiff + lngDiff * lngDiff);
}
