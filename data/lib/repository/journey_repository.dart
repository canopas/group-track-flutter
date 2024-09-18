//ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/api/location/location_table.dart';
import 'package:data/storage/database/location_table_dao.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

import '../api/location/journey/api_journey_service.dart';
import '../api/location/journey/journey.dart';
import '../api/location/location.dart';
import '../log/logger.dart';
import '../service/location_service.dart';
import '../utils/location_converters.dart';

const MIN_TIME_DIFFERENCE = 5 * 60 * 1000;
const MIN_DISTANCE = 100.0;

class JourneyRepository {
  late LocationService _locationService;
  late ApiJourneyService _journeyService;

  final LocationTableDao _locationTableDao = LocationTableDao();

  JourneyRepository(FirebaseFirestore fireStore) {
    _locationService = LocationService(fireStore);
    _journeyService = ApiJourneyService(fireStore);
  }

  Future<int> getUserState(String userId, double lat, double long, DateTime timestamp) async {
    try {
      var locationData = await _getLocationData(userId);
      if (locationData != null) {
        _checkAndUpdateLastFiveMinLocation(
          userId,
          locationData,
          lat,
          long,
          timestamp,
        );
      } else {
        final latLng = LatLng(lat, long);
        final location = [
          ApiLocation(
            id: const Uuid().v4(),
            user_id: userId,
            latitude: latLng.latitude,
            longitude: latLng.longitude,
            created_at: DateTime.now().millisecondsSinceEpoch,
          ),
        ];
        final tableData = LocationTable(
          userId: userId,
          lastFiveMinutesLocations:
              LocationConverters.locationListToString(location),
        );
        await _locationTableDao.insertLocationTable(tableData);
      }
      locationData = await _getLocationData(userId);
      final userState = _getCurrentUserState(locationData, lat, long);
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

  int _getCurrentUserState(LocationTable? locationData, double lat, double long) {
    if (locationData != null) {
      final lastFiveMinLocation = _getLastFiveMinuteLocations(locationData);
      if (lastFiveMinLocation!.isMoving(lat, long)) return USER_STATE_MOVING;
    }
    return USER_STATE_STEADY;
  }

  void _checkAndUpdateLastFiveMinLocation(
    String userId,
    LocationTable locationData,
    double lat,
    double long,
    DateTime timestamp,
  ) async {
    final locations = _getLastFiveMinuteLocations(locationData);

    if (locations == null || locations.isEmpty) {
      final fiveMinLocation =
          await _locationService.getLastFiveMinLocation(userId).first;
      await _updateLocationData(locationData, fiveMinLocation);
    } else {
      final latest = (locations.length == 1)
          ? locations.first
          : locations.reduce((current, next) =>
              current.created_at! > next.created_at! ? current : next);

      if (latest.created_at! < DateTime.now().millisecondsSinceEpoch - 60000) {
        final latLng = LatLng(lat, long);
        final updated = List<ApiLocation>.from(locations);
        updated.removeWhere((loc) =>
            timestamp.millisecondsSinceEpoch - loc.created_at! >
            MIN_TIME_DIFFERENCE);
        updated.add(ApiLocation(
          id: const Uuid().v4(),
          user_id: userId,
          latitude: latLng.latitude,
          longitude: latLng.longitude,
          created_at: DateTime.now().millisecondsSinceEpoch,
        ));
        await _updateLocationData(locationData, updated);
      }
    }
  }

  List<ApiLocation>? _getLastFiveMinuteLocations(LocationTable locationData) {
    return locationData.lastFiveMinutesLocations != null
        ? LocationConverters.locationListFromString(
            locationData.lastFiveMinutesLocations!)
        : [];
  }

  Future<void> _updateLocationData(
    LocationTable locationData,
    List<ApiLocation?> locations,
  ) async {
    final updatedData = locationData.copyWith(
      lastFiveMinutesLocations:
          LocationConverters.locationListToString(locations),
    );
    await _locationTableDao.updateLocationTable(updatedData);
  }

  Future<void> saveUserJourney(
    int userSate,
    String userId,
    double lat,
      double long,
      DateTime timestamp
  ) async {
    final locationData = await _getLocationData(userId);
    final lastJourney = await _getLastJourneyLocation(userId, locationData);

    try {
      if (lastJourney == null) {
        await _journeyService.saveCurrentJourney(
          userId: userId,
          fromLatitude: lat,
          fromLongitude: long,
        );
      } else if (userSate == USER_STATE_MOVING) {
        await _saveJourneyForMovingUser(userId, lastJourney, lat, long, timestamp);
      } else if (userSate == USER_STATE_STEADY) {
        await _saveJourneyForSteadyUser(userId, lastJourney, lat, long, timestamp);
      }
    } catch (error, stack) {
      logger.e(
        'JourneyRepository: Error while saving user journey',
        error: error,
        stackTrace: stack,
      );
    }
  }

  Future<LocationTable?> _getLocationData(String userId) async {
    return await _locationTableDao.getLocationData(userId);
  }

  Future<ApiLocationJourney?> _getLastJourneyLocation(
    String userId,
    LocationTable? locationData,
  ) async {
    if (locationData != null && locationData.lastLocationJourney != null) {
      return LocationConverters.journeyFromString(
          locationData.lastLocationJourney!);
    } else {
      final lastJourneyLocation =
          await _journeyService.getLastJourneyLocation(userId);
      if (lastJourneyLocation != null) {
        final updatedLocationData = locationData?.copyWith(
          lastLocationJourney:
              LocationConverters.journeyToString(lastJourneyLocation),
        );
        if (updatedLocationData != null) {
          await _locationTableDao.updateLocationTable(updatedLocationData);
        }
      }
      return lastJourneyLocation;
    }
  }

  Future<void> _saveJourneyForMovingUser(
    String userId,
    ApiLocationJourney lastJourney,
    double lat,
    double long,
    DateTime timestamp,
  ) async {
    final extractedLocation = LatLng(lat, long);
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
        toLatitude: lat,
        toLongitude: long,
        routeDistance: steadyDistance,
        routeDuration: timestamp.millisecondsSinceEpoch - lastJourney.update_at!,
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
          route_duration: timestamp.millisecondsSinceEpoch -
              lastJourney.created_at!,
          routes: updatedRoutes,
          update_at: DateTime.now().millisecondsSinceEpoch,
        ),
      );
    }
  }

  Future<void> _saveJourneyForSteadyUser(
    String userId,
    ApiLocationJourney lastJourney,
    double lat,
    double long,
    DateTime timestamp,
  ) async {
    final extractedLocation = LatLng(lat, long);
    final lastLatLng = (lastJourney.isSteadyLocation())
        ? LatLng(lastJourney.from_latitude, lastJourney.from_longitude)
        : LatLng(lastJourney.to_latitude!, lastJourney.to_longitude!);
    final distance = _distanceBetween(extractedLocation, lastLatLng);
    final timeDifference = timestamp.millisecondsSinceEpoch - lastJourney.created_at!;

    if (timeDifference > MIN_TIME_DIFFERENCE && distance > MIN_DISTANCE) {
      if (lastJourney.isSteadyLocation()) {
        await _journeyService.updateLastLocationJourney(
          userId = userId,
          lastJourney.copyWith(
              update_at: DateTime.now().millisecondsSinceEpoch),
        );
      } else {
        await _journeyService.saveCurrentJourney(
          userId: userId,
          fromLatitude: lastJourney.to_latitude!,
          fromLongitude: lastJourney.to_longitude!,
          created_at: lastJourney.update_at,
        );
      }
      await _journeyService.saveCurrentJourney(
        userId: userId,
        fromLatitude: lastJourney.to_latitude ?? lastJourney.from_latitude,
        fromLongitude: lastJourney.to_longitude ?? lastJourney.from_longitude,
        toLatitude: lat,
        toLongitude: long,
        routeDistance: distance,
        routeDuration:
            timestamp.millisecondsSinceEpoch - lastJourney.update_at!,
        created_at: lastJourney.update_at,
        updated_at: DateTime.now().millisecondsSinceEpoch,
      );
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
            route_duration: timestamp.millisecondsSinceEpoch -
                lastJourney.created_at!,
            update_at: DateTime.now().millisecondsSinceEpoch,
          ));
    } else if (timeDifference > MIN_TIME_DIFFERENCE &&
        distance < MIN_DISTANCE) {
      if (lastJourney.isSteadyLocation()) {
        await _journeyService.updateLastLocationJourney(
          userId = userId,
          lastJourney.copyWith(
              update_at: DateTime.now().millisecondsSinceEpoch),
        );
      } else {
        await _journeyService.saveCurrentJourney(
          userId: userId,
          fromLatitude: lat,
          fromLongitude: long,
          created_at: DateTime.now().millisecondsSinceEpoch,
        );
      }
    } else if (timeDifference < MIN_TIME_DIFFERENCE &&
        distance < MIN_DISTANCE) {
      await _journeyService.updateLastLocationJourney(
        userId = userId,
        lastJourney.copyWith(update_at: DateTime.now().millisecondsSinceEpoch),
      );
    }
  }

  double _distanceBetween(LatLng startLocation, LatLng endLocation) {
    return Geolocator.distanceBetween(
      startLocation.latitude,
      startLocation.longitude,
      endLocation.latitude,
      endLocation.longitude,
    );
  }
}

extension ApiLocationListExtensions on List<ApiLocation> {
  bool isMoving(double lat, double long) {
    return any((location) {
      final newLocation =
          LatLng(lat, long);
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
