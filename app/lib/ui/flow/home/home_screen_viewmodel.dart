import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:data/api/auth/api_user_service.dart';
import 'package:data/api/auth/auth_models.dart';
import 'package:data/api/place/api_place.dart';
import 'package:data/api/space/space_models.dart';
import 'package:data/log/logger.dart';
import 'package:data/service/geofence_service.dart';
import 'package:data/service/permission_service.dart';
import 'package:data/service/space_service.dart';
import 'package:data/storage/app_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../components/no_internet_screen.dart';

part 'home_screen_viewmodel.freezed.dart';

final homeViewStateProvider =
    StateNotifierProvider.autoDispose<HomeViewNotifier, HomeViewState>((ref) {
  final notifier = HomeViewNotifier(
    ref.read(spaceServiceProvider),
    ref.read(currentSpaceId.notifier),
    ref.read(permissionServiceProvider),
    ref.read(lastBatteryDialogPod.notifier),
    ref.read(currentUserPod),
    ref.read(apiUserServiceProvider),
    ref.read(currentUserSessionPod),
  );
  ref.listen(currentUserPod, (prev, user) {
    notifier._onUpdateUser(prevUser: prev, currentUser: user);
  });

  ref.listen(currentSpaceId, (prev, newSpaceId) {
    notifier._onUpdateSpace(prev: prev, current: newSpaceId);
  });

  return notifier;
});

class HomeViewNotifier extends StateNotifier<HomeViewState> {
  final SpaceService spaceService;
  final PermissionService permissionService;
  final StateController<String?> _currentSpaceIdController;
  final StateController<String?> _lastBatteryDialogDate;
  ApiUser? _currentUser;
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
    fetchData();
    _listenPlaces();
  }

  StreamSubscription<List<SpaceInfo>>? _spacesSubscription;
  StreamSubscription<ApiSession?>? _userSessionSubscription;
  StreamSubscription<List<ApiPlace>?>? _spacePlacesSubscription;

  String? get currentSpaceId => _currentSpaceIdController.state;

  void fetchData() async {
    final isNetworkOff = await _checkUserInternet();
    if (isNetworkOff) return;

    listenSpaceMember();
    updateCurrentUserNetworkState();

    listenUserSession();
  }

  void _listenPlaces() async {
    if (_currentUser == null) return;
    try {
      _spacePlacesSubscription?.cancel();
      if (_currentUser?.space_ids?.isEmpty ?? true) return;
      _spacePlacesSubscription = spaceService
          .getStreamPlacesByUserId(_currentUser?.space_ids ?? List.empty())
          .listen((places) {
        if (places.isEmpty) {
          logger.e('No places found for spaces.');
          return;
        }


        GeofenceService.startMonitoring(places);
      });
    } catch (error) {
      logger.e('GeofenceRepository: error while get user space $error');
    }
  }

  void _onUpdateSpace({String? prev, String? current}) {
    if (prev == current) return;

    _spacePlacesSubscription?.cancel();
    _spacesSubscription?.cancel();

    if (current == null) {
      state = state.copyWith(selectedSpace: null);
    }

    listenSpaceMember();
    _listenPlaces();
  }

  void _onUpdateUser({ApiUser? prevUser, ApiUser? currentUser}) {
    _currentUser = currentUser;
    if (currentUser == null) {
      _cancelSubscriptions();
      state = state.copyWith(spaceList: [], selectedSpace: null);
    } else if (prevUser?.id != currentUser.id) {
      fetchData();
      _listenPlaces();
    } else if (prevUser?.space_ids != currentUser.space_ids) {
      _listenPlaces();
    }
  }

  void _cancelSubscriptions() {
    _spacePlacesSubscription?.cancel();
    _spacesSubscription?.cancel();
    _userSessionSubscription?.cancel();
  }

  void listenSpaceMember() async {
    final userId = _currentUser?.id;

    if (state.loading || userId == null) return;
    try {
      _spacesSubscription?.cancel();
      state = state.copyWith(loading: true);

      _spacesSubscription =
          spaceService.streamAllSpace(userId).listen((spaces) {
        if ((currentSpaceId?.isEmpty ?? true) && spaces.isNotEmpty) {
          spaceService.currentSpaceId = spaces.firstOrNull?.space.id;
        }

        _reorderSpaces(spaces);

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
      await userService.updateUserState(_currentUser!.id, userState);
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

  void _reorderSpaces(List<SpaceInfo> spaces) {
    final sortedSpaces = spaces.toList();
    if ((currentSpaceId?.isNotEmpty ?? false) &&
        spaces.isNotEmpty &&
        spaces.length > 1) {
      final selectedSpaceIndex =
          sortedSpaces.indexWhere((space) => space.space.id == currentSpaceId);
      if (selectedSpaceIndex > -1) {
        final selectedSpace = sortedSpaces.removeAt(selectedSpaceIndex);
        sortedSpaces.insert(0, selectedSpace);
      }
    }
    state = state.copyWith(
        selectedSpace: sortedSpaces.firstOrNull, spaceList: sortedSpaces);
  }

  void updateSelectedSpace(SpaceInfo space) {
    if (space != state.selectedSpace) {
      state = state.copyWith(
          selectedSpace: space,
          locationEnabled: _currentUser?.location_enabled ?? true);

      spaceService.currentSpaceId = space.space.id;
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
        _currentUser!.id,
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

  void listenUserSession() async {
    if (_currentUser == null && _userSession == null) return;
    try {
      final userId = _currentUser!.id;
      final sessionId = _userSession!.id;
      _userSessionSubscription?.cancel();
      _userSessionSubscription = userService
          .getUserSessionByIdStream(userId, sessionId)
          .listen((session) {
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

  void updateExpandState(bool expand) {
    state = state.copyWith(expand: expand);
  }

  @override
  void dispose() {
    _cancelSubscriptions();
    super.dispose();
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
    @Default(false) bool expand,
    DateTime? popToSignIn,
    SpaceInfo? selectedSpace,
    @Default('') String spaceInvitationCode,
    @Default([]) List<SpaceInfo> spaceList,
    Object? error,
    DateTime? showBatteryDialog,
  }) = _HomeViewState;
}
