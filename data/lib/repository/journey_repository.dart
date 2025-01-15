// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/api/location/journey/journey.dart';
import 'package:data/api/location/location.dart';
import 'package:data/log/logger.dart';
import 'package:data/repository/journey_generator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/location/journey/api_journey_service.dart';
import '../storage/location_caches.dart';

final journeyRepositoryProvider =
    Provider((ref) => JourneyRepository(ref.read(journeyServiceProvider)));

class JourneyRepository {
  final ApiJourneyService journeyService;
  final LocationCache locationCache = LocationCache.instance;

  JourneyRepository(this.journeyService);

  Future<void> saveLocationJourney({
    required LocationData extractedLocation,
    required String userId,
  }) async {
    try {
      _cacheLocations(extractedLocation, userId);

      var lastKnownJourney =
          await getLastKnownLocation(userId, extractedLocation);

      final data = getJourney(userId,
          newLocation: extractedLocation,
          lastLocations: locationCache.getLastFiveLocations(userId),
          lastKnownJourney: lastKnownJourney);

      final updateJourney = data?.updatedJourney;
      if (updateJourney != null) {
        locationCache.putLastJourney(updateJourney, userId);
        await journeyService.updateJourney(userId, updateJourney);
      }

      final newJourney = data?.newJourney;
      if (newJourney != null) {
        final currentJourney = await journeyService.addJourney(
            newJourney: newJourney, userId: userId);
        locationCache.putLastJourney(currentJourney, userId);
      }
    } catch (error, stack) {
      logger.e(
          'Journey Repository: Error while save journey, $extractedLocation',
          error: error,
          stackTrace: stack);
    }
  }

  Future<ApiLocationJourney?> getLastKnownLocation(
      String userId, LocationData? extractedLocation) async {
    return locationCache.getLastJourney(userId) ??
        await journeyService.getLastJourneyLocation(userId);
  }

  void _cacheLocations(
    LocationData extractedLocation,
    String userId,
  ) {
    var lastFiveLocations = locationCache.getLastFiveLocations(userId).toList();

    if (lastFiveLocations.length >= 5) {
      lastFiveLocations.removeAt(0);
    }
    lastFiveLocations.add(extractedLocation);
    locationCache.putLastFiveLocations(lastFiveLocations, userId);
  }
}
