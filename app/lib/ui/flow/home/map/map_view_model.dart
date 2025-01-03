import 'dart:async';
import 'dart:ui' as ui;

import 'package:data/api/auth/auth_models.dart';
import 'package:data/api/location/location.dart';
import 'package:data/api/place/api_place.dart';
import 'package:data/log/logger.dart';
import 'package:data/service/auth_service.dart';
import 'package:data/service/location_manager.dart';
import 'package:data/service/permission_service.dart';
import 'package:data/service/place_service.dart';
import 'package:data/service/space_service.dart';
import 'package:data/storage/app_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image/image.dart' as img;

import 'components/marker_generator.dart';
import 'map_screen.dart';

part 'map_view_model.freezed.dart';

const FOUR_MIN_SECONDS = 4 * 60 * 1000;

final mapViewStateProvider =
    StateNotifierProvider.autoDispose<MapViewNotifier, MapViewState>((ref) {
  final notifier = MapViewNotifier(
    ref.read(currentUserPod),
    ref.read(currentSpaceId),
    ref.read(spaceServiceProvider),
    ref.read(placeServiceProvider),
    ref.read(permissionServiceProvider),
    ref.read(locationManagerProvider),
    ref.read(authServiceProvider),
    ref.read(googleMapType.notifier),
  );

  ref.listen(currentUserPod, (prev, user) {
    notifier._onUpdateUser(prevUser: prev, currentUser: user);
  });

  ref.listen(currentSpaceId, (prev, newSpaceId) {
    notifier._onUpdateSpace(prev: prev, current: newSpaceId);
  });

  return notifier;
});

class MapViewNotifier extends StateNotifier<MapViewState> {
  final ApiUser? _currentUser;
  String? _currentSpaceId;
  final SpaceService spaceService;
  final PlaceService placeService;
  final PermissionService permissionService;
  final LocationManager locationManager;
  final AuthService authService;
  final StateController<String> mapTypeController;

  CameraPosition? _lastCameraPosition;

  StreamSubscription<List<ApiUserInfo>>? _userInfoSubscription;
  StreamSubscription<List<ApiPlace>>? _placeSubscription;

  MapViewNotifier(
    this._currentUser,
    this._currentSpaceId,
    this.spaceService,
    this.placeService,
    this.permissionService,
    this.locationManager,
    this.authService,
    this.mapTypeController,
  ) : super(MapViewState(
            mapType: mapTypeController.state,
            defaultPosition: const CameraPosition(
                target: LatLng(0.0, 0.0), zoom: defaultCameraZoom))) {
    _lastCameraPosition = state.defaultPosition;
    checkUserPermission();
    loadData(_currentSpaceId);
  }

  void loadData(String? spaceId) {
    _resetState();
    if (spaceId == null) return;
    _listenMemberLocation(spaceId);
    _listenPlaces(spaceId);
  }

  void _onUpdateUser({ApiUser? prevUser, ApiUser? currentUser}) {
    _resetState();
    if (currentUser != null && prevUser?.id != currentUser.id) {
      fetchCurrentUserLocation();
    }
  }

  void _onUpdateSpace({String? prev, String? current}) {
    _currentSpaceId = current;
    if (current == null) {
      _userInfoSubscription?.cancel();
      _placeSubscription?.cancel();
      return;
    }
    if (prev == current) return;
    _resetState();
    loadData(current);
  }

  void _resetState() {
    _userInfoSubscription?.cancel();
    _placeSubscription?.cancel();

    _lastCameraPosition = null;
    state = state.copyWith(
      userInfos: {},
      places: [],
      selectedUser: null,
      currentUserLocation: null,
    );
  }

  void _listenMemberLocation(String spaceId) async {
    if (state.loading) return;
    try {
      state = state.copyWith(loading: true, selectedUser: null);
      _userInfoSubscription?.cancel();
      _userInfoSubscription =
          spaceService.getMemberWithLocation(spaceId).listen((userInfo) {
        state = state.copyWith(loading: false);
        _userMapPositions(userInfo);
      });
    } catch (error, stack) {
      state = state.copyWith(loading: false, error: error);
      logger.e(
        'MapViewNotifier: Error while getting members location',
        error: error,
        stackTrace: stack,
      );
    }
  }

  void _listenPlaces(String spaceId) async {
    try {
      _placeSubscription?.cancel();
      _placeSubscription =
          placeService.getAllPlacesStream(spaceId).listen((places) {
        state = state.copyWith(places: places);
      });
    } catch (error, stack) {
      state = state.copyWith(error: error);
      logger.e(
        'MapViewNotifier: Error while getting places',
        error: error,
        stackTrace: stack,
      );
    }
  }

