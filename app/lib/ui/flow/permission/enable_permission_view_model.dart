import 'package:data/api/auth/api_user_service.dart';
import 'package:data/api/auth/auth_models.dart';
import 'package:data/log/logger.dart';
import 'package:data/service/location_manager.dart';
import 'package:data/service/permission_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:permission_handler/permission_handler.dart';

part 'enable_permission_view_model.freezed.dart';

final permissionStateProvider = StateNotifierProvider.autoDispose<
    PermissionViewNotifier, PermissionViewState>((ref) {
  return PermissionViewNotifier(
    ref.read(permissionServiceProvider),
    ref.read(locationManagerProvider),
    ref.read(apiUserServiceProvider),
  );
});

class PermissionViewNotifier extends StateNotifier<PermissionViewState> {
  final PermissionService permissionService;
  final LocationManager locationManager;
  final ApiUserService userService;

  PermissionViewNotifier(this.permissionService, this.locationManager, this.userService)
      : super(const PermissionViewState()) {
    checkUserPermissions();
  }

  void checkUserPermissions() async {
    final isLocationGranted =
        await permissionService.isLocationPermissionGranted();
    final isBackGroundLocationGranted =
        await permissionService.isBackgroundLocationPermissionGranted();
    final isNotificationGranted =
        await permissionService.hasNotificationPermission();

    state = state.copyWith(
      isLocationGranted: isLocationGranted,
      isBackGroundLocationGranted: isBackGroundLocationGranted,
      isNotificationGranted: isNotificationGranted,
    );
  }

  Future<void> requestLocationPermission() async {
    final permissionState = await permissionService.requestLocationPermission();
    if (permissionState.isGranted) {
      state = state.copyWith(isLocationGranted: true);
    } else {
      state = state.copyWith(showLocationPrompt: DateTime.now());
    }
  }

  Future<void> requestBackgroundLocationPermission() async {
    if (state.isLocationGranted) {
      final granted =
          await permissionService.requestBackgroundLocationPermission();
      state = state.copyWith(isBackGroundLocationGranted: granted);
      if (granted) {
        locationManager.startTrackingService();
      }
    } else {
      state = state.copyWith(bgAction: DateTime.now());
    }
  }

  Future<void> requestNotificationPermission() async {
    final granted = await permissionService.requestNotificationPermission();
    state = state.copyWith(isNotificationGranted: granted);
  }

  void updateCurrentUserNetworkState() async {
    try {
      await userService.updateUserState(userService.currentUser?.id ?? '', USER_STATE_ONLINE);
    } catch (error, stack) {
      logger.e(
        'HomeViewNotifier: error while update current user state',
        error: error,
        stackTrace: stack,
      );
    }
  }
}

@freezed
class PermissionViewState with _$PermissionViewState {
  const factory PermissionViewState({
    DateTime? bgAction,
    DateTime? showLocationPrompt,
    @Default(false) isLocationGranted,
    @Default(false) isBackGroundLocationGranted,
    @Default(false) isNotificationGranted,
  }) = _PermissionViewState;
}
