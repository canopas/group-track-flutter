import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:data/api/auth/api_user_service.dart';
import 'package:data/api/auth/auth_models.dart';
import 'package:data/api/location/location.dart';
import 'package:data/api/space/space_models.dart';
import 'package:data/log/logger.dart';
import 'package:data/service/permission_service.dart';
import 'package:data/service/space_service.dart';
import 'package:data/storage/app_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';

import '../../components/no_internet_screen.dart';

part 'home_screen_viewmodel.freezed.dart';

final homeViewStateProvider =
    StateNotifierProvider.autoDispose<HomeViewNotifier, HomeViewState>(
  (ref) => HomeViewNotifier(
    ref.read(spaceServiceProvider),
    ref.read(currentSpaceId.notifier),
    ref.read(permissionServiceProvider),
    ref.read(lastBatteryDialogPod.notifier),
    ref.read(currentUserPod),
    ref.read(apiUserServiceProvider),
    ref.read(currentUserSessionPod),
  ),
);

class HomeViewNotifier extends StateNotifier<HomeViewState> {
  final SpaceService spaceService;
  final PermissionService permissionService;
  final StateController<String?> _currentSpaceIdController;
  final StateController<String?> _lastBatteryDialogDate;
  final ApiUser? _currentUser;
  final ApiUserService userService;
  final ApiSession? _userSession;

  HomeViewNotifier(
    this.spaceService,
    this._currentSpaceIdController,
    this.permissionService,
    this._lastBatteryDialogDate,
    this._currentUser,
    this.userService,
    this._userSession,
  ) : super(const HomeViewState()) {
    setDate();
  }

  StreamSubscription<List<SpaceInfo>>? _spacesSubscription;

  String? get currentSpaceId => _currentSpaceIdController.state;

  void setDate() async {
    final isNetworkOff = await _checkUserInternet();
    if (isNetworkOff) return;

    listenSpaceMember();
    updateCurrentUserNetworkState();

    if (_currentUser == null && _userSession == null) return;
    listenUserSession(_currentUser!.id, _userSession!.id);
  }

  Future<LocationData> currentUserLocation() async {
    if (Platform.isIOS) {
      const platform = MethodChannel('com.grouptrack/current_location');
      final locationFromIOS = await platform.invokeMethod('getCurrentLocation');
      return LocationData(
        latitude: locationFromIOS['latitude'],
        longitude: locationFromIOS['longitude'],
        timestamp: DateTime.fromMillisecondsSinceEpoch(
            locationFromIOS['timestamp'].toInt()),
      );
    } else {
      var location = await Geolocator.getCurrentPosition();
      return LocationData(
          latitude: location.latitude,
          longitude: location.longitude,
          timestamp: DateTime.now());
    }
  }

  void listenSpaceMember() async {
    if (state.loading) return;
    try {
      state = state.copyWith(loading: true);
      _spacesSubscription = spaceService.streamAllSpace().listen((spaces) {
        if (spaces.isNotEmpty) {
          if (state.spaceList.length != spaces.length) {
            reorderSpaces(spaces);
          } else {
            state = state.copyWith(spaceList: spaces);
          }
        } else {
          state = state.copyWith(spaceList: [], selectedSpace: null);
        }
        state = state.copyWith(loading: false, error: null);
      });
    } catch (error, stack) {
      state = state.copyWith(error: error, loading: false);
      logger.e(
        'HomeViewNotifier: error while getting all spaces',
        error: error,
        stackTrace: stack,
      );
    }
  }

