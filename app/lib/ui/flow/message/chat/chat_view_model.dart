import 'package:data/api/auth/api_user_service.dart';
import 'package:data/api/auth/auth_models.dart';
import 'package:data/log/logger.dart';
import 'package:data/storage/app_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:data/service/message_service.dart';
import 'package:data/api/message/message_models.dart';
import 'package:style/extenstions/date_extenstions.dart';

part 'chat_view_model.freezed.dart';

final chatViewStateProvider =
    StateNotifierProvider.autoDispose<ChatViewNotifier, ChatViewState>(
  (ref) => ChatViewNotifier(
    ref.read(messageServiceProvider),
    ref.read(apiUserServiceProvider),
    ref.read(currentUserPod),
  ),
);

class ChatViewNotifier extends StateNotifier<ChatViewState> {
  final MessageService messageService;
  final ApiUserService userService;
  final ApiUser? currentUser;
  final Set<String> selectedUsers = {};

  ChatViewNotifier(this.messageService, this.userService, this.currentUser)
      : super(ChatViewState(message: TextEditingController()));

  void onChange(String text) {
    state = state.copyWith(allowSend: text.trim().isNotEmpty);
  }

  void setData(List<ApiUserInfo> users, ApiThread thread) {
    final userList = users.where(
          (user) => user.user.id != currentUser?.id,
    ).toList();
    state = state.copyWith(users: userList);
    getThread(thread.id);
    getThreadMembers(thread);
  }

  void getThread(String threadId) async {
    try {
      state = state.copyWith(loading: state.messages.isEmpty);
      messageService.getLatestMessages(threadId, 20).listen((messages) {
        state = state.copyWith(messages: messages, loading: false);
      });
    } catch (error, stack) {
      logger.e(
        'ChatViewNotifier: error while get thread',
        error: error,
        stackTrace: stack,
      );
    }
  }

  void getThreadMembers(ApiThread thread) async {
    try {
      state = state.copyWith(loading: true);
      messageService.getLatestMessagesUsers(thread).listen((users) {
        state = state.copyWith(sender: users, loading: false);
      });
    } catch (error, stack) {
      logger.e(
        'ChatViewNotifier: error while get thread',
        error: error,
        stackTrace: stack,
      );
    }
  }

  void sendMessage(String threadId, String message) async {
    try {
      if (state.message.text.isEmpty) return;
      state = state.copyWith(messageSending: true);
      if (threadId.isEmpty) {

      }
      final newMessage = messageService.generateMessage(threadId, currentUser?.id ?? '', state.message.text);
      final newMessages = [newMessage, ...state.messages];
      state = state.copyWith(messages: newMessages);
      await messageService.sendMessageWith(newMessage);
      state = state.copyWith(messageSending: false, message: TextEditingController(text: ''));
    } catch (error, stack) {
      logger.e(
        'ChatViewNotifier: error while sending message',
        error: error,
        stackTrace: stack,
      );
    }
  }

  ApiUser? senderInfo(String senderId) {
    state = state.copyWith(loading: state.sender.isEmpty);
    if (state.sender.isEmpty) return null ;
    final senderInfo = state.sender.firstWhere(
          (member) => member.user.id == senderId,
    ).user;
    return senderInfo;
  }

  bool isSender(ApiThreadMessage message) {
    return message.sender_id != currentUser?.id;
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
    final showDateHeader = nextDate == null || nextDate != extractDate(message.created_at!);
    return showDateHeader;
  }

  bool showTimeHeader(int index, ApiThreadMessage message) {
    final bool isLastMessage = index >= state.messages.length - 1;

    if (isLastMessage) {
      return true;
    }

    final nextMessage = state.messages[index + 1];
    final bool isDifferentTime = message.created_at!.hour != nextMessage.created_at!.hour ||
        message.created_at!.minute != nextMessage.created_at!.minute;
    final bool isDifferentSender = message.sender_id != nextMessage.sender_id;

    return isDifferentTime || isDifferentSender;
  }
}

@freezed
class ChatViewState with _$ChatViewState {
  const factory ChatViewState({
    @Default(false) bool loading,
    @Default(false) bool messageSending,
    @Default(false) bool allowSend,
    @Default([]) List<ApiUserInfo> users,
    required TextEditingController message,
    @Default([]) List<ApiThreadMessage> messages,
    @Default([]) List<ApiUserInfo> sender,
    Object? error,
  }) = _ChatViewState;
}
