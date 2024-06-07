import 'package:data/api/space/space_models.dart';
import 'package:data/log/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:data/service/space_service.dart';

part 'message_view_model.freezed.dart';

final messageViewStateProvider = StateNotifierProvider.autoDispose<
    MessageViewNotifier, MessageViewState>(
      (ref) => MessageViewNotifier(
    ref.read(spaceServiceProvider),
  ),
);

class MessageViewNotifier extends StateNotifier<MessageViewState> {
  final SpaceService spaceService;

  MessageViewNotifier(this.spaceService) : super(const MessageViewState());

  void setSpace(SpaceInfo space) {
    state = state.copyWith(space: space);
  }

  void onAddNewMemberTap() async {
    try {
      state = state.copyWith(fetchingInviteCode: true);
      final code = await spaceService.getInviteCode(state.space?.space.id ?? '');
      state = state.copyWith(spaceInvitationCode: code ?? '', fetchingInviteCode: false);
    } catch (error, stack) {
      state = state.copyWith(error: error);
      logger.e(
        'MessageViewNotifier: Error while getting invitation code',
        error: error,
        stackTrace: stack,
      );
    }
  }
}

@freezed
class MessageViewState with _$MessageViewState {
  const factory MessageViewState({
    @Default(false) bool allowSave,
    @Default(false) bool isCreating,
    @Default(false) bool loading,
    @Default(false) bool fetchingInviteCode,
    SpaceInfo? space,
    @Default('') String spaceInvitationCode,
    @Default([]) List<SpaceInfo> spaceList,
    Object? error,
  }) = _MessageViewState;
}
