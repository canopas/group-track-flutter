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

  Future<void> joinSpace() async {
    try {
      spaceService.joinSpace(state.space?.id ?? '');
      state = state.copyWith(verifying: false, spaceJoined: true, error: null);
    } catch (error, stack) {
      state = state.copyWith(error: error, verifying: false);
      logger.e(
        'JoinSpaceViewNotifier: Error while join space with invitation code',
        error: error,
        stackTrace: stack,
      );
    }
  }

  Future<String?> getInvitation(String code) async {
    try {
      state = state.copyWith(verifying: true, errorInvalidInvitationCode: false, alreadySpaceMember: false);
      final invitation = await spaceInvitationService.getInvitation(code);
      if (invitation == null) {
        state =
            state.copyWith(errorInvalidInvitationCode: true, verifying: false);
        _resetFlagsAfter30Sec();
        return '';
      }
      var spaceId = invitation.space_id;
      final userSpaces = authService.currentUser?.space_ids ?? [];

      if (userSpaces.contains(spaceId)) {
        state = state.copyWith(verifying: false, alreadySpaceMember: true, error: null);
        _resetFlagsAfter30Sec();
        return '';
      }
      return spaceId;
    } catch (error, stack) {
      logger.e('JoinSpaceViewNotifier: Error while get group invitation',
          error: error, stackTrace: stack);
      return null;
    }
  }

  void getSpace(String code) async {
    try {
      final spaceId = await getInvitation(code);
      final space = await spaceService.getSpace(spaceId ?? '');
      state = state.copyWith(space: space);
    } catch (error, stack) {
      logger.e('JoinSpaceViewNotifier: Error while get space',
          error: error, stackTrace: stack);
    }
  }

  void _resetFlagsAfter30Sec() {
    Future.delayed(const Duration(seconds: 10), () {
      state = state.copyWith(
        errorInvalidInvitationCode: false,
        alreadySpaceMember: false,
      );
    });
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
