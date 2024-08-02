import 'dart:async';

import 'package:data/api/auth/api_user_service.dart';
import 'package:data/api/auth/auth_models.dart';
import 'package:data/api/space/space_models.dart';
import 'package:data/log/logger.dart';
import 'package:data/service/auth_service.dart';
import 'package:data/storage/app_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:data/service/space_service.dart';

part 'setting_view_model.freezed.dart';

final settingViewStateProvider =
    StateNotifierProvider.autoDispose<SettingViewNotifier, SettingViewState>(
  (ref) => SettingViewNotifier(
    ref.read(spaceServiceProvider),
    ref.read(authServiceProvider),
    ref.read(apiUserServiceProvider),
    ref.read(currentUserPod),
  ),
);

class SettingViewNotifier extends StateNotifier<SettingViewState> {
  final SpaceService spaceService;
  final AuthService authService;
  final ApiUserService userService;
  final ApiUser? user;
  late StreamSubscription<ApiUser?>? _userSubscription;

  SettingViewNotifier(this.spaceService, this.authService, this.userService, this.user)
      : super(const SettingViewState()) {
    getUser();
    getUserSpace();
  }

  @override
  void dispose() {
    cancelSubscriptions();
    super.dispose();
  }

  void getUser() {
    state = state.copyWith(currentUser: user);
    cancelSubscriptions();
    _userSubscription = authService
        .getUserStream(currentUserId: state.currentUser?.id ?? '')
        .listen((user) {
      state = state.copyWith(currentUser: user);
    });
  }

  void getUserSpace() async {
    try {
      state = state.copyWith(loading: state.spaces.isEmpty);
      final spaces = await spaceService.getUserSpaces(state.currentUser?.id ?? '');
      final nonNullSpaces = spaces.where((space) => space != null).cast<ApiSpace>().toList();
      state = state.copyWith(spaces: nonNullSpaces, loading: false, error: null);
    } catch (error, stack) {
      logger.e(
        'SettingViewNotifier: error while fetching user space',
        error: error,
        stackTrace: stack,
      );
      state = state.copyWith(error: error, loading: false);
    }
  }

  void signOut() async {
    try {
      state = state.copyWith(signingOut: true);
      cancelSubscriptions();
      await userService.signOut();
      state = state.copyWith(signingOut: false, logOut: true, error: null);
    } catch (error, stack) {
      state = state.copyWith(error: error, signingOut: false);
      logger.e(
        'SettingViewNotifier: error while sign out',
        error: error,
        stackTrace: stack,
      );
    }
  }

  void cancelSubscriptions() {
    _userSubscription?.cancel();
  }
}

@freezed
class SettingViewState with _$SettingViewState {
  const factory SettingViewState({
    @Default(false) bool loading,
    @Default(false) bool signingOut,
    @Default(false) bool logOut,
    @Default('') String selectedSpaceName,
    @Default([]) List<ApiSpace> spaces,
    ApiUser? currentUser,
    Object? error,
  }) = _SettingViewState;
}