  void _userMapPositions(List<ApiUserInfo> userInfo) async {
    final Map<String, MapUserInfo> mapUserInfo = Map.of(state.userInfos);

    for (final info in userInfo) {
      MapUserInfo? userInfo;
      if (info.user.id == _currentUser?.id) {
        final latLng = LatLng(
          info.location?.latitude ?? state.currentUserLocation?.latitude ?? 0.0,
          info.location?.longitude ??
              state.currentUserLocation?.longitude ??
              0.0,
        );
        state = state.copyWith(currentUserLocation: latLng);

        userInfo = await _prepareMapUserInfo(info.user,
            latitude: latLng.latitude, longitude: latLng.longitude);

        final lastCameraPosition = _lastCameraPosition?.target;
        if (lastCameraPosition == null ||
            (lastCameraPosition.latitude == 0.0 &&
                lastCameraPosition.longitude == 0.0)) {
          _mapCameraPosition(latLng);
        }
      } else if (info.location != null && info.isLocationEnabled) {
        userInfo = await _prepareMapUserInfo(info.user,
            latitude: info.location!.latitude,
            longitude: info.location!.longitude);
      }

      userInfo = userInfo?.copyWith(
          updatedLocationAt: info.location?.created_at ??
              DateTime.now().millisecondsSinceEpoch);
      if (userInfo != null) mapUserInfo[info.user.id] = userInfo;
    }

    state = state.copyWith(userInfos: mapUserInfo);
  }

  Future<MapUserInfo> _prepareMapUserInfo(ApiUser user,
      {required double latitude, required double longitude}) async {
    return MapUserInfo(
      userId: user.id,
      user: user,
      imageUrl: await _convertUrlToImage(user.profile_image),
      latitude: latitude,
      longitude: longitude,
      isSelected: state.selectedUser == null
          ? false
          : state.selectedUser?.id == user.id,
    );
  }

  Future<ui.Image?> _convertUrlToImage(String? imageUrl) async {
    if (imageUrl == null || imageUrl.isEmpty) return null;

    try {
      final cacheManager = DefaultCacheManager();
      final file = await cacheManager.getSingleFile(imageUrl);

      final bytes = await file.readAsBytes();
      final image = img.decodeImage(bytes);
      if (image != null) {
        final resizedImage = img.copyResize(
          image,
          width: (markerSize / 1.25).toInt(),
          height: (markerSize / 1.25).toInt(),
        );
        final circularImage = img.copyCropCircle(resizedImage);

        final byteData = ByteData.view(
          Uint8List.fromList(img.encodePng(circularImage)).buffer,
        );

        final codec =
            await ui.instantiateImageCodec(byteData.buffer.asUint8List());
        final frame = await codec.getNextFrame();
        return frame.image;
      }
    } catch (e) {
      debugPrint("Error while getting network image: $e");
    }
    return null;
  }

  void onAddMemberTap(String spaceId) async {
    try {
      state = state.copyWith(fetchingInviteCode: true, spaceInvitationCode: '');
      final code = await spaceService.getInviteCode(spaceId);
      state = state.copyWith(
          spaceInvitationCode: code ?? '', fetchingInviteCode: false);
    } catch (error, stack) {
      state = state.copyWith(error: error, fetchingInviteCode: false);
      logger.e(
        'MapViewNotifier: Error while getting invitation code',
        error: error,
        stackTrace: stack,
      );
    }
  }

  void onDismissMemberDetail() {
    state = state.copyWith(selectedUser: null);
    _onSelectUserMarker(null);
  }

  void showMemberDetail(MapUserInfo member) async {
    final selectedMember =
        (state.selectedUser?.id == member.user.id) ? null : member;

    final position = (selectedMember != null &&
            selectedMember.latitude != 0.0 &&
            selectedMember.longitude != 0.0)
        ? LatLng(selectedMember.latitude, selectedMember.longitude)
        : null;

    state = state.copyWith(selectedUser: selectedMember?.user);
    _onSelectUserMarker(member.user.id);

    if (position != null) {
      _mapCameraPosition(position,
          cameraZoom: defaultCameraZoomForSelectedUser);
    }

    if (state.selectedUser != null) {
      _requestUserStatUpdates();
    }
  }

  void _onSelectUserMarker(String? userId) {
    final Map<String, MapUserInfo> updatedInofs =
        state.userInfos.map((key, value) {
      return MapEntry(key, value.copyWith(isSelected: key == userId));
    });

    state = state.copyWith(userInfos: updatedInofs);
  }

  void onTapUserMarker(String userId) {
    final user =
        state.userInfos.values.firstWhere((user) => user.userId == userId);
    showMemberDetail(user);
  }

  void checkUserPermission() async {
    final isLocationEnabled = await permissionService.isLocationAlwaysEnabled();
    final isLocationServiceEnabled =
        await permissionService.isLocationServiceEnabled();
    final isNotificationEnabled =
        await permissionService.hasNotificationPermission();
    final isFineLocationPermission =
        await permissionService.isLocationPermissionGranted();

    startLocationService(isFineLocationPermission);

    state = state.copyWith(
      hasLocationEnabled: isLocationEnabled,
      hasLocationServiceEnabled: isLocationServiceEnabled,
      hasNotificationEnabled: isNotificationEnabled,
      hasFineLocationEnabled: isFineLocationPermission,
    );
  }

