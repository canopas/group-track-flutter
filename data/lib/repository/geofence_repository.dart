import 'package:data/log/logger.dart';
import 'package:data/service/space_service.dart';
import 'package:data/storage/app_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/auth/auth_models.dart';
import '../service/geofence_service.dart';
import '../service/place_service.dart';

final geofenceRepositoryProvider = Provider((ref) => GeofenceRepository(
      ref.read(placeServiceProvider),
      ref.read(spaceServiceProvider),
      ref.read(geofenceServiceProvider),
      ref.read(currentUserPod),
    ));

class GeofenceRepository {
  final PlaceService placeService;
  final SpaceService spaceService;
  final GeoFenceServiceHandler geofenceService;
  final ApiUser? _currentUser;

  GeofenceRepository(this.placeService, this.spaceService, this.geofenceService,
      this._currentUser);

  void init() {
    _listenForSpaceChange(_currentUser?.id ?? '');
  }

  void _listenForSpaceChange(String currentUserId) {
    if (currentUserId.isEmpty) return;

    spaceService.getUserSpaces(currentUserId).then((spaces) {
      final streams = spaces.map((space) {
        return placeService.getAllPlace(space!.id);
      }).toList();

      Future.wait(streams).then((results) {
        final allPlaces = results.expand((placeList) => placeList).toList();
        geofenceService.removeGeofence();
        geofenceService.addGeofence(allPlaces);
      }).catchError((error) {
        logger
            .e('GeofenceRepository: error while add place in geofence $error');
      });
    }).catchError((error) {
      logger.e('GeofenceRepository: error while get user space $error');
    });
  }
}