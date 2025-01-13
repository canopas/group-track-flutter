import 'package:data/api/auth/auth_models.dart';
import 'package:data/log/logger.dart';
import 'package:data/service/auth_service.dart';
import 'package:data/storage/app_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pick_name_view_model.freezed.dart';

final pickNameStateNotifierProvider =
    StateNotifierProvider.autoDispose<PickNameStateNotifier, PickNameState>(
        (ref) {
  return PickNameStateNotifier(
    ref.read(authServiceProvider),
    ref.read(currentUserPod),
  );
});

class PickNameStateNotifier extends StateNotifier<PickNameState> {
  final AuthService _authService;
  final ApiUser? user;

  PickNameStateNotifier(this._authService, this.user)
      : super(PickNameState(
            firstName: TextEditingController(),
            lastName: TextEditingController()));

  void enableNextButton() {
    state = state.copyWith(
        enableBtn: state.firstName.text.isNotEmpty &&
            state.firstName.text.length >= 3);
  }

  Future<void> saveUser() async {
    try {
      if (user == null) return;
      state = state.copyWith(savingUser: true, error: null);
      final firstName = state.firstName.text;
      final lastName = state.lastName.text;

      _authService.updateUserName(firstName: firstName, lastName: lastName);
      state = state.copyWith(savingUser: false, saved: true, error: null);
    } catch (error, stack) {
      state = state.copyWith(savingUser: false, error: error);
      logger.e(
        'PickNameStateNotifier: error while save user',
        error: error,
        stackTrace: stack,
      );
    }
  }

  @override
  void dispose() {
    state.firstName.dispose();
    state.lastName.dispose();
    super.dispose();
  }
}

@freezed
class PickNameState with _$PickNameState {
  const factory PickNameState({
    @Default(false) bool enableBtn,
    @Default(false) bool savingUser,
    @Default(false) bool saved,
    Object? error,
    required TextEditingController firstName,
    required TextEditingController lastName,
  }) = _PickNameState;
}
