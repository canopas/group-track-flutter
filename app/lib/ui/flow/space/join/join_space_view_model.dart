import 'package:data/api/space/api_space_invitation_service.dart';
import 'package:data/api/space/space_models.dart';
import 'package:data/service/auth_service.dart';
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
    ref.read(authServiceProvider),
  );
});

class JoinSpaceViewNotifier extends StateNotifier<JoinSpaceViewState> {
  final SpaceService spaceService;
  final ApiSpaceInvitationService spaceInvitationService;
  final AuthService authService;

  JoinSpaceViewNotifier(
    this.spaceService,
    this.spaceInvitationService,
    this.authService,
  ) : super(const JoinSpaceViewState());

  Future<void> joinSpace(String code) async {
    try {
      state = state.copyWith(verifying: true, errorInvalidInvitationCode: false, alreadySpaceMember: false);
      final invitation = await spaceInvitationService.getInvitation(code);
      if (invitation == null) {
        state =
            state.copyWith(errorInvalidInvitationCode: true, verifying: false);
        return;
      }
      var spaceId = invitation.space_id;
      final userSpaces = authService.currentUser?.space_ids ?? [];

      if (userSpaces.contains(spaceId)) {
        state = state.copyWith(verifying: false, alreadySpaceMember: true, error: null);
        return;
      }

      spaceService.joinSpace(spaceId);
      final space = await spaceService.getSpace(spaceId);
      state = state.copyWith(verifying: false, space: space, spaceJoined: true, error: null);
    } catch (error, stack) {
      state = state.copyWith(error: error, verifying: false);
      logger.e(
        'JoinSpaceViewNotifier: Error while join space with invitation code',
        error: error,
        stackTrace: stack,
      );
    }
  }
}

@freezed
class JoinSpaceViewState with _$JoinSpaceViewState {
  const factory JoinSpaceViewState({
    @Default(false) bool verifying,
    @Default(false) bool spaceJoined,
    @Default('') String invitationCode,
    @Default(false) bool errorInvalidInvitationCode,
    @Default(false) bool alreadySpaceMember,
    Object? error,
    ApiSpace? space,
  }) = _JoinSpaceViewState;
}
