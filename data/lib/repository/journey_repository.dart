//ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/api/location/location_table.dart';
import 'package:data/storage/database/location_table_dao.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  final _currentTime = DateTime.now().millisecondsSinceEpoch;

  JourneyRepository(FirebaseFirestore fireStore) {
    _locationService = LocationService(fireStore);
    _journeyService = ApiJourneyService(fireStore);
  }

  Future<int> getUserState(String userId, Position position) async {
    try {
      var locationData = await _getLocationData(userId);
      if (locationData != null) {
        _checkAndUpdateLastFiveMinLocation(
          userId,
          locationData,
          position,
        );
      } else {
        final latLng = LatLng(position.latitude, position.longitude);
        final location = [
          ApiLocation(
            user_id: userId,
            latitude: latLng.latitude,
            longitude: latLng.longitude,
            created_at: _currentTime,
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
      final userState = _getCurrentUserState(locationData, position);
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

  int _getCurrentUserState(LocationTable? locationData, Position position) {
    if (locationData != null) {
      final lastFiveMinLocation = _getLastFiveMinuteLocations(locationData);
      if (lastFiveMinLocation!.isMoving(position)) return USER_STATE_MOVING;
    }
    return USER_STATE_STEADY;
  }

  void _checkAndUpdateLastFiveMinLocation(
    String userId,
    LocationTable locationData,
    Position position,
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

      if (latest.created_at! < _currentTime - 60000) {
        final latLng = LatLng(position.latitude, position.longitude);
        final updated = List<ApiLocation>.from(locations);
        updated.removeWhere((loc) =>
            position.timestamp.millisecondsSinceEpoch - loc.created_at! >
            MIN_TIME_DIFFERENCE);
        updated.add(ApiLocation(
          user_id: userId,
          latitude: latLng.latitude,
          longitude: latLng.longitude,
          created_at: _currentTime,
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
    Position position,
  ) async {
    final locationData = await _getLocationData(userId);
    final lastJourney = await _getLastJourneyLocation(userId, locationData);

    try {
      if (lastJourney == null) {
        await _journeyService.saveCurrentJourney(
          userId: userId,
          fromLatitude: position.latitude,
          fromLongitude: position.longitude,
        );
      } else if (userSate == USER_STATE_MOVING) {
        await _saveJourneyForMovingUser(userId, lastJourney, position);
      } else if (userSate == USER_STATE_STEADY) {
        await _saveJourneyForSteadyUser(userId, lastJourney, position);
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
    Position position,
  ) async {
    final extractedLocation = LatLng(position.latitude, position.longitude);
    final lastLocation =
        LatLng(lastJourney.from_latitude, lastJourney.from_longitude);

    final distance = _distanceBetween(extractedLocation, lastLocation);

    if (lastJourney.isSteadyLocation()) {
      await _journeyService.saveCurrentJourney(
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
          route_distance: (lastJourney.route_distance ?? 0.0) + distance,
          route_duration: position.timestamp.millisecondsSinceEpoch -
              lastJourney.created_at!,
          routes: updatedRoutes,
          update_at: _currentTime,
        ),
      );
    }
  }

  Future<void> _saveJourneyForSteadyUser(
    String userId,
    ApiLocationJourney lastJourney,
    Position position,
  ) async {
    final extractedLocation = LatLng(position.latitude, position.longitude);
    final lastLatLng = (lastJourney.isSteadyLocation())
        ? LatLng(lastJourney.from_latitude, lastJourney.from_longitude)
        : LatLng(lastJourney.to_latitude!, lastJourney.to_longitude!);
    final distance = _distanceBetween(extractedLocation, lastLatLng);
    final timeDifference =
        position.timestamp.millisecondsSinceEpoch - lastJourney.created_at!;

    if (timeDifference > MIN_TIME_DIFFERENCE && distance > MIN_DISTANCE) {
      if (lastJourney.isSteadyLocation()) {
        await _journeyService.updateLastLocationJourney(
          userId = userId,
          lastJourney.copyWith(update_at: _currentTime),
        );
      } else {
        await _journeyService.saveCurrentJourney(
          userId: userId,
          fromLatitude: lastJourney.to_latitude!,
          fromLongitude: lastJourney.to_longitude!,
          created_at: lastJourney.created_at,
        );
      }
      await _journeyService.saveCurrentJourney(
        userId: userId,
        fromLatitude: lastJourney.to_latitude ?? lastJourney.from_latitude,
        fromLongitude: lastJourney.to_longitude ?? lastJourney.from_longitude,
        toLatitude: position.latitude,
        toLongitude: position.longitude,
        routeDistance: distance,
        routeDuration:
            position.timestamp.millisecondsSinceEpoch - lastJourney.update_at!,
        created_at: lastJourney.update_at,
        updated_at: _currentTime,
      );
    } else if (timeDifference < MIN_TIME_DIFFERENCE && distance > MIN_DISTANCE) {
      final updatedRoutes = List<JourneyRoute>.from(lastJourney.routes)
        ..add(JourneyRoute(
          latitude: extractedLocation.latitude,
          longitude: extractedLocation.longitude,
        ));

      await _journeyService.updateLastLocationJourney(
          userId,
          lastJourney.copyWith(
            to_latitude: position.latitude,
            to_longitude: position.longitude,
            route_distance: distance,
            routes: updatedRoutes,
            route_duration: position.timestamp.millisecondsSinceEpoch -
                lastJourney.created_at!,
            update_at: _currentTime,
          ));
    } else if (timeDifference > MIN_TIME_DIFFERENCE && distance < MIN_DISTANCE) {
      if (lastJourney.isSteadyLocation()) {
        await _journeyService.updateLastLocationJourney(
          userId = userId,
          lastJourney.copyWith(update_at: _currentTime),
        );
      } else {
        await _journeyService.saveCurrentJourney(
          userId: userId,
          fromLatitude: position.latitude,
          fromLongitude: position.longitude,
          created_at: _currentTime,
        );
      }
    } else if (timeDifference < MIN_TIME_DIFFERENCE && distance < MIN_DISTANCE) {
      await _journeyService.updateLastLocationJourney(
        userId = userId,
        lastJourney.copyWith(update_at: _currentTime),
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
  bool isMoving(Position currentLocation) {
    return any((location) {
      final newLocation =
          LatLng(currentLocation.latitude, currentLocation.longitude);
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
