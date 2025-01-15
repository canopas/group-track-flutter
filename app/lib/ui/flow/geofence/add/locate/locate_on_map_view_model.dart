import 'package:data/api/auth/auth_models.dart';
import 'package:data/log/logger.dart';
import 'package:data/service/location_service.dart';
import 'package:data/service/permission_service.dart';
import 'package:data/service/place_service.dart';
import 'package:data/service/space_service.dart';
import 'package:data/storage/app_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yourspace_flutter/domain/extenstions/lat_lng_extenstion.dart';
import 'package:yourspace_flutter/ui/flow/home/map/map_screen.dart';

part 'locate_on_map_view_model.freezed.dart';

final locateOnMapViewStateProvider =
    StateNotifierProvider.autoDispose<LocateOnMapVieNotifier, LocateOnMapState>(
        (ref) {
  return LocateOnMapVieNotifier(
    ref.read(permissionServiceProvider),
    ref.read(currentUserPod),
    ref.read(placeServiceProvider),
    ref.read(spaceServiceProvider),
    ref.read(locationServiceProvider),
  );
});

class LocateOnMapVieNotifier extends StateNotifier<LocateOnMapState> {
  final PermissionService permissionService;
  final ApiUser? _currentUser;
  final PlaceService placesService;
  final SpaceService spaceService;
  final LocationService locationService;

  LocateOnMapVieNotifier(
    this.permissionService,
    this._currentUser,
    this.placesService,
    this.spaceService,
    this.locationService,
  ) : super(const LocateOnMapState()) {
    getCurrentUserLocation();
  }

  void getCurrentUserLocation() async {
    try {
      if (spaceService.currentSpaceId?.isEmpty ?? true) return;

      final isEnabled = await permissionService.isLocationPermissionGranted();
      if (isEnabled && _currentUser != null) {
        state = state.copyWith(loading: true);
        final location = await locationService.getCurrentLocation(
            spaceService.currentSpaceId!, _currentUser.id);
        if (location != null) {
          final latLng = LatLng(location.latitude, location.longitude);
          state = state.copyWith(
            currentLatLng: latLng,
            centerPosition:
                CameraPosition(target: latLng, zoom: defaultCameraZoom),
            loading: false,
          );
        }
      }
    } catch (error, stack) {
      logger.e('LocateONMapViewNotifier: Error while fetch user last location',
          error: error, stackTrace: stack);
    }
  }

  void onMapCameraMove(CameraPosition position) {
    state = state.copyWith(cameraLatLng: position.target);
    _getAddress(position.target);
  }

  void _getAddress(LatLng latLng) async {
    if (state.gettingAddress) return;
    state = state.copyWith(gettingAddress: true);
    final address = await latLng.getAddressFromLocation();
    state = state.copyWith(address: address, gettingAddress: false);
  }

  void onTapAddPlaceBtn(String spaceId, String placeName) async {
    try {
      if (_currentUser != null && state.cameraLatLng != null) {
        state = state.copyWith(addingPlace: true);
        final members = await spaceService.getMemberBySpaceId(spaceId);
        final memberIds = members.map((member) => member.user_id).toList();
        await placesService.addPlace(
            spaceId,
            placeName,
            state.cameraLatLng!.latitude,
            state.cameraLatLng!.longitude,
            _currentUser.id,
            memberIds);
      }
      state =
          state.copyWith(popToPlaceList: DateTime.now(), addingPlace: false);
    } catch (error, stack) {
      state = state.copyWith(addingPlace: false, error: error);
      logger.e(
        'LocateOnMapVieNotifier: Error while adding place',
        error: error,
        stackTrace: stack,
      );
    }
  }
}

@freezed
class LocateOnMapState with _$LocateOnMapState {
  const factory LocateOnMapState({
    @Default(false) loading,
    @Default(false) addingPlace,
    @Default(false) gettingAddress,
    LatLng? currentLatLng,
    LatLng? cameraLatLng,
    String? address,
    CameraPosition? centerPosition,
    DateTime? popToPlaceList,
    Object? error,
  }) = _LocateOnMapState;
}
