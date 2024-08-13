import 'package:data/log/logger.dart';
import 'package:data/repository/space_repository.dart';
import '../service/geofence_service.dart';
import '../service/place_service.dart';

class GeofenceRepository {
  final PlaceService placeService;
  final SpaceRepository spaceService;
  final GeoFenceServiceHandler geofenceService;

  GeofenceRepository(this.placeService, this.spaceService, this.geofenceService);

  void init(String currentUserId) {
    listenForSpaceChange(currentUserId);
  }

  void listenForSpaceChange(String currentUserId) {
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
        logger.e('GeofenceRepository: error while add place in geofence $error');
      });
    }).catchError((error) {
      logger.e('GeofenceRepository: error while get user space $error');
    });
  }

  void registerAllPlaces(String currentUserId) async {
    try {
      if (currentUserId.isEmpty) return;

      final spaces = await spaceService.getUserSpaces(currentUserId);
      for (final space in spaces) {
        final place = await placeService.getAllPlace(space!.id);
        geofenceService.addGeofence(place);
      }
    } catch (error, stack) {
      logger.e(
        'GeofenceRepository: error while registering all places - $error',
        error: error,
        stackTrace: stack,
      );
    }
  }
}