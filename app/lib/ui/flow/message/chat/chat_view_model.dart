import 'dart:async';

import 'package:collection/collection.dart';
import 'package:data/api/auth/api_user_service.dart';
import 'package:data/api/auth/auth_models.dart';
import 'package:data/api/message/api_message_service.dart';
import 'package:data/api/message/message_models.dart';
import 'package:data/api/space/space_models.dart';
import 'package:data/log/logger.dart';
import 'package:data/service/message_service.dart';
import 'package:data/service/space_service.dart';
import 'package:data/storage/app_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:style/extenstions/date_extenstions.dart';

part 'chat_view_model.freezed.dart';

const MAX_PAGE_LIMIT = 20;

final chatViewStateProvider =
    StateNotifierProvider.autoDispose<ChatViewNotifier, ChatViewState>((ref) {
  return ChatViewNotifier(
    ref.read(messageServiceProvider),
    ref.read(apiMessageServiceProvider),
    ref.read(apiUserServiceProvider),
    ref.read(spaceServiceProvider),
    ref.read(currentUserPod),
  );
});

class ChatViewNotifier extends StateNotifier<ChatViewState> {
  final MessageService messageService;
  final ApiMessageService apiMessageService;
  final ApiUserService userService;
  final SpaceService spaceService;
  final ApiUser? currentUser;

  bool _hasMoreItems = true;

  StreamSubscription<List<ApiThreadMessage>>? _messageSubscription;

  ChatViewNotifier(this.messageService, this.apiMessageService,
      this.userService, this.spaceService, this.currentUser)
      : super(ChatViewState(
            message: TextEditingController(), currentUser: currentUser));

  void init({
    ApiSpace? space,
    ApiThread? thread,
    String? threadId,
    required List<ApiThread> threads,
  }) async {
    state = state.copyWith(
        showMemberSelectionView: threadId?.isEmpty ?? true,
        space: space,
        thread: thread,
        threadId: threadId,
        threads: threads);

    fetch();
  }

  void fetch() async {
    try {
      _messageSubscription?.cancel();

      state = state.copyWith(loading: true, error: null);
      final spaceId = state.space?.id ?? '';
      final space = state.space ??
          (spaceId.isNotEmpty ? await spaceService.getSpace(spaceId) : null);

      final thread = state.thread ??
          (state.threadId?.isNotEmpty ?? false
              ? await messageService.getThread(state.threadId!)
              : null);

      final members = (spaceId.isNotEmpty && thread == null
          ? await spaceService.getMemberBySpaceId(spaceId)
          : null);

      final membersIds = thread != null
          ? thread.member_ids.toList()
          : members?.map((e) => e.user_id).toList() ?? [];

      membersIds.removeWhere((e) => e == state.currentUser?.id);

      final users = await _getUsers(membersIds);

      state = state.copyWith(
        space: space,
        thread: thread,
        threadId: thread?.id,
        members: users,
        loading: false,
      );

      if (thread != null) {
        _listenMessages(thread.id);
      }
    } catch (error, stack) {
      state = state.copyWith(error: error, loading: false);
      logger.e(
        "ChatViewNotifier: error while fetching data",
        error: error,
        stackTrace: stack,
      );
    }
  }

  Future<Map<String, ApiUser>> _getUsers(
    List<String> memberIds,
  ) async {
    if (memberIds.isEmpty) return {...state.members};

    final userIds = memberIds
        .where((id) => !state.members.containsKey(id))
        .toSet()
        .toList();

    final userList = await userService.getUsers(userIds);
    final users =
        userList.groupFoldBy((element) => element.id, (_, element) => element);

    return {...state.members, ...users};
  }

  void _listenMessages(String threadId) async {
    try {
      if (threadId.isEmpty) return;

      _messageSubscription?.cancel();
      _messageSubscription = messageService
          .getLatestMessages(threadId, limit: 20)
          .listen((messages) {
        state = state.copyWith(messages: messages);
        markMessageAsSeen(threadId);
      }, onError: _onError);
    } catch (error, stack) {
      _onError(error, stack);
    }
  }

  void _onError(Object error, StackTrace stackTrace) {
    state = state.copyWith(actionError: error);
    logger.e(
      'ChatViewNotifier: error while listening messages',
      error: error,
      stackTrace: stackTrace,
    );
  }

  void markMessageAsSeen(String threadId) async {
    try {
      var thread = state.thread;
      if (thread?.seen_by_ids.contains(currentUser?.id) ?? false) return;
      await messageService.addThreadSeenBy(threadId, currentUser?.id ?? '');
      print("XXX markMessageAsSeen $threadId");
    } catch (error, stack) {
      logger.e(
        'ChatViewNotifier: error while message mark as read',
        error: error,
        stackTrace: stack,
      );
    }
  }

  void _sendMessage(String threadId, String message) async {
    try {
      if (message.isEmpty || currentUser == null) return;
      state = state.copyWith(messageSending: true, actionError: null);
      final newMessage = await messageService.generateMessage(
          threadId: threadId,
          senderId: currentUser?.id ?? '',
          message: message);
      final newMessages = [newMessage, ...state.messages];
      state = state.copyWith(messages: newMessages);
      await messageService.sendMessage(newMessage);
      state = state.copyWith(
        messageSending: false,
        message: TextEditingController(text: ''),
        showMemberSelectionView: false,
        actionError: null,
      );
    } catch (error, stack) {
      state = state.copyWith(messageSending: false, actionError: error);
      logger.e(
        'ChatViewNotifier: error while sending message',
        error: error,
        stackTrace: stack,
      );
    }
  }

  void onMessageChange() {
    state = state.copyWith(
        allowSend: state.message.text.isNotEmpty && state.space != null);
  }

  void sendMessage() {
    if (state.thread != null) {
      _sendMessage(state.thread!.id, state.message.text);
    } else {
      _createNewThread(state.message.text);
    }
  }

  void _createNewThread(String message) async {
    try {
      state = state.copyWith(creating: true, actionError: null);
      _messageSubscription?.cancel();
      final selectedMembers = state.selectedMember;
      final threadMembers = selectedMembers.isNotEmpty
          ? selectedMembers.toList()
          : state.members.keys.toList();
      if (threadMembers.isNotEmpty) {
        threadMembers.add(currentUser?.id ?? '');
      }

      final threadId = await messageService.createThread(
          state.space!.id, currentUser?.id ?? '', threadMembers);

      state = state.copyWith(
          showMemberSelectionView: false,
          threadId: threadId,
          members: {},
          creating: false,
          isNewThread: true);

      if (threadId.isNotEmpty) {
        _sendMessage(threadId, message);
        fetch();
      }
    } catch (error, stack) {
      state = state.copyWith(creating: false, actionError: error);
      logger.e(
        'ChatViewNotifier: error while create new thread',
        error: error,
        stackTrace: stack,
      );
    }
  }

  void _selectExistingThread() {
    final userList = state.members.values.toList().map((e) => e.id).toList();
    final List<String> selectedMembers = List.from(
        state.selectedMember.isEmpty ? userList : state.selectedMember);
    selectedMembers.add(currentUser?.id ?? '');

    final List<List<String>> threadMembers =
        state.threads.map((threads) => threads.member_ids.toList()).toList();

    bool hasMatchingThread = threadMembers.any((threadMember) =>
        _listsContainSameMembers(selectedMembers, threadMember));

    if (hasMatchingThread) {
      final matchingThreads = state.threads.where((thread) {
        final List<String> threadMemberIds = thread.member_ids.toList();
        return _listsContainSameMembers(selectedMembers, threadMemberIds);
      }).toList();

      if (matchingThreads.isNotEmpty) {
        ApiThread matchedThread = matchingThreads.first;
        state = state.copyWith(
          threadId: matchedThread.id,
          thread: matchedThread,
        );
        fetch();
      }
    } else {
      _messageSubscription?.cancel();
      state = state.copyWith(
        messages: [],
        isNewThread: true,
        threadId: '',
        thread: null,
      );
    }
  }

  bool _listsContainSameMembers(List<String> list1, List<String> list2) {
    if (list1.length != list2.length) return false;
    final set1 = Set<String>.from(list1);
    final set2 = Set<String>.from(list2);
    return set1.containsAll(set2) && set2.containsAll(set1);
  }

