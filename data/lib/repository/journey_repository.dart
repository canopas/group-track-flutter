import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/api/location/location_table.dart';
import 'package:data/storage/database/location_table_dao.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../api/location/journey/api_journey_service.dart';
import '../api/location/journey/journey.dart';
import '../api/location/location.dart';
import '../service/location_service.dart';
import '../utils/location_converters.dart';

const int minTimeDifference = 5 * 60 * 100;
const minDistance = 100.0;

class JourneyRepository {
  late FirebaseFirestore db;
  late LocationService locationService;
  late ApiJourneyService journeyService;

  final LocationTableDao locationTableDao = LocationTableDao();

  JourneyRepository(FirebaseFirestore fireStore) {
    db = fireStore;
    locationService = LocationService(fireStore);
    journeyService = ApiJourneyService(fireStore);
  }

  void saveLocationJourney(
    int userSate,
    String userId,
    Position position,
  ) async {
    final locationData = await getLocationData(userId);
    final lastJourney = await getLastJourneyLocation(userId, locationData);

    try {
      if (lastJourney == null) {
        await journeyService.saveCurrentJourney(
          userId: userId,
          fromLatitude: position.latitude,
          fromLongitude: position.longitude,
        );
      } else if (userSate == userStateMoving) {
        await saveJourneyForMovingUser(userId, lastJourney, position);
      } else if (userSate == userStateMoving) {
        await saveJourneyForSteadyUser(userId, lastJourney, position);
      }
    } catch (e) {
      print('JourneyRepository: Error while saving location journey:$e');
    }
  }

  Future<LocationTable?> getLocationData(String userId) async {
    return await locationTableDao.getLocationData(userId);
  }

  Future<ApiLocationJourney?> getLastJourneyLocation(
    String userId,
    LocationTable? locationData,
  ) async {
    if (locationData != null) {
      return LocationConverters.journeyFromString(
          locationData.lastLocationJourney!);
    } else {
      final lastJourneyLocation =
          await journeyService.getLastJourneyLocation(userId);
      if (lastJourneyLocation != null) {
        final updatedLocationData = locationData?.copyWith(
          lastLocationJourney:
              LocationConverters.journeyToString(lastJourneyLocation),
        );
        if (updatedLocationData != null) {
          await locationTableDao.updateLocationTable(updatedLocationData);
        }
      }
      return lastJourneyLocation;
    }
  }

  Future<void> saveJourneyForMovingUser(
    String userId,
    ApiLocationJourney lastJourney,
    Position position,
  ) async {
    final extractedLocation = LatLng(position.latitude, position.longitude);
    final lastLocation =
        LatLng(lastJourney.from_latitude, lastJourney.from_longitude);

    final distance = distanceBetween(extractedLocation, lastLocation);

    if (lastJourney.isSteadyLocation()) {
      await journeyService.saveCurrentJourney(
        userId: userId,
        fromLatitude: lastJourney.from_latitude,
        fromLongitude: lastJourney.from_longitude,
        toLatitude: position.latitude,
        toLongitude: position.longitude,
        routeDistance: distance,
        routeDuration:
            position.timestamp.millisecondsSinceEpoch - lastJourney.update_at!,
      );
    } else {
      final updatedRoutes = lastJourney.routes;
      updatedRoutes.add(JourneyRoute(
        latitude: extractedLocation.latitude,
        longitude: extractedLocation.longitude,
      ));
      await journeyService.updateLastLocationJourney(
        userId,
        lastJourney.copyWith(
          to_latitude: extractedLocation.latitude,
          to_longitude: extractedLocation.longitude,
          route_distance: (lastJourney.route_distance ?? 0.0) + distance,
          route_duration: position.timestamp.millisecondsSinceEpoch -
              lastJourney.created_at!,
          routes: updatedRoutes,
          update_at: DateTime.now().millisecondsSinceEpoch,
        ),
      );
    }
  }

  Future<void> saveJourneyForSteadyUser(
    String userId,
    ApiLocationJourney lastJourney,
    Position position,
  ) async {
    final extractedLocation = LatLng(position.latitude, position.longitude);
    final lastLatLng = (lastJourney.isSteadyLocation())
        ? LatLng(lastJourney.from_latitude, lastJourney.from_longitude)
        : LatLng(lastJourney.to_latitude!, lastJourney.to_longitude!);
    final distance = distanceBetween(extractedLocation, lastLatLng);
    final timeDifference =
        position.timestamp.millisecondsSinceEpoch - lastJourney.created_at!;

    if (timeDifference > minTimeDifference && distance > minDistance) {
      if (lastJourney.isSteadyLocation()) {
        await journeyService.updateLastLocationJourney(
          userId = userId,
          lastJourney.copyWith(
              update_at: DateTime.now().millisecondsSinceEpoch),
        );
      } else {
        await journeyService.saveCurrentJourney(
            userId: userId,
            fromLatitude: lastJourney.to_latitude!,
            fromLongitude: lastJourney.to_longitude!,
            created_at: lastJourney.created_at);
      }
      await journeyService.saveCurrentJourney(
        userId: userId,
        fromLatitude: lastJourney.to_latitude ?? lastJourney.from_latitude,
        fromLongitude: lastJourney.to_longitude ?? lastJourney.from_longitude,
        toLatitude: position.latitude,
        toLongitude: position.longitude,
        routeDistance: distance,
        routeDuration:
            position.timestamp.millisecondsSinceEpoch - lastJourney.update_at!,
        created_at: lastJourney.update_at,
        updated_at: DateTime.now().millisecondsSinceEpoch,
      );
    } else if (timeDifference < minTimeDifference && distance > minDistance) {
      final updatedRoutes = lastJourney.routes;
      updatedRoutes.add(JourneyRoute(
        latitude: extractedLocation.latitude,
        longitude: extractedLocation.longitude,
      ));
      await journeyService.updateLastLocationJourney(
          userId,
          lastJourney.copyWith(
              to_latitude: position.latitude,
              to_longitude: position.longitude,
              route_distance: distance,
              routes: updatedRoutes,
              route_duration: position.timestamp.millisecondsSinceEpoch -
                  lastJourney.created_at!,
              update_at: DateTime.now().millisecondsSinceEpoch));
    } else if (timeDifference > minTimeDifference && distance < minDistance) {
      if (lastJourney.isSteadyLocation()) {
        await journeyService.updateLastLocationJourney(
          userId = userId,
          lastJourney.copyWith(
              update_at: DateTime.now().millisecondsSinceEpoch),
        );
      } else {
        await journeyService.saveCurrentJourney(
          userId: userId,
          fromLatitude: position.latitude,
          fromLongitude: position.longitude,
          created_at: DateTime.now().millisecondsSinceEpoch,
        );
      }
    } else if (timeDifference < minTimeDifference && distance < minDistance) {
      await journeyService.updateLastLocationJourney(
        userId = userId,
        lastJourney.copyWith(
            update_at: DateTime.now().millisecondsSinceEpoch),
      );
    }
  }

  double distanceBetween(LatLng startLocation, LatLng endLocation) {
    return Geolocator.distanceBetween(
      startLocation.latitude,
      startLocation.longitude,
      endLocation.latitude,
      endLocation.longitude,
    );
  }
}