  void startLocationService(bool isPermission) async {
    final isTrackingStarted = locationManager.isTrackingStarted;
    if (isPermission && !isTrackingStarted) {
      locationManager.startService();
    }
  }

  void showEnableLocationDialog() {
    state = state.copyWith(showLocationDialog: DateTime.now());
  }

  void relocateCameraPosition() async {
    try {
      final userId = state.selectedUser?.id ?? _currentUser?.id;

      final info = state.userInfos[userId];
      if (info != null) {
        final latLng = LatLng(info.latitude, info.longitude);
        _mapCameraPosition(latLng,
            cameraZoom: defaultCameraZoomForSelectedUser);
      }
    } catch (error, stack) {
      state = state.copyWith(error: error);
      logger.e(
        'MapViewNotifier: Error while getting last location',
        error: error,
        stackTrace: stack,
      );
    }
  }

  void _mapCameraPosition(LatLng latLng, {double? cameraZoom}) async {
    final zoom = cameraZoom ??
        await state.mapController?.getZoomLevel() ??
        defaultCameraZoom;
    final cameraPosition = CameraPosition(
      target: LatLng(latLng.latitude, latLng.longitude),
      zoom: zoom,
    );

    _lastCameraPosition = cameraPosition;
    await state.mapController
        ?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  void _requestUserStatUpdates() async {
    try {
      final user = state.selectedUser;
      if (user == null) return;
      await authService.requestUserStatUpdates(user.id, (user) {
        if (user != null) state = state.copyWith(selectedUser: user);
      }, lastUpdatedTime: user.updated_at);
    } catch (error, stack) {
      logger.e(
        'MapViewNotifier: Error while getting network status',
        error: error,
        stackTrace: stack,
      );
    }
  }

  void fetchCurrentUserLocation() async {
    try {
      final location = await locationManager.getLastLocation();

      final currentLocation = state.currentUserLocation;
      final hasLocation = currentLocation != null &&
          currentLocation.longitude != 0.0 &&
          currentLocation.latitude != 0.0;

      if (_currentUser != null && location != null && !hasLocation) {
        locationManager.saveLocation(LocationData(
            latitude: location.latitude,
            longitude: location.longitude,
            timestamp: location.timestamp));
        if (state.selectedUser == null) {
          _mapCameraPosition(LatLng(location.latitude, location.longitude));
        }
      }
    } catch (error, stack) {
      logger.e('MapViewNotifier: error while get current location',
          error: error, stackTrace: stack);
    }
  }

  void setMapType(String type) {
    mapTypeController.state = type;
    state = state.copyWith(mapType: type);
  }

  MapTypeInfo getMapTypeInfo() {
    if (mapTypeController.state == 'Normal') {
      return MapTypeInfo(MapType.normal, 0);
    } else if (mapTypeController.state == 'Terrain') {
      return MapTypeInfo(MapType.terrain, 1);
    } else if (mapTypeController.state == 'Satellite') {
      return MapTypeInfo(MapType.satellite, 2);
    }
    return MapTypeInfo(MapType.normal, 0);
  }

  @override
  void dispose() {
    super.dispose();
    state.mapController?.dispose();
    _userInfoSubscription?.cancel();
    _placeSubscription?.cancel();
  }

  bool isCurrentUser() {
    return _currentUser?.id == state.selectedUser?.id;
  }

  void onMapCreated(GoogleMapController controller) async {
    state = state.copyWith(mapController: controller);
  }
}

@freezed
class MapViewState with _$MapViewState {
  const factory MapViewState({
    @Default(false) loading,
    @Default(false) bool fetchingInviteCode,
    @Default(false) bool hasLocationEnabled,
    @Default(false) bool hasLocationServiceEnabled,
    @Default(false) bool hasNotificationEnabled,
    @Default(false) bool hasFineLocationEnabled,
    @Default([]) List<ApiPlace> places,
    @Default({}) Map<String, MapUserInfo> userInfos,
    ApiUser? selectedUser,
    LatLng? currentUserLocation,
    required CameraPosition defaultPosition,
    @Default('') String spaceInvitationCode,
    required String mapType,
    Object? error,
    DateTime? showLocationDialog,
    GoogleMapController? mapController,
  }) = _MapViewState;
}

@freezed
class MapUserInfo with _$MapUserInfo {
  const MapUserInfo._();

  const factory MapUserInfo({
    required String userId,
    required ApiUser user,
    required ui.Image? imageUrl,
    required double latitude,
    required double longitude,
    required bool isSelected,
    @Default(0) int? updatedLocationAt,
  }) = _MapUserInfo;

  LatLng get latLng => LatLng(latitude, longitude);
}