  void updateCurrentUserNetworkState() async {
    if (_currentUser == null) return;
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      final userState = await checkUserState(connectivityResult.first);
      await userService.updateUserState(_currentUser.id, userState);
    } catch (error, stack) {
      logger.e(
        'HomeViewNotifier: error while update current user state',
        error: error,
        stackTrace: stack,
      );
    }
  }

  Future<int> checkUserState(ConnectivityResult result) async {
    final isLocationEnabled = await permissionService.isLocationAlwaysEnabled();
    final isConnected = result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi;

    if (isConnected && isLocationEnabled) {
      return USER_STATE_ONLINE;
    } else if (!isLocationEnabled) {
      return USER_STATE_LOCATION_PERMISSION_DENIED;
    } else {
      return USER_STATE_NO_NETWORK_OR_PHONE_OFF;
    }
  }

  void onAddMemberTap() async {
    try {
      state = state.copyWith(fetchingInviteCode: true, spaceInvitationCode: '');
      final code =
          await spaceService.getInviteCode(state.selectedSpace?.space.id ?? '');
      state = state.copyWith(
          spaceInvitationCode: code ?? '',
          fetchingInviteCode: false,
          error: null);
    } catch (error, stack) {
      state = state.copyWith(error: error, fetchingInviteCode: false);
      logger.e(
        'HomeViewNotifier: Error while getting invitation code',
        error: error,
        stackTrace: stack,
      );
    }
  }

  void reorderSpaces(List<SpaceInfo> spaces) {
    final sortedSpaces = spaces.toList();
    if ((currentSpaceId?.isNotEmpty ?? false) &&
        spaces.isNotEmpty &&
        spaces.length > 1) {
      final selectedSpaceIndex =
          sortedSpaces.indexWhere((space) => space.space.id == currentSpaceId);
      if (selectedSpaceIndex > -1) {
        final selectedSpace = sortedSpaces.removeAt(selectedSpaceIndex);
        sortedSpaces.insert(0, selectedSpace);
        updateSelectedSpace(selectedSpace);
        state = state.copyWith(selectedSpace: selectedSpace);
      }
    }
    if (currentSpaceId == null && sortedSpaces.isNotEmpty) {
      _currentSpaceIdController.state = sortedSpaces.first.space.id;
      updateSelectedSpace(sortedSpaces.first);
      state = state.copyWith(selectedSpace: sortedSpaces.first);
    }
    state = state.copyWith(
        selectedSpace: sortedSpaces.first, spaceList: sortedSpaces);
  }

  void updateSelectedSpace(SpaceInfo space) {
    if (space != state.selectedSpace) {
      final members = space.members
          .where((member) => member.user.id == _currentUser!.id)
          .toList();
      state = state.copyWith(
        selectedSpace: space,
        locationEnabled: members.isEmpty
            ? _currentUser?.location_enabled ?? true
            : members.first.isLocationEnabled,
      );
      _currentSpaceIdController.state = space.space.id;
    }
  }

  void showBatteryOptimizationDialog() async {
    // We don't want to show prompt immediately after user opens the app
    await Future.delayed(const Duration(seconds: 1));
    final date = _lastBatteryDialogDate.state;

    if (date == null) {
      _checkBatteryPermission();
    } else {
      final storedDate = DateTime.parse(date);
      final currentDate = DateTime.now();
      final daysPassed = currentDate.difference(storedDate).inDays;

      if (daysPassed >= 1) {
        _checkBatteryPermission();
      }
    }
  }

  void _checkBatteryPermission() async {
    final isBatteryOptimization =
        await permissionService.isBatteryOptimizationEnabled();
    final isBackgroundEnabled =
        await permissionService.isBackgroundLocationPermissionGranted();

    if (!isBatteryOptimization && isBackgroundEnabled) {
      _lastBatteryDialogDate.state = DateTime.now().toString();
      state = state.copyWith(showBatteryDialog: DateTime.now());
    }
  }

  void requestIgnoreBatteryOptimizations() async {
    await permissionService.requestIgnoreBatteryOptimizations();
  }

  void toggleLocation() async {
    if (currentSpaceId == null || _currentUser == null) return;
    try {
      final isEnabled = !state.locationEnabled;
      state = state.copyWith(enablingLocation: true);
      await spaceService.enableLocation(
        currentSpaceId!,
        _currentUser.id,
        isEnabled,
      );
      state = state.copyWith(
          enablingLocation: false, locationEnabled: isEnabled, error: null);
    } catch (error, stack) {
      state = state.copyWith(enablingLocation: false, error: error);
      logger.e(
        'HomeViewNotifier: Error while location enabled or disabled',
        error: error,
        stackTrace: stack,
      );
    }
  }

  void listenUserSession(String userId, String sessionId) async {
    try {
      userService.getUserSessionByIdStream(userId, sessionId).listen((session) {
        if (session != null && !session.session_active) {
          state = state.copyWith(isSessionExpired: true, error: null);
        }
      });
    } catch (error, stack) {
      state = state.copyWith(error: error);
      logger.e(
        'HomeViewNotifier: error while listening user session',
        error: error,
        stackTrace: stack,
      );
    }
  }

  void signOut() async {
    await userService.signOut();
    state =
        state.copyWith(popToSignIn: DateTime.now(), isSessionExpired: false);
  }

  Future<bool> _checkUserInternet() async {
    final isNetworkOff = await checkInternetConnectivity();
    state = state.copyWith(isNetworkOff: isNetworkOff);
    if (isNetworkOff) _spacesSubscription?.cancel();
    return isNetworkOff;
  }
}

@freezed
class HomeViewState with _$HomeViewState {
  const factory HomeViewState({
    @Default(false) bool allowSave,
    @Default(false) bool isCreating,
    @Default(false) bool loading,
    @Default(false) bool fetchingInviteCode,
    @Default(false) bool enablingLocation,
    @Default(true) bool locationEnabled,
    @Default(false) bool isSessionExpired,
    @Default(false) bool isNetworkOff,
    DateTime? popToSignIn,
    SpaceInfo? selectedSpace,
    @Default('') String spaceInvitationCode,
    @Default([]) List<SpaceInfo> spaceList,
    Object? error,
    DateTime? showBatteryDialog,
  }) = _HomeViewState;
}