  void onLoadMore() {
    if (!_hasMoreItems || state.loadingMoreMessages || state.thread == null) {
      return;
    }
    _loadMoreMessages();
  }

  void _loadMoreMessages() async {
    try {
      if (state.loadingMoreMessages || state.thread == null) return;

      final threadId = state.thread!.id;
      state = state.copyWith(loadingMoreMessages: true, actionError: null);

      final minMessage = state.messages
          .reduce((a, b) => a.createdAtMs < b.createdAtMs ? a : b);

      final newMessages = await messageService
          .getMessages(threadId, minMessage.created_at, limit: MAX_PAGE_LIMIT);

      _hasMoreItems = newMessages.length == MAX_PAGE_LIMIT;

      final messages = [...state.messages, ...newMessages];

      state = state.copyWith(messages: messages, loadingMoreMessages: false);
    } catch (error, stack) {
      state = state.copyWith(loadingMoreMessages: false, actionError: error);

      logger.e(
        'ChatViewNotifier: error while load more chats',
        error: error,
        stackTrace: stack,
      );
    }
  }

  bool isFirstInGroupAtIndex(int index) {
    if (index == 0) {
      return true;
    } else {
      final message = state.messages[index];
      final previousMessage = state.messages[index - 1];
      return previousMessage.created_at!.hour != message.created_at!.hour ||
          previousMessage.created_at!.minute != message.created_at!.minute ||
          previousMessage.sender_id != message.sender_id;
    }
  }

  bool isLastInGroupAtIndex(int index) {
    if (index == state.messages.length - 1) {
      return true;
    } else {
      final message = state.messages[index];
      final nextMessage = state.messages[index + 1];
      return nextMessage.created_at!.hour != message.created_at!.hour ||
          nextMessage.created_at!.minute != message.created_at!.minute ||
          nextMessage.sender_id != message.sender_id;
    }
  }

  bool showDateHeader(int index, ApiThreadMessage message) {
    final DateTime? nextDate = index < state.messages.length - 1
        ? extractDate(state.messages[index + 1].created_at!.toLocal())
        : null;
    final showDateHeader =
        nextDate == null || nextDate != extractDate(message.created_at!);
    return showDateHeader;
  }

  bool showTimeHeader(int index, ApiThreadMessage message) {
    final bool isLastMessage = index >= state.messages.length - 1;

    if (isLastMessage) {
      return true;
    }

    final nextMessage = state.messages[index + 1];
    final bool isDifferentTime =
        message.created_at!.hour != nextMessage.created_at!.hour ||
            message.created_at!.minute != nextMessage.created_at!.minute;
    final bool isDifferentSender = message.sender_id != nextMessage.sender_id;

    return isDifferentTime || isDifferentSender;
  }

  void toggleMemberSelection(String? memberId) {
    if (memberId == null) return;
    final List<String> selectedMembers = [...state.selectedMember];

    if (selectedMembers.contains(memberId)) {
      selectedMembers.remove(memberId);
    } else {
      selectedMembers.add(memberId);
    }

    state = state.copyWith(selectedMember: selectedMembers);
    _selectExistingThread();
  }

  void clearSelection() {
    state = state.copyWith(selectedMember: []);
    _selectExistingThread();
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    super.dispose();
  }
}

@freezed
class ChatViewState with _$ChatViewState {
  const factory ChatViewState({
    @Default(false) bool loading,
    @Default(false) bool creating,
    @Default(false) bool loadingMoreMessages,
    @Default(false) bool messageSending,
    @Default(false) bool allowSend,
    @Default(false) bool showMemberSelectionView,
    @Default(false) bool isNewThread,
    @Default(false) bool isNetworkOff,
    String? threadId,
    required TextEditingController message,
    @Default([]) List<ApiThreadMessage> messages,
    @Default([]) List<String> selectedMember,
    Object? error,
    Object? actionError,
    ApiSpace? space,
    ApiThread? thread,
    @Default({}) Map<String, ApiUser> members,
    ApiUser? currentUser,
    @Default([]) List<ApiThread> threads,
  }) = _ChatViewState;
}
