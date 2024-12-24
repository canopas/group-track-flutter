import 'package:data/log/logger.dart';
import 'package:data/service/space_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_space_view_model.freezed.dart';

final createSpaceViewStateProvider = StateNotifierProvider.autoDispose<
    CreateSpaceViewNotifier, CreateSpaceViewState>((ref) {
  return CreateSpaceViewNotifier(
    ref.read(spaceServiceProvider),
  );
});

class CreateSpaceViewNotifier extends StateNotifier<CreateSpaceViewState> {
  final SpaceService spaceService;

  CreateSpaceViewNotifier(this.spaceService)
      : super(
          CreateSpaceViewState(spaceName: TextEditingController()),
        );

  Future<void> createSpace() async {
    try {
      state = state.copyWith(isCreating: true, invitationCode: '', error: null);
      final invitationCode =
          await spaceService.createSpaceAndGetInviteCode(state.spaceName.text);
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
