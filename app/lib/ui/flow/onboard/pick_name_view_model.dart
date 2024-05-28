import 'package:data/api/auth/auth_models.dart';
import 'package:data/log/logger.dart';
import 'package:data/service/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pick_name_view_model.freezed.dart';

final pickNameStateNotifierProvider =
    StateNotifierProvider.autoDispose<PickNameStateNotifier, PickNameState>(
        (ref) {
  return PickNameStateNotifier(ref.watch(authServiceProvider));
});

class PickNameStateNotifier extends StateNotifier<PickNameState> {
  final AuthService _authService;

  PickNameStateNotifier(this._authService)
      : super(PickNameState(updatedUser: _authService.currentUser));

  void onFirstNameChanged(String value) {
    final updatedUser = state.updatedUser?.copyWith(first_name: value);
    state = state.copyWith(updatedUser: updatedUser);
    _enableNextButton();
  }

  void onLastNameChanged(String value) {
    final updatedUser = state.updatedUser?.copyWith(last_name: value);
    state = state.copyWith(updatedUser: updatedUser);
    _enableNextButton();
  }

  void _enableNextButton() {
    final name = state.updatedUser?.first_name?.trim() ?? '';
    state = state.copyWith(enableBtn: name.isNotEmpty && name.length >= 3);
  }

  Future<void> saveUser() async {
    try {
      if (state.updatedUser == null) return;
      state = state.copyWith(savingUser: true, error: null);
      _authService.updateCurrentUser(state.updatedUser!);
      state = state.copyWith(savingUser: false, saved: true);
    } catch (error, stack) {
      state = state.copyWith(savingUser: false, error: error);
      logger.e(
        'PickNameStateNotifier: error while save user',
        error: error,
        stackTrace: stack,
      );
    }
  }
}

@freezed
class PickNameState with _$PickNameState {
  const factory PickNameState({
    ApiUser? updatedUser,
    @Default(false) bool enableBtn,
    @Default(false) bool savingUser,
    @Default(false) bool saved,
    Object? error,
  }) = _PickNameState;
}
