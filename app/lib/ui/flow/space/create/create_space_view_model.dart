import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:data/service/space/space_service.dart';
import 'package:data/log/logger.dart';

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
      state = state.copyWith(creating: true);
      final invitationCode = await spaceService.createSpaceAndGetInviteCode(state.spaceName.text);
      print(invitationCode);
      state = state.copyWith(creating: false, invitationCode: invitationCode);
      print(invitationCode);
    } catch (error, stack) {
      logger.e(
        'CreateSpaceViewNotifier: $error - error while creating new space',
        error: error,
        stackTrace: stack,
      );
      state = state.copyWith(creating: false);
    }
  }

  void updateSelectedNudgeMessage(String message) {
    if (message != state.selectedSpaceName) {
      state = state.copyWith(
        selectedSpaceName: message,
        spaceName: TextEditingController(text: message),
      );
    } else {
      state = state.copyWith(
        selectedSpaceName: '',
        spaceName: TextEditingController(text: ''),
      );
    }
  }

  void onChange(String spaceName) {
    state = state.copyWith(selectedSpaceName: spaceName);
  }
}

@freezed
class CreateSpaceViewState with _$CreateSpaceViewState {
  const factory CreateSpaceViewState({
    @Default(false) bool creating,
    @Default('') String selectedSpaceName,
    @Default('') String invitationCode,
    required TextEditingController spaceName,
  }) = _CreateSpaceViewState;
}
