import 'package:data/api/auth/auth_models.dart';
import 'package:data/log/logger.dart';
import 'package:data/service/space_service.dart';
import 'package:data/storage/app_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_space_view_model.freezed.dart';

final createSpaceViewStateProvider = StateNotifierProvider.autoDispose<
    CreateSpaceViewNotifier, CreateSpaceViewState>((ref) {
  return CreateSpaceViewNotifier(
      ref.read(spaceServiceProvider), ref.read(currentUserPod));
});

class CreateSpaceViewNotifier extends StateNotifier<CreateSpaceViewState> {
  final SpaceService spaceService;
  final ApiUser? currentUser;

  CreateSpaceViewNotifier(this.spaceService, this.currentUser)
      : super(
          CreateSpaceViewState(spaceName: TextEditingController()),
        );

  Future<void> createSpace() async {
    try {
      if (currentUser == null) return;
      state = state.copyWith(isCreating: true, invitationCode: '', error: null);
      final invitationCode = await spaceService.createSpaceAndGetInviteCode(
          spaceName: state.spaceName.text,
          userId: currentUser!.id,
          identityKeyPublic: currentUser!.identity_key_public);
      state = state.copyWith(isCreating: false, invitationCode: invitationCode);
    } catch (error, stack) {
      state = state.copyWith(error: error, isCreating: false);
      logger.e(
        'CreateSpaceViewNotifier: $error - error while creating new space',
        error: error,
        stackTrace: stack,
      );
    }
  }

  void updateSelectedSpaceName(String message) {
    if (message != state.selectedSpaceName) {
      state = state.copyWith(
        selectedSpaceName: message,
        spaceName: TextEditingController(text: message),
        allowSave: message.isNotEmpty,
      );
    } else {
      state = state.copyWith(
          selectedSpaceName: '',
          spaceName: TextEditingController(text: ''),
          allowSave: false);
    }
  }

  void onChange() {
    state = state.copyWith(allowSave: state.spaceName.text.isNotEmpty);
  }

  @override
  void dispose() {
    state.spaceName.dispose();
    super.dispose();
  }
}

@freezed
class CreateSpaceViewState with _$CreateSpaceViewState {
  const factory CreateSpaceViewState({
    @Default(false) bool allowSave,
    @Default(false) bool isCreating,
    @Default('') String selectedSpaceName,
    @Default('') String invitationCode,
    required TextEditingController spaceName,
    Object? error,
  }) = _CreateSpaceViewState;
}
