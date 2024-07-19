import 'package:data/service/location_manager.dart';
import 'package:data/service/permission_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yourspace_flutter/ui/flow/home/map/map_screen.dart';

part 'locate_on_map_view_model.freezed.dart';

final locateOnMapViewStateProvider =
    StateNotifierProvider.autoDispose<LocateOnMapVieNotifier, LocateOnMapState>(
        (ref) {
  return LocateOnMapVieNotifier(
    ref.read(locationManagerProvider),
    ref.read(permissionServiceProvider),
  );
});

class LocateOnMapVieNotifier extends StateNotifier<LocateOnMapState> {
  final LocationManager locationManager;
  final PermissionService permissionService;

  LocateOnMapVieNotifier(this.locationManager, this.permissionService)
      : super(const LocateOnMapState()) {
    getCurrentUserLocation();
  }

  void getCurrentUserLocation() async {
    final isEnabled = await permissionService.isLocationPermissionGranted();
    if (isEnabled) {
      final position = await locationManager.getLastLocation();
      final latLng = LatLng(position!.latitude, position.longitude);
      state = state.copyWith(
        currentLatLng: latLng,
        centerPosition: CameraPosition(target: latLng, zoom: defaultCameraZoom),
      );
    }
  }
}

@freezed
class LocateOnMapState with _$LocateOnMapState {
  const factory LocateOnMapState({
    LatLng? currentLatLng,
    CameraPosition? centerPosition,
  }) = _LocateOnMapState;
}
