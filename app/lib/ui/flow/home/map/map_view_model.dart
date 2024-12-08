import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:data/api/auth/auth_models.dart';
import 'package:data/api/location/location.dart';
import 'package:data/api/place/api_place.dart';
import 'package:data/api/space/space_models.dart';
import 'package:data/log/logger.dart';
import 'package:data/service/auth_service.dart';
import 'package:data/service/location_manager.dart';
import 'package:data/service/location_service.dart';
import 'package:data/service/permission_service.dart';
import 'package:data/service/place_service.dart';
import 'package:data/service/space_service.dart';
import 'package:data/storage/app_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image/image.dart' as img;

import 'map_screen.dart';

part 'map_view_model.freezed.dart';

const FOUR_MIN_SECONDS = 4 * 60 * 1000;

final mapViewStateProvider =
    StateNotifierProvider.autoDispose<MapViewNotifier, MapViewState>((ref) {
  return MapViewNotifier(
    ref.read(currentUserPod),
    ref.read(spaceServiceProvider),
    ref.read(placeServiceProvider),
    ref.read(permissionServiceProvider),
    ref.read(locationServiceProvider),
    ref.read(locationManagerProvider),
    ref.read(authServiceProvider),
    ref.read(googleMapType.notifier),
  );
});

class MapViewNotifier extends StateNotifier<MapViewState> {
  final ApiUser? _currentUser;
  final SpaceService spaceService;
  final PlaceService placeService;
  final PermissionService permissionService;
  final LocationService locationService;
  final LocationManager locationManager;
  final AuthService authService;
  final StateController<String> mapTypeController;

  LatLng? _userLocation;
  StreamSubscription<SpaceInfo>? _userInfoSubscription;
  StreamSubscription<List<ApiPlace>>? _placeSubscription;

  MapViewNotifier(
    this._currentUser,
    this.spaceService,
    this.placeService,
    this.permissionService,
    this.locationService,
    this.locationManager,
    this.authService,
    this.mapTypeController,
  ) : super(MapViewState(mapType: mapTypeController.state)) {
    checkUserPermission();
    _getCurrentUserLastLocation();
  }

  void loadData(String? spaceId) {
    _onSelectedSpaceChange();

    if (spaceId == null) return;
    state = state.copyWith(spaceId: spaceId);

    _listenMemberLocation(spaceId);
    _listenPlaces(spaceId);
  }

  void _onSelectedSpaceChange() {
    state = state.copyWith(
      userInfo: [],
      places: [],
      markers: [],
      defaultPosition: null,
      selectedUser: null,
    );
  }

