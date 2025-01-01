import 'package:data/api/auth/auth_models.dart';
import 'package:data/api/space/api_space_invitation_service.dart';
import 'package:data/api/space/space_models.dart';
import 'package:data/service/auth_service.dart';
import 'package:data/service/place_service.dart';
import 'package:data/storage/app_preferences.dart';
import 'package:flutter/cupertino.dart';
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
    ref.read(placeServiceProvider),
    ref.read(currentUserPod),
  );
});

class JoinSpaceViewNotifier extends StateNotifier<JoinSpaceViewState> {
  final SpaceService spaceService;
  final ApiSpaceInvitationService spaceInvitationService;
  final AuthService authService;
  final PlaceService placeService;
  final ApiUser? _currentUser;

  JoinSpaceViewNotifier(this.spaceService, this.spaceInvitationService,
      this.authService, this.placeService, this._currentUser)
      : super(const JoinSpaceViewState(controllers: [], focusNodes: [])) {
    _initializeControllersAndFocusNodes();
  }

  void _initializeControllersAndFocusNodes() {
    final controllers =
        List.generate(6, (index) => TextEditingController(text: '\u200b'));
    final focusNodes = List.generate(6, (index) => FocusNode());
    state = state.copyWith(controllers: controllers, focusNodes: focusNodes);
  }

  void _handleTextChange(int index) {
    final controller = state.controllers[index];
    String text = controller.text;

    if (text.isEmpty) {
      if (index > 0) {
        state.focusNodes[index - 1].requestFocus();
      }
      controller.text = '\u200b'; // Placeholder to prevent deletion
      controller.selection = const TextSelection.collapsed(offset: 1);
    } else if (text.length > 1) {
      // Handle multiple characters
      String newText = text.replaceAll('\u200b', '').toUpperCase();
      controller.text =
          newText.substring(0, 1); // Keep only the first character
      controller.selection = const TextSelection.collapsed(offset: 1);

      // Pass extra characters to the next field
      if (index < state.controllers.length - 1) {
        final nextController = state.controllers[index + 1];
        final nextFocusNode = state.focusNodes[index + 1];

        String nextText = (nextController.text.replaceAll('\u200b', '') +
                newText.substring(1))
            .toUpperCase();

        nextController.text = nextText;
        nextFocusNode.requestFocus();
      }
    }
    _updateJoinSpaceButtonState();
  }

  void _updateJoinSpaceButtonState() {
    final enabled = state.controllers.every((controller) {
      final text = controller.text;
      return text.length == 1 && text != '\u200b';
    });
    state = state.copyWith(enabled: enabled);
  }

  Future<void> joinSpace() async {
    try {
      if (state.space == null || _currentUser == null) return;
      state = state.copyWith(verifying: true, error: null);
      await spaceService.joinSpace(state.space?.id ?? '', _currentUser.id);
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
      state = state.copyWith(
          verifying: true,
          errorInvalidInvitationCode: false,
          alreadySpaceMember: false);
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
        state = state.copyWith(
            verifying: false, alreadySpaceMember: true, error: null);
        _resetFlagsAfter30Sec();
        return '';
      }
      return spaceId;
    } catch (error, stack) {
      logger.e('JoinSpaceViewNotifier: Error while get group invitation',
          error: error, stackTrace: stack);
      state = state.copyWith(error: error, verifying: false);
      return null;
    }
  }

  void getSpace() async {
    try {
      final spaceId = await getInvitation(state.invitationCode);
      if (spaceId == null || spaceId.isEmpty) return;

      final space = await spaceService.getSpace(spaceId ?? '');
      state = state.copyWith(space: space);
    } catch (error, stack) {
      logger.e('JoinSpaceViewNotifier: Error while get space',
          error: error, stackTrace: stack);
      state = state.copyWith(error: error);
    }
  }

  void _resetFlagsAfter30Sec() {
    if (mounted) {
      Future.delayed(const Duration(seconds: 10), () {
        state = state.copyWith(
          errorInvalidInvitationCode: false,
          alreadySpaceMember: false,
        );
      });
    }
  }

  void onChange(String value, int index) {
    _handleTextChange(index);
    state.controllers[index].text =
        state.controllers[index].value.text.toUpperCase();
    _getInvitationCode();
  }

  void _getInvitationCode() {
    if (state.controllers.length == 6) {
      final inviteCode =
          state.controllers.map((controller) => controller.text.trim()).join();
      state = state.copyWith(invitationCode: inviteCode);
    }
  }

  @override
  void dispose() {
    for (var controller in state.controllers) {
      controller.dispose();
    }
    for (var focusNode in state.focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }
}

@freezed
class JoinSpaceViewState with _$JoinSpaceViewState {
  const factory JoinSpaceViewState({
    @Default(false) bool verifying,
    @Default(false) bool enabled,
    @Default(false) bool spaceJoined,
    @Default('') String invitationCode,
    @Default(false) bool errorInvalidInvitationCode,
    @Default(false) bool alreadySpaceMember,
    Object? error,
    ApiSpace? space,
    required List<TextEditingController> controllers,
    required List<FocusNode> focusNodes,
  }) = _JoinSpaceViewState;
}
