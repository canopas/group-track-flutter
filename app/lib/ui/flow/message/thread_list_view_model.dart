import 'dart:async';

import 'package:collection/collection.dart';
import 'package:data/api/auth/api_user_service.dart';
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
    ref.read(apiUserServiceProvider),
    ref.read(currentUserPod),
  );
});

class ThreadListViewNotifier extends StateNotifier<ThreadListViewState> {
  final String spaceId;
  final SpaceService spaceService;
  final ApiMessageService messageService;
  final ApiUserService userService;
  final ApiUser? currentUser;

  StreamSubscription<List<ApiThread>>? _streamSubscription;

  ThreadListViewNotifier(this.spaceId, this.spaceService, this.messageService,
      this.userService, this.currentUser)
      : super(const ThreadListViewState());

  void setSpace(SpaceInfo space) async {
    final isNetworkOff = await _checkUserInternet();
    if (isNetworkOff) return;

    state = state.copyWith(space: space);
    listenThreads(space.space.id);
  }

  void listenThreads(String spaceId) async {
    state = state.copyWith(loading: state.threads.isEmpty);
    _streamSubscription?.cancel();
    _streamSubscription = messageService
        .getThreads(spaceId, currentUser!.id)
        .listen((threads) async {
      final filteredThreads = _filterArchivedThreads(threads);

      final memberIds = filteredThreads
          .map((e) => e.member_ids)
          .expand((element) => element)
          .toSet()
          .toList();
      final members = await _getUsers(memberIds);

      state = state.copyWith(
          threads: filteredThreads,
          users: members,
          loading: false,
          error: null);
    }, onError: (error) {
      state = state.copyWith(error: error, loading: false);
      logger.e(
        'ThreadListViewModel: Error while observing thread',
        error: error,
      );
    });
  }

  Future<Map<String, ApiUser>> _getUsers(
    List<String> memberIds,
  ) async {
    final userIds =
        memberIds.where((id) => !state.users.containsKey(id)).toSet().toList();

    final userList = await userService.getUsers(userIds);
    final users =
        userList.groupFoldBy((element) => element.id, (_, element) => element);
    state = state.copyWith(users: {...state.users, ...users});

    return {...state.users, ...users};
  }

  List<ApiThread> _filterArchivedThreads(List<ApiThread> threads) {
    final filteredThreads = threads.where((thread) {
      final archiveTimestamp = thread.archived_for?[currentUser?.id];
      if (archiveTimestamp != null) {
        final latestMessageTimestamp =
            thread.last_message_at?.millisecondsSinceEpoch ?? 0;
        return archiveTimestamp < latestMessageTimestamp;
      }
      return true;
    }).toList();

    filteredThreads.sort((a, b) {
      final aTimestamp = a.last_message_at?.millisecondsSinceEpoch ?? 0;
      final bTimestamp = b.last_message_at?.millisecondsSinceEpoch ?? 0;
      return bTimestamp.compareTo(aTimestamp);
    });
    return filteredThreads;
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

  void cleanSpaceInvitationCode() {
    state = state.copyWith(spaceInvitationCode: '');
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

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }
}

@freezed
class ThreadListViewState with _$ThreadListViewState {
  const factory ThreadListViewState({
    @Default(false) bool loading,
    @Default(false) bool fetchingInviteCode,
    @Default(false) bool deleting,
    @Default(false) bool isNetworkOff,
    SpaceInfo? space,
    @Default('') String spaceInvitationCode,
    @Default('') String message,
    @Default([]) List<ApiThread> threads,
    @Default({}) Map<String, ApiUser> users,
    Object? error,
  }) = _ThreadListViewState;
}