  void _listenMemberLocation(String spaceId) async {
    if (state.loading) return;
    try {
      state = state.copyWith(loading: true, selectedUser: null);
      await _userInfoSubscription?.cancel();
      _userInfoSubscription =
          spaceService.getMemberWithLocation(spaceId).listen((spaceInfo) {
        state = state.copyWith(userInfo: spaceInfo.members, loading: false);
        _userMapPositions(spaceInfo);
        getSelectedUserLocation(spaceId: spaceId, userId: state.selectedUser?.id ?? spaceInfo.members.first.id);
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
      await _placeSubscription?.cancel();
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

  Future<void> getSelectedUserLocation({required String spaceId, required String userId}) async {
    try {
      locationService.streamUserLatestLocation(userId: userId, spaceId: spaceId).listen((location) {
        state = state.copyWith(selectedUserLocation: location);
      });
    } catch (error, stack) {
      logger.e('MapViewNotifier: error while get selected user location',
      error: error, stackTrace: stack);
    }
  }

  void _userMapPositions(SpaceInfo space) async {
    final List<UserMarker> markers = [];
    for (final member in space.spaceMember) {
      locationService.streamUserLatestLocation(userId: member.user_id, spaceId: member.space_id).listen((location) async {
        if (member.user_id == _currentUser?.id && _userLocation == null) {
          final latLng = LatLng(
            location?.latitude ?? 0.0,
            location?.longitude ?? 0.0,
          );
          _userLocation = latLng;
          _mapCameraPosition(latLng, defaultCameraZoom);
        }

        final spaceMember = state.userInfo.firstWhere(
              (user) => user.id == member.user_id,
        );

        if (location != null && member.location_enabled) {
          markers.add(UserMarker(
              userId: member.user_id,
              userName: spaceMember.fullName,
              imageUrl: await _convertUrlToImage(spaceMember.profile_image),
            latitude: location.latitude,
            longitude: location.longitude,
            isSelected: state.selectedUser == null
                ? false
                : state.selectedUser?.id == member.id,
          ));
      }
      });
    }

    state = state.copyWith(markers: markers);
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
    state = state.copyWith(selectedUser: null, defaultPosition: null);
    _onSelectUserMarker(null);
  }

  void showMemberDetail(ApiUser member) async {
    final selectedMember =
        (state.selectedUser?.id == member.id) ? null : member;
    final position = (selectedMember != null && state.selectedUserLocation != null)
        ? CameraPosition(
            target: LatLng(state.selectedUserLocation!.latitude,
                state.selectedUserLocation!.longitude),
            zoom: defaultCameraZoomForSelectedUser)
        : null;

    state =
        state.copyWith(selectedUser: selectedMember, defaultPosition: position);
    await getSelectedUserLocation(spaceId: state.spaceId, userId: state.selectedUser?.id ?? '');
    _onSelectUserMarker(member.id);
    if (state.selectedUser != null) {
      getNetworkStatus();
    }
  }

  void _onSelectUserMarker(String? userId) {
    final List<UserMarker> updatedMarkers;

    if (userId == null) {
      updatedMarkers = state.markers
          .map((marker) => marker.copyWith(isSelected: false))
          .toList();
    } else {
      updatedMarkers = state.markers.map((marker) {
        return marker.userId == userId
            ? marker.copyWith(isSelected: !marker.isSelected)
            : marker.copyWith(isSelected: false);
      }).toList();
    }
    state = state.copyWith(markers: updatedMarkers);
  }

  void onTapUserMarker(String userId) {
    final user = state.userInfo.firstWhere((user) => user.id == userId);
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
    final isRunning = await locationManager.isServiceRunning();
    if (isPermission && !isRunning) {
      locationManager.startService();
    }
  }

  void showEnableLocationDialog() {
    state = state.copyWith(showLocationDialog: DateTime.now());
  }

  void getUserLastLocation() async {
    try {
      state = state.copyWith(defaultPosition: null);
      final isEnabled = await permissionService.isLocationPermissionGranted();
      if (isEnabled) {
        final position = await locationManager.getLastLocation();
        final latLng = LatLng(position!.latitude, position.longitude);
        _mapCameraPosition(latLng, defaultCameraZoom);
      } else {
        for (final member in state.spaceMember) {
          locationService.streamUserLatestLocation(userId: _currentUser?.id ?? '', spaceId: member.space_id).listen((location) {
            if (member.id == _currentUser?.id) {
              final latLng = LatLng(
                location?.latitude ?? 0.0,
                location?.longitude ?? 0.0,
              );
              _mapCameraPosition(latLng, defaultCameraZoom);
            }
          });
        }
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

  void _mapCameraPosition(LatLng latLng, double zoom) {
    final cameraPosition = CameraPosition(
      target: LatLng(latLng.latitude, latLng.longitude),
      zoom: zoom,
    );
    state = state.copyWith(defaultPosition: cameraPosition);
  }

  void getNetworkStatus() async {
    try {
      await authService.getUserNetworkStatus(state.selectedUser!.id, (user) {
        state = state.copyWith(selectedUser: user);
      });
    } catch (error, stack) {
      logger.e(
        'MapViewNotifier: Error while getting network status',
        error: error,
        stackTrace: stack,
      );
    }
  }

  void _getCurrentUserLastLocation() async {
    try {
      final location = await _currentUserLocation();
      state = state.copyWith(
          currentUserLocation: LatLng(location.latitude, location.longitude));
    } catch (error, stack) {
      logger.e('MapViewNotifier: error while get current location',
          error: error, stackTrace: stack);
    }
  }

  Future<LatLng> _currentUserLocation() async {
    if (Platform.isIOS) {
      const platform = MethodChannel('com.grouptrack/current_location');
      final locationFromIOS = await platform.invokeMethod('getCurrentLocation');
      return LatLng(locationFromIOS['latitude'], locationFromIOS['longitude']);
    } else {
      var location = await Geolocator.getCurrentPosition();
      return LatLng(location.latitude, location.longitude);
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
    _userInfoSubscription?.cancel();
    _placeSubscription?.cancel();
  }

  bool isCurrentUser() {
    return _currentUser?.id == state.selectedUser?.id;
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
    @Default([]) List<ApiSpaceMember> spaceMember,
    @Default([]) List<ApiUser> userInfo,
    @Default([]) List<ApiPlace> places,
    @Default([]) List<UserMarker> markers,
    @Default('') String spaceId,
    ApiUser? selectedUser,
    LatLng? currentUserLocation,
    ApiLocation? selectedUserLocation,
    CameraPosition? defaultPosition,
    @Default('') String spaceInvitationCode,
    required String mapType,
    Object? error,
    DateTime? showLocationDialog,
  }) = _MapViewState;
}

@freezed
class UserMarker with _$UserMarker {
  const factory UserMarker({
    required String userId,
    required String userName,
    required ui.Image? imageUrl,
    required double latitude,
    required double longitude,
    required bool isSelected,
  }) = _UserMarker;
}
