import 'package:cloud_functions/cloud_functions.dart';
import 'package:data/log/logger.dart';
import 'package:data/repository/space_repository.dart';
import 'package:data/service/place_service.dart';
import 'package:data/storage/app_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geofence_service/geofence_service.dart';

import '../api/auth/auth_models.dart';
import '../api/place/api_place.dart';

final geofenceServiceProvider = Provider((ref) => GeoFenceServiceHandler(
  ref.read(placeServiceProvider),
      ref.read(currentUserPod),
  ref.read(spaceRepositoryProvider)
));

class GeoFenceServiceHandler {
  final GeofenceService _geoFenceService = GeofenceService.instance.setup(useActivityRecognition: true);
  final List<Geofence> _geoFences = [];
  final PlaceService placeService;
  final SpaceRepository spaceRepository;
  final ApiUser? _currentUser;

  GeoFenceServiceHandler(
      this.placeService, this._currentUser, this.spaceRepository) {
    _geoFenceService.addGeofenceStatusChangeListener(_onGeofenceStatusChanged);
    _geoFenceService.addLocationChangeListener(_onLocationChanged);
    _geoFenceService.addStreamErrorListener(_onError);
  }

  Future<void> addGeofence(List<ApiPlace> places) async {
    for (var place in places) {
      if (place.longitude == 0.0 ||
          place.latitude == 0.0 ||
          place.radius == 0.0) continue;

      final radius = [GeofenceRadius(id: 'radius', length: place.radius)];
      final geofence = Geofence(
          id: place.id,
          latitude: place.latitude,
          longitude: place.longitude,
          radius: radius);
      _geoFences.add(geofence);
    }

    _geoFenceService.start(_geoFences).then((_) {
      logger.d("Geofence registered successfully");
    }).catchError((error) {
      logger.e('Failed to register geofence: $error');
    });
  }

  void removeGeofence() {
    _geoFenceService.removeGeofenceList(_geoFences);
    _geoFences.clear();
  }

  Future<void> _onGeofenceStatusChanged(Geofence geofence,
      GeofenceRadius radius, GeofenceStatus status, Location location) async {
    switch (status) {
      case GeofenceStatus.ENTER:
        logger.d(
            'Entered geofence ${geofence.id} at location (${location.latitude}, ${location.longitude})');
        makeHttpCall(geofence.id, status);
        break;
      case GeofenceStatus.EXIT:
        logger.d(
            'Exited geofence ${geofence.id} at location (${location.latitude}, ${location.longitude})');
        makeHttpCall(geofence.id, status);
        break;
      case GeofenceStatus.DWELL:
        break;
    }
  }

  void _onLocationChanged(Location location) {
    logger.d('Location changed: ${location.latitude}, ${location.longitude}');
  }

  void _onError(error) {
    logger.d('Geofence error: $error');
  }

  void makeHttpCall(String placeId, GeofenceStatus status) async {
    try {
      final place = await placeService.getPlace(placeId);
      final message = status == GeofenceStatus.ENTER
          ? '${_currentUser?.first_name ?? ''} has arrived at 📍${place?.name}'
          : '${_currentUser?.first_name ?? ''} has left 📍${place?.name}';

      final data = {
        'placeId': placeId,
        'spaceId': place?.space_id ?? '',
        'eventBy': _currentUser?.id ?? '',
        'message': message,
        'eventType': status
      };

      final callable = FirebaseFunctions.instanceFor(region: 'asia-south1')
          .httpsCallable('sendGeoFenceNotification');
      await callable.call(data);
    } catch (error, stack) {
      logger.e(
        "GeofenceService: error while get place from place id",
        error: error,
        stackTrace: stack,
      );
    }
  }
}
