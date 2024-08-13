import 'package:data/log/logger.dart';
import 'package:geofence_service/geofence_service.dart';

import '../api/place/api_place.dart';

class GeoFenceServiceHandler {
  final GeofenceService _geoFenceService = GeofenceService.instance;
  final List<Geofence> _geoFences = [];

  GeoFenceServiceHandler() {
    _geoFenceService.addGeofenceStatusChangeListener(_onGeofenceStatusChanged);
    _geoFenceService.addLocationChangeListener(_onLocationChanged);
    _geoFenceService.addStreamErrorListener(_onError);
  }

  Future<void> addGeofence(List<ApiPlace> places) async {
    for (var place in places) {
      if (place.longitude == 0.0 || place.latitude == 0.0 || place.radius == 0.0) continue;

      final radius = [GeofenceRadius(id: 'radius', length: place.radius)];
      final geofence = Geofence(id: place.id, latitude: place.latitude, longitude: place.longitude, radius: radius);
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

  Future<void> _onGeofenceStatusChanged(Geofence geofence, GeofenceRadius radius, GeofenceStatus status, Location location) async {
    switch (status) {
      case GeofenceStatus.ENTER:
        logger.d('Entered geofence ${geofence.id} at location (${location.latitude}, ${location.longitude})');
        break;
      case GeofenceStatus.EXIT:
        logger.d('Exited geofence ${geofence.id} at location (${location.latitude}, ${location.longitude})');
        break;
      case GeofenceStatus.DWELL:
        logger.d('Dwelling in geofence ${geofence.id} at location (${location.latitude}, ${location.longitude})');
        break;
    }
  }

  void _onLocationChanged(Location location) {
    logger.d('Location changed: ${location.latitude}, ${location.longitude}');
  }

  void _onError(error) {
    logger.d('Geofence error: $error');
  }
}