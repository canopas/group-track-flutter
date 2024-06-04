import 'package:data/api/auth/auth_models.dart';
import 'package:data/api/space/space_models.dart';
import 'package:data/log/logger.dart';
import 'package:data/storage/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:data/service/space_service.dart';

part 'edit_space_view_model.freezed.dart';

final editSpaceViewStateProvider =
StateNotifierProvider.autoDispose<EditSpaceViewNotifier, EditSpaceViewState>(
      (ref) => EditSpaceViewNotifier(
    ref.read(spaceServiceProvider),
        ref.read(currentUserPod),
  ),
);

class EditSpaceViewNotifier extends StateNotifier<EditSpaceViewState> {
  final SpaceService spaceService;
  final ApiUser? user;

  EditSpaceViewNotifier(this.spaceService, this.user)
      : super(EditSpaceViewState(spaceName: TextEditingController()));

  void getSpaceDetails(String spaceId) async {
    try {
      state = state.copyWith(loading: true);
      final space = await spaceService.getSpaceInfo(spaceId);
      final currentUserInfo = space?.members.firstWhere(
            (member) => member.user.id == user?.id,
      );
      final otherMembers = space?.members.where(
            (member) => member.user.id != user?.id,
      ).toList();

      state = state.copyWith(
          space: space,
          currentUserInfo: currentUserInfo,
          loading: false,
          userInfo: otherMembers ?? [],
          isAdmin: space?.space.admin_id == user?.id,
          spaceName: TextEditingController(text: space?.space.name,
          ),
      );
    } catch (error, stack) {
      logger.e(
        'EditSpaceViewNotifier: error while fetch space details',
        error: error,
        stackTrace: stack
      );
    }
  }

  void updateSpace() async {
    try {
      state = state.copyWith(saving: true);
      await spaceService.updateSpace(state.space!.space.copyWith(name: state.spaceName.text.trim()));
      state = state.copyWith(saving: false);
    } catch (error, stack) {
      logger.e(
        'EditSpaceViewNotifier: error while update space info',
        error: error,
        stackTrace: stack
      );
    }
  }

  void leaveSpace() async {
    try {
      state = state.copyWith(deleting: true);
      await spaceService.leaveSpace(state.space!.space.id);
      state = state.copyWith(deleting: false, deleted: true);
    } catch (error, stack) {
      logger.e(
        'EditSpaceViewNotifier: error while leave space',
        error: error,
        stackTrace: stack,
      );
    }
  }

  void deleteSpace() async {
    try {
      state = state.copyWith(deleting: true);
      await spaceService.deleteSpace(state.space!.space.id);
      state = state.copyWith(deleting: false, deleted: true);
    } catch (error, stack) {
      logger.e(
        'EditSpaceViewNotifier: error while delete space',
        error: error,
        stackTrace: stack,
      );
    }
  }

  void onChange(String text) {
    final validSpaceName = state.spaceName.text.trim().length >= 3;
    final changed = state.spaceName.text.trim() != state.space?.space.name;
    state = state.copyWith(allowSave: validSpaceName && changed);
  }
}

@freezed
class EditSpaceViewState with _$EditSpaceViewState {
  const factory EditSpaceViewState({
    @Default(false) bool loading,
    @Default(false) bool allowSave,
    @Default(false) bool saving,
    @Default(false) bool isAdmin,
    @Default(false) bool deleting,
    @Default(false) bool deleted,
    @Default('') String selectedSpaceName,
    @Default('') String currentUserId,
    ApiUserInfo? currentUserInfo,
    @Default([]) List<ApiUserInfo> userInfo,
    required TextEditingController spaceName,
    SpaceInfo? space,
  }) = _EditSpaceViewState;
}
