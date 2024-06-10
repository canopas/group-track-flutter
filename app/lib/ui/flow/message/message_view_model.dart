import 'package:data/api/auth/auth_models.dart';
import 'package:data/api/message/message_models.dart';
import 'package:data/api/space/space_models.dart';
import 'package:data/log/logger.dart';
import 'package:data/storage/app_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:data/service/space_service.dart';
import 'package:data/service/message_service.dart';

part 'message_view_model.freezed.dart';

final messageViewStateProvider = StateNotifierProvider.autoDispose<
    MessageViewNotifier, MessageViewState>(
      (ref) => MessageViewNotifier(
        ref.read(spaceServiceProvider),
        ref.read(messageServiceProvider),
        ref.read(currentUserPod),
  ),
);

class MessageViewNotifier extends StateNotifier<MessageViewState> {
  final SpaceService spaceService;
  final MessageService messageService;
  final ApiUser? currentUser;

  MessageViewNotifier(this.spaceService, this.messageService, this.currentUser) : super(const MessageViewState());

  void setSpace(SpaceInfo space) {
    state = state.copyWith(space: space);
  }

  void listenThreads(String spaceId) async {
    try {
      state = state.copyWith(loading: state.threadInfo.isEmpty);
      messageService.getThreadsWithLatestMessage(spaceId, currentUser!.id).listen((thread) {
        state = state.copyWith(threadInfo: thread, loading: false);
      });
    } catch (error, stack) {
      logger.e(
        'ChatViewNotifier: error while listing message thread',
        error: error,
        stackTrace: stack,
      );
      state = state.copyWith(error: error, loading: false);
    }
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

  void deleteThread(ApiThread thread) async {
    try {
      await messageService.deleteThread(thread, currentUser?.id ?? '');
      listenThreads(state.space?.space.id ?? '');
    } catch (error, stack) {
      state = state.copyWith(error: error);
      logger.e(
        'MessageViewNotifier: Error while delete thread',
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
    @Default('') String message,
    @Default([]) List<SpaceInfo> spaceList,
    @Default([]) List<ThreadInfo> threadInfo,
    Object? error,
  }) = _MessageViewState;
}
