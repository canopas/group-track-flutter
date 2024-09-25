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

const MIN_TIME_DIFFERENCE = 5 * 60 * 1000; // 5 min in milliseconds
const MIN_DISTANCE = 100.0; // Minimum distance in meter to consider movement
const int GRACE_PERIOD = 2 * 60 * 1000; // Grace period of 2 min considering small stops

class JourneyRepository {
  late LocationService _locationService;
  late ApiJourneyService _journeyService;

  final LocationTableDao _locationTableDao = LocationTableDao();

  JourneyRepository(FirebaseFirestore fireStore) {
    _locationService = LocationService(fireStore);
    _journeyService = ApiJourneyService(fireStore);
  }

  Future<int> getUserState(String userId, LocationData locationPosition) async {
    try {
      var locationData = await _getLocationData(userId);
      if (locationData != null) {
        _checkAndUpdateLastFiveMinLocation(
          userId,
          locationData,
          locationPosition,
        );
      } else {
        final latLng =
            LatLng(locationPosition.latitude, locationPosition.longitude);
        final locations = [
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
              LocationConverters.locationListToString(locations),
        );
        await _locationTableDao.insertLocationTable(tableData);
      }
      locationData = await _getLocationData(userId);
      final userState = _getCurrentUserState(locationData, locationPosition);
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

  int _getCurrentUserState(
      LocationTable? locationData, LocationData locationPosition) {
    if (locationData != null) {
      final lastFiveMinLocation = _getLastFiveMinuteLocations(locationData);
      if (lastFiveMinLocation!.isMoving(locationPosition)) return USER_STATE_MOVING;
    }
    return USER_STATE_STEADY;
  }

  void _checkAndUpdateLastFiveMinLocation(
    String userId,
    LocationTable locationData,
    LocationData locationPosition,
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
        final latLng =
            LatLng(locationPosition.latitude, locationPosition.longitude);
        final updated = List<ApiLocation>.from(locations);
        updated.removeWhere((loc) =>
            locationPosition.timestamp.millisecondsSinceEpoch -
                loc.created_at! >
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

  Future<void> saveUserJourney(int userSate, String userId, LocationData locationPosition) async {
    final locationData = await _getLocationData(userId);
    final lastJourney = await _getLastJourneyLocation(userId, locationData);

    try {
      if (lastJourney == null) {
        await _journeyService.saveCurrentJourney(
          userId: userId,
          fromLatitude: locationPosition.latitude,
          fromLongitude: locationPosition.longitude,
        );
      } else if (userSate == USER_STATE_MOVING) {
        await _saveJourneyForMovingUser(userId, lastJourney, locationPosition);
      } else if (userSate == USER_STATE_STEADY) {
        await _saveJourneyForSteadyUser(userId, lastJourney, locationPosition);
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
    LocationData locationPosition,
  ) async {
    final extractedLocation =
        LatLng(locationPosition.latitude, locationPosition.longitude);
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
        toLatitude: locationPosition.latitude,
        toLongitude: locationPosition.longitude,
        routeDistance: steadyDistance,
        routeDuration: locationPosition.timestamp.millisecondsSinceEpoch -
            lastJourney.update_at!,
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
          route_duration: locationPosition.timestamp.millisecondsSinceEpoch -
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
    LocationData locationPosition,
  ) async {
    final extractedLocation =
        LatLng(locationPosition.latitude, locationPosition.longitude);
    final lastLatLng = (lastJourney.isSteadyLocation())
        ? LatLng(lastJourney.from_latitude, lastJourney.from_longitude)
        : LatLng(lastJourney.to_latitude!, lastJourney.to_longitude!);
    final distance = _distanceBetween(extractedLocation, lastLatLng);
    final timeDifference = locationPosition.timestamp.millisecondsSinceEpoch -
        (lastJourney.update_at ?? lastJourney.created_at!);

    if (timeDifference > MIN_TIME_DIFFERENCE && timeDifference > GRACE_PERIOD && distance > MIN_DISTANCE) {
      // Case 1: User has stayed for more than the MIN_TIME_DIFFERENCE and moved
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
        toLatitude: locationPosition.latitude,
        toLongitude: locationPosition.longitude,
        routeDistance: distance,
        routeDuration: locationPosition.timestamp.millisecondsSinceEpoch -
            lastJourney.update_at!,
        created_at: lastJourney.update_at,
        updated_at: DateTime.now().millisecondsSinceEpoch,
      );
    } else if (timeDifference < MIN_TIME_DIFFERENCE &&
        distance > MIN_DISTANCE) {
      // Case 2: Update routes when the time difference is small but distance is significant
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
          route_duration: locationPosition.timestamp.millisecondsSinceEpoch -
              lastJourney.created_at!,
          update_at: DateTime.now().millisecondsSinceEpoch,
        ));
    } else if (timeDifference > MIN_TIME_DIFFERENCE && distance < MIN_DISTANCE) {
      // Case 3: Steady location when the user has stayed for longer than MIN_TIME_DIFFERENCE but hasn't moved much
      if (lastJourney.isSteadyLocation()) {
        await _journeyService.updateLastLocationJourney(
          userId = userId,
          lastJourney.copyWith(
              update_at: DateTime.now().millisecondsSinceEpoch),
        );
      } else {
        await _journeyService.saveCurrentJourney(
          userId: userId,
          fromLatitude: locationPosition.latitude,
          fromLongitude: locationPosition.longitude,
          created_at: DateTime.now().millisecondsSinceEpoch,
        );
      }
    } else if (timeDifference < MIN_TIME_DIFFERENCE &&
        distance < MIN_DISTANCE) {
      // Case 4: No significant movement or time passed; just update the journey's update time
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
  bool isMoving(LocationData locationPosition) {
    return any((location) {
      final newLocation =
          LatLng(locationPosition.latitude, locationPosition.longitude);
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
