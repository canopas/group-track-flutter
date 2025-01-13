import 'package:data/api/auth/auth_models.dart';
import 'package:data/api/space/api_space_invitation_service.dart';
import 'package:data/api/space/space_models.dart';
import 'package:data/log/logger.dart';
import 'package:data/service/place_service.dart';
import 'package:data/service/space_service.dart';
import 'package:data/storage/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yourspace_flutter/ui/components/no_internet_screen.dart';

part 'edit_space_view_model.freezed.dart';

final editSpaceViewStateProvider = StateNotifierProvider.autoDispose<
    EditSpaceViewNotifier, EditSpaceViewState>(
  (ref) => EditSpaceViewNotifier(
    ref.read(spaceServiceProvider),
    ref.read(apiSpaceInvitationServiceProvider),
    ref.read(currentUserPod),
    ref.read(placeServiceProvider),
  ),
);

class EditSpaceViewNotifier extends StateNotifier<EditSpaceViewState> {
  final SpaceService spaceService;
  final ApiSpaceInvitationService spaceInvitationService;
  final ApiUser? user;
  final PlaceService placeService;

  EditSpaceViewNotifier(this.spaceService, this.spaceInvitationService,
      this.user, this.placeService)
      : super(EditSpaceViewState(spaceName: TextEditingController()));

  void getSpaceDetails(String spaceId) async {
    final isNetworkOff = await _checkUserInternet();
    if (isNetworkOff) return;

    try {
      state = state.copyWith(loading: state.spaceInfo == null, error: null,);
      final space = await spaceService.getSpaceInfo(spaceId);
      final currentUserInfo = space?.members.firstWhere(
        (member) => member.user.id == user?.id,
      );
      final otherMembers = space?.members
          .where(
            (member) => member.user.id != user?.id,
          )
          .toList();

      state = state.copyWith(
        spaceInfo: space,
        currentUserInfo: currentUserInfo,
        userInfo: otherMembers ?? [],
        isAdmin: space?.space.admin_id == user?.id,
        locationEnabled: currentUserInfo?.isLocationEnabled ?? false,
        spaceName: TextEditingController(text: space?.space.name),
        loading: false,
      );
      if (state.spaceInfo != null && state.invitationCode == null) {
        _getInvitationCode();
      }
    } catch (error, stack) {
      logger.e('EditSpaceViewNotifier: error while fetch space details',
          error: error, stackTrace: stack);
      state = state.copyWith(error: error, loading: false);
    }
  }

  void updateSpace() async {
    try {
      state = state.copyWith(saving: true);
      if (state.spaceName.text.trim() != state.spaceInfo?.space.name) {
        await spaceService.updateSpace(
            state.spaceInfo!.space.copyWith(name: state.spaceName.text.trim()));
      }
      if (state.currentUserInfo!.isLocationEnabled != state.locationEnabled) {
        await spaceService.enableLocation(state.spaceInfo!.space.id,
            state.currentUserInfo!.user.id, state.locationEnabled);
      }
      state = state.copyWith(saving: false, allowSave: false, error: null);
    } catch (error, stack) {
      logger.e('EditSpaceViewNotifier: error while update space info',
          error: error, stackTrace: stack);
      state = state.copyWith(error: error, saving: false);
    }
  }

  void leaveSpace({String? userId}) async {
    try {
      final memberId = userId ?? user?.id;
      if (memberId == null) return;
      state = state.copyWith(deleting: true, error: null);
      final needToChangeAdmin =
          state.isAdmin && user?.id == memberId && state.userInfo.isNotEmpty;
      if (needToChangeAdmin) {
        await spaceService.updateSpace(
          state.spaceInfo!.space
              .copyWith(admin_id: state.userInfo.first.user.id),
        );
      }
      await spaceService.leaveSpace(state.spaceInfo!.space.id, memberId);
      state = state.copyWith(
          deleting: false, deleted: state.isAdmin ? false : true);
      if (state.spaceInfo?.space.admin_id == user?.id) {
        getSpaceDetails(state.spaceInfo!.space.id);
      }
    } catch (error, stack) {
      logger.e(
        'EditSpaceViewNotifier: error while leave space',
        error: error,
        stackTrace: stack,
      );
      state = state.copyWith(error: error, deleting: false);
    }
  }

  void deleteSpace() async {
    try {
      state = state.copyWith(deleting: true, error: null);
      await spaceService.deleteSpace(state.spaceInfo!.space.id);
      state = state.copyWith(deleting: false, deleted: true);
    } catch (error, stack) {
      logger.e(
        'EditSpaceViewNotifier: error while delete space',
        error: error,
        stackTrace: stack,
      );
      state = state.copyWith(error: error, deleted: false);
    }
  }

  void onChange(String text) {
    final validSpaceName = state.spaceName.text.trim().length >= 3;
    final changed = state.spaceName.text.trim() != state.spaceInfo?.space.name;
    state = state.copyWith(allowSave: validSpaceName && changed);
  }

  void toggleLocationSharing(bool isEnabled) {
    state = state.copyWith(
        locationEnabled: isEnabled,
        allowSave: state.currentUserInfo!.isLocationEnabled != isEnabled);
  }

  Future<bool> _checkUserInternet() async {
    final isNetworkOff = await checkInternetConnectivity();
    state = state.copyWith(isNetworkOff: isNetworkOff);
    return isNetworkOff;
  }

  void isAdminRemovingMember(bool removeMember) {
    state = state.copyWith(adminRemovingMember: removeMember);
  }

  Future<void> _getInvitationCode() async {
    try {
      if (state.spaceInfo == null) return;
      final code = await spaceInvitationService
          .getSpaceInviteCode(state.spaceInfo!.space.id);
      state = state.copyWith(invitationCode: code);
    } catch (error, stack) {
      logger.e('EditSpaceViewNotifier: error while get invitation code',
          error: error, stackTrace: stack);
    }
  }

  Future<void> regenerateInvitationCode() async {
    try {
      final space = state.spaceInfo?.space;
      if (space == null) return;

      state = state.copyWith(refreshingInviteCode: true, error: null);
      final invitationCode =
          await spaceInvitationService.regenerateInvitationCode(space.id);
      state = state.copyWith(
          invitationCode: invitationCode, refreshingInviteCode: false);
    } catch (error, stack) {
      state = state.copyWith(refreshingInviteCode: false, error: error);
      logger.e('EditSpaceViewNotifier: error while regenerate group code',
          error: error, stackTrace: stack);
    }
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
    @Default(false) bool locationEnabled,
    @Default(false) bool isNetworkOff,
    @Default(false) bool adminRemovingMember,
    @Default('') String selectedSpaceName,
    @Default('') String currentUserId,
    ApiUserInfo? currentUserInfo,
    @Default([]) List<ApiUserInfo> userInfo,
    required TextEditingController spaceName,
    SpaceInfo? spaceInfo,
    ApiSpaceInvitation? invitationCode,
    @Default(false) bool refreshingInviteCode,
    Object? error,
  }) = _EditSpaceViewState;
}
