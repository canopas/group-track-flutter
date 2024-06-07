import 'package:data/api/auth/auth_models.dart';
import 'package:data/storage/app_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:data/service/space_service.dart';

part 'chat_view_model.freezed.dart';

final chatViewStateProvider =
    StateNotifierProvider.autoDispose<ChatViewNotifier, ChatViewState>(
  (ref) => ChatViewNotifier(
    ref.read(spaceServiceProvider),
    ref.read(currentUserPod),
  ),
);

class ChatViewNotifier extends StateNotifier<ChatViewState> {
  final SpaceService spaceService;
  final ApiUser? currentUser;

  ChatViewNotifier(this.spaceService, this.currentUser)
      : super(const ChatViewState());

  void setData(List<ApiUserInfo> users) {
    final userList = users.where(
          (user) => user.user.id != currentUser?.id,
    ).toList();
    state = state.copyWith(users: userList);
  }
}

@freezed
class ChatViewState with _$ChatViewState {
  const factory ChatViewState({
    @Default(false) bool loading,
    @Default(false) bool isCurrentUser,
    @Default([]) List<ApiUserInfo> users,
    Object? error,
  }) = _ChatViewState;
}
