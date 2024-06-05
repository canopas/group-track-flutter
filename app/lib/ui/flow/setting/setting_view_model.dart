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

  SettingViewNotifier(this.spaceService, this.authService, this.userService, this.user)
      : super(const SettingViewState()) {
    getUser();
  }

  void getUser() {
    state = state.copyWith(currentUser: user);
    authService.getUserStream().listen((user) {
      state = state.copyWith(currentUser: user);
    });
  }

  void getUserSpace() async {
    try {
      state = state.copyWith(loading: state.spaces.isEmpty);
      final spaces = await spaceService.getUserSpaces(state.currentUser?.id ?? '');
     final nonNullSpaces = spaces.where((space) => space != null).cast<ApiSpace>().toList();
     state = state.copyWith(spaces: nonNullSpaces, loading: false);
    } catch (error, stack) {
      logger.e(
        'SettingViewNotifier: error while fetching user space',
        error: error,
        stackTrace: stack,
      );
    }
  }

  void signOut() async {
    try {
      state = state.copyWith(signingOut: true);
      await userService.signOut();
      state = state.copyWith(signingOut: false, logOut: true);
    } catch (error, stack) {
      logger.e(
        'SettingViewNotifier: error while sign out',
        error: error,
        stackTrace: stack,
      );
    }
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
  }) = _SettingViewState;
}