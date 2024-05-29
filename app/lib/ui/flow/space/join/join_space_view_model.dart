import 'package:data/api/space/api_space_invitation_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:data/service/space_service.dart';
import 'package:data/log/logger.dart';

part 'join_space_view_model.freezed.dart';

final joinSpaceViewStateProvider = StateNotifierProvider.autoDispose<
    JoinSpaceViewNotifier, JoinSpaceViewState>((ref) {
  return JoinSpaceViewNotifier(
    ref.read(spaceServiceProvider),
    ref.read(apiSpaceInvitationServiceProvider),
  );
});

class JoinSpaceViewNotifier extends StateNotifier<JoinSpaceViewState> {
  final SpaceService spaceService;
  final ApiSpaceInvitationService spaceInvitationService;

  JoinSpaceViewNotifier(this.spaceService, this.spaceInvitationService) : super(const JoinSpaceViewState());

  Future<void> joinSpace() async {
    try {
      spaceInvitationService.getInvitation(state.invitationCode);

    } catch (error, stack) {
      logger.e(
        'JoinSpaceViewNotifier: Error while creating join space',
        error: error,
        stackTrace: stack,
      );
    }
  }
}

@freezed
class JoinSpaceViewState with _$JoinSpaceViewState {
  const factory JoinSpaceViewState({
    @Default(false) bool allowSave,
    @Default('') String invitationCode,
  }) = _JoinSpaceViewState;
}
