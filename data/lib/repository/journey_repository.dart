// ignore_for_file: constant_identifier_names

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

  JourneyRepository(this.journeyService);

  Future<void> saveLocationJourney(LocationData extractedLocation, String userId) async {
    try {
      var lastKnownJourney = await getLastKnownLocation(userId, extractedLocation);

      await checkAndSaveLastFiveLocations(extractedLocation, userId);
      await checkAndSaveLocationJourney(userId, extractedLocation, lastKnownJourney);
    } catch (error, stack) {
      logger.e(
        'Journey Repository: Error while save journey',
        error: error, stackTrace: stack
      );
    }
  }

  Future<ApiLocationJourney> getLastKnownLocation(String userId, LocationData extractedLocation) async {
    var lastKnownJourney = locationCache.getLastJourney(userId);

    if (lastKnownJourney != null) {
      return lastKnownJourney;
    } else {
      lastKnownJourney = await journeyService.getLastJourneyLocation(userId);

      if (lastKnownJourney != null) {
        locationCache.putLastJourney(lastKnownJourney, userId);
        return lastKnownJourney;
      } else {
        String newJourneyId = await journeyService.saveCurrentJourney(
          userId: userId,
          fromLatitude: extractedLocation.latitude,
          fromLongitude: extractedLocation.longitude,
          created_at: extractedLocation.timestamp.millisecondsSinceEpoch,
        );
        var locationJourney = ApiLocationJourney.fromPosition(extractedLocation, userId, newJourneyId);
        locationCache.putLastJourney(locationJourney, userId);
        logger.i('get last known location - save current journey: $locationJourney', time: DateTime.now());
        return locationJourney;
      }
    }
  }

  Future<void> checkAndSaveLocationJourney(String userId, LocationData extractedLocation, ApiLocationJourney lastKnownJourney) async {
    var locations = locationCache.getLastFiveLocations(userId);
    var geometricMedian = locations != null && locations.isNotEmpty
        ? geometricMedianCalculation(locations)
        : extractedLocation;

    double distance = lastKnownJourney.isSteadyLocation()
        ? distanceBetween(geometricMedian, lastKnownJourney.toPositionFromSteadyJourney())
        : distanceBetween(geometricMedian, lastKnownJourney.toPositionFromMovingJourney());

    int timeDifference = geometricMedian.timestamp.millisecondsSinceEpoch - lastKnownJourney.update_at!;

    if (lastKnownJourney.isSteadyLocation()) {
      if (distance > MIN_DISTANCE) {
        await saveJourneyWhenUserStartsMoving(userId, extractedLocation, lastKnownJourney);
      }
    } else {
      if (distance > MIN_DISTANCE) {
        await updateJourneyForContinuedMovingUser(userId, extractedLocation, lastKnownJourney);
      } else if (distance < MIN_DISTANCE && timeDifference > MIN_TIME_DIFFERENCE) {
        await saveJourneyOnJourneyStopped(userId, extractedLocation, lastKnownJourney);
      }
    }
  }

  Future<void> saveJourneyWhenUserStartsMoving(String userId, LocationData extractedLocation, ApiLocationJourney lastKnownJourney) async {
    String newJourneyId = await journeyService.saveCurrentJourney(
      userId: userId,
      fromLatitude: lastKnownJourney.from_latitude,
      fromLongitude: lastKnownJourney.from_longitude,
      toLatitude: extractedLocation.latitude,
      toLongitude: extractedLocation.longitude,
    );

    var journey = ApiLocationJourney(
      id: newJourneyId,
      user_id: userId,
      from_latitude: lastKnownJourney.from_latitude,
      from_longitude: lastKnownJourney.from_longitude,
      to_latitude: extractedLocation.latitude,
      to_longitude: extractedLocation.longitude,
      routes: [lastKnownJourney.toRouteFromSteadyJourney(), extractedLocation.toRoute()],
    );

    locationCache.putLastJourney(journey, userId);
    logger.i('save journey when user start moving $journey', time: DateTime.now());
  }

  Future<void> updateJourneyForContinuedMovingUser(String userId, LocationData extractedLocation, ApiLocationJourney lastKnownJourney) async {
    var journey = ApiLocationJourney(
      id: lastKnownJourney.id,
        user_id: userId,
        from_latitude: lastKnownJourney.from_latitude,
        from_longitude: lastKnownJourney.from_longitude,
      to_latitude: extractedLocation.latitude,
      to_longitude: extractedLocation.longitude,
      routes: [...lastKnownJourney.routes, extractedLocation.toRoute()],
      created_at: lastKnownJourney.created_at,
      update_at: DateTime.now().millisecondsSinceEpoch,
    );
    await journeyService.updateLastLocationJourney(userId, journey);
    locationCache.putLastJourney(journey, userId);
    logger.i('update journey for continued moving user: $journey', time: DateTime.now());
  }

  Future<void> saveJourneyOnJourneyStopped(String userId, LocationData extractedLocation, ApiLocationJourney lastKnownJourney) async {
    var movingJourney = ApiLocationJourney(
      id: lastKnownJourney.id,
        user_id: userId,
        from_latitude: lastKnownJourney.from_latitude,
        from_longitude: lastKnownJourney.from_longitude,
      to_latitude: extractedLocation.latitude,
      to_longitude: extractedLocation.longitude,
      routes: [...lastKnownJourney.routes, extractedLocation.toRoute()],
      created_at: lastKnownJourney.created_at,
      update_at: DateTime.now().millisecondsSinceEpoch,
    );

    journeyService.updateLastLocationJourney(userId, movingJourney);

    var newJourneyId = await journeyService.saveCurrentJourney(
      userId: userId,
      fromLatitude: extractedLocation.latitude,
      fromLongitude: extractedLocation.longitude,
      created_at: extractedLocation.timestamp.millisecondsSinceEpoch,
    );

    var steadyJourney = ApiLocationJourney(
      id: newJourneyId,
      user_id: userId,
      from_latitude: extractedLocation.latitude,
      from_longitude: extractedLocation.longitude,
    );

    locationCache.putLastJourney(steadyJourney, userId);
    logger.i('save journey on journey stopped: $steadyJourney', time: DateTime.now());
  }

  double distanceBetween(LocationData loc1, LocationData loc2) {
    return Geolocator.distanceBetween(
      loc1.latitude,
      loc1.longitude,
      loc2.latitude,
      loc2.longitude,
    );
  }

  Future<void> checkAndSaveLastFiveLocations(LocationData extractedLocation, String userId) async {
    var lastFiveLocations = locationCache.getLastFiveLocations(userId) ?? [];
    lastFiveLocations.add(extractedLocation);
    locationCache.putLastFiveLocations(lastFiveLocations, userId);
  }

  LocationData geometricMedianCalculation(List<LocationData> locations) {
    return locations.reduce((a, b) {
      var totalDistanceA = locations.map((loc) => distanceBetween(a, loc)).reduce((a, b) => a + b);
      var totalDistanceB = locations.map((loc) => distanceBetween(b, loc)).reduce((a, b) => a + b);
      return totalDistanceA < totalDistanceB ? a : b;
    });
  }
}
