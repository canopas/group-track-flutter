import 'dart:async';

import 'package:data/api/auth/auth_models.dart';
import 'package:data/api/message/api_message_service.dart';
import 'package:data/api/message/message_models.dart';
import 'package:data/api/space/space_models.dart';
import 'package:data/log/logger.dart';
import 'package:data/service/space_service.dart';
import 'package:data/storage/app_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../components/no_internet_screen.dart';

part 'thread_list_view_model.freezed.dart';

final threadListViewStateProvider = StateNotifierProvider.family<
    ThreadListViewNotifier, ThreadListViewState, String>((ref, spaceId) {
  return ThreadListViewNotifier(
    spaceId,
    ref.read(spaceServiceProvider),
    ref.read(apiMessageServiceProvider),
    ref.read(currentUserPod),
  );
});

class ThreadListViewNotifier extends StateNotifier<ThreadListViewState> {
  final String spaceId;
  final SpaceService spaceService;
  final ApiMessageService messageService;
  final ApiUser? currentUser;

  ThreadListViewNotifier(
      this.spaceId, this.spaceService, this.messageService, this.currentUser)
      : super(const ThreadListViewState());

  void setSpace(SpaceInfo space) async {
    final isNetworkOff = await _checkUserInternet();
    if (isNetworkOff) return;

    state = state.copyWith(space: space);
    listenThreads(space.space.id);
  }

  void listenThreads(String spaceId) async {
    try {
      state = state.copyWith(loading: state.threadInfo.isEmpty);
      messageService
          .getThreadsWithMembers(spaceId, currentUser!.id)
          .listen((threads) {
        final filteredThreads = _filterArchivedThreads(threads);

        filteredThreads.sort((a, b) {
          final aTimestamp = a.threadMessage.isNotEmpty
              ? a.threadMessage.first.created_at?.millisecondsSinceEpoch ?? 0
              : 0;
          final bTimestamp = b.threadMessage.isNotEmpty
              ? b.threadMessage.first.created_at?.millisecondsSinceEpoch ?? 0
              : 0;
          return bTimestamp.compareTo(aTimestamp);
        });

        state = state.copyWith(
            threadInfo: filteredThreads, loading: false, error: null);
        getMessage();
      });
    } catch (error, stack) {
      logger.e('ChatViewNotifier: error while listing message threads',
          error: error, stackTrace: stack);
      state = state.copyWith(error: error, loading: false);
    }
  }

  void getMessage() async {
    try {
      final List<List<ApiThreadMessage>> newThreadMessages =
          List.generate(state.threadInfo.length, (_) => []);

      for (int i = 0; i < state.threadInfo.length; i++) {
        final threads = state.threadInfo[i];
        final threadMessages =
            await messageService.getMessages(threads.thread.id, DateTime.now());
        newThreadMessages[i] = threadMessages;
      }
      state = state.copyWith(threadMessages: List.from(newThreadMessages));
    } catch (error, stack) {
      logger.e('ChatViewNotifier: error while listening to latest messages',
          error: error, stackTrace: stack);
    }
  }

  List<ThreadInfo> _filterArchivedThreads(List<ThreadInfo> threads) {
    return threads.where((info) {
      final archiveTimestamp = info.thread.archived_for?[currentUser?.id];
      if (archiveTimestamp != null) {
        final latestMessageTimestamp = info.threadMessage.isNotEmpty
            ? info.threadMessage.first.created_at?.millisecondsSinceEpoch ?? 0
            : 0;
        return archiveTimestamp < latestMessageTimestamp;
      }
      return true;
    }).toList();
  }

  void onAddNewMemberTap() async {
    try {
      state = state.copyWith(fetchingInviteCode: true);
      final code =
          await spaceService.getInviteCode(state.space?.space.id ?? '');
      state = state.copyWith(
          spaceInvitationCode: code ?? '',
          fetchingInviteCode: false,
          error: null);
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
      state = state.copyWith(deleting: true);
      await messageService.deleteThread(thread, currentUser?.id ?? '');
      state = state.copyWith(deleting: false, error: null);
    } catch (error, stack) {
      state = state.copyWith(error: error);
      logger.e(
        'MessageViewNotifier: Error while delete thread',
        error: error,
        stackTrace: stack,
      );
    }
  }

  Future<bool> _checkUserInternet() async {
    final isNetworkOff = await checkInternetConnectivity();
    state = state.copyWith(isNetworkOff: isNetworkOff);
    return isNetworkOff;
  }
}

@freezed
class ThreadListViewState with _$ThreadListViewState {
  const factory ThreadListViewState({
    @Default(false) bool allowSave,
    @Default(false) bool isCreating,
    @Default(false) bool loading,
    @Default(false) bool fetchingInviteCode,
    @Default(false) bool deleting,
    @Default(false) bool isNetworkOff,
    SpaceInfo? space,
    @Default('') String spaceInvitationCode,
    @Default('') String message,
    @Default([]) List<SpaceInfo> spaceList,
    @Default([]) List<ThreadInfo> threadInfo,
    @Default([]) List<List<ApiThreadMessage>> threadMessages,
    Object? error,
  }) = _ThreadListViewState;
}
