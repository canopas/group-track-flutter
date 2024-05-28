import 'package:data/api/auth/api_user_service.dart';
import 'package:data/api/space/api_space_invitation_service.dart';
import 'package:data/api/space/api_space_service.dart';
import 'package:data/api/space/space_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/auth/auth_models.dart';
import '../storage/app_preferences.dart';

final spaceServiceProvider = Provider((ref) => SpaceService(
  ref.read(currentUserPod),
  ref.read(apiSpaceServiceProvider),
  ref.read(apiSpaceInvitationServiceProvider),
  ref.read(currentUserSessionJsonPod.notifier),
  ref.read(apiUserServiceProvider),
));

class SpaceService {
  final ApiUser? currentUser;
  final ApiSpaceService spaceService;
  final ApiSpaceInvitationService spaceInvitationService;
  final StateController<String?> _currentSpaceIdController;
  final ApiUserService userService;

  SpaceService(
    this.currentUser,
    this.spaceService,
    this.spaceInvitationService,
    this._currentSpaceIdController,
    this.userService,
  );

  String? get currentSpaceId => _currentSpaceIdController.state;

  set currentSpaceId(String? value) {
    _currentSpaceIdController.state = value;
  }

  Future<String> createSpaceAndGetInviteCode(String spaceName) async {
    final spaceId = await spaceService.createSpace(spaceName);
    final generatedCode =
        await spaceInvitationService.createInvitation(spaceId);
    currentSpaceId = spaceId;
    return generatedCode;
  }

  Future<void> joinSpace(String spaceId) async {
    await spaceService.joinSpace(spaceId);
    currentSpaceId = spaceId;
  }

  Future<List<SpaceInfo>> getAllSpaceInfo() async {
    final userId = currentUser?.id ?? '';
    final spaces = await getUserSpaces(userId);
    if (spaces.isEmpty) return [];
    final flows = spaces.map((space) async {
      final members = await spaceService.getMembersBySpaceId(space!.id);
      return SpaceInfo(
        space: space,
        members: members
            .map((member) async {
          final user = await userService.getUser(member.user_id);
          return user != null
              ? ApiUserInfo(user: user, isLocationEnabled: member.location_enabled)
              : null;
        })
            .whereType<ApiUserInfo>()
            .toList(),
      );
    });
    final spaceInfo = await Future.wait(flows);
    return spaceInfo.toList();
  }

  Future<SpaceInfo?> getCurrentSpaceInfo() async {
    final currentSpace = await getCurrentSpace();
    if (currentSpace == null) return null;
    final members = await spaceService.getMembersBySpaceId(currentSpace.id);
    return SpaceInfo(
      space: currentSpace,
      members: members
          .map((member) async {
            final user = await userService.getUser(member.user_id);
            return user != null
                ? ApiUserInfo(user: user, isLocationEnabled: member.location_enabled)
                : null;
          })
            .whereType<ApiUserInfo>()
            .toList(),
    );
  }

  Future<SpaceInfo?> getSpaceInfo(String spaceId) async {
    final space = await getSpace(spaceId);
    if (space == null) return null;
    final members = await spaceService.getMembersBySpaceId(space.id);
    return SpaceInfo(
      space: space,
      members: members.map((member) async {
        final user = await userService.getUser(member.user_id);
        return user != null ? ApiUserInfo(user: user, isLocationEnabled: member.location_enabled) : null;
      }).whereType<ApiUserInfo>().toList(),
    );
  }

  Future<ApiSpace?> getCurrentSpace() async {
    final spaceId = currentSpaceId;
    if (spaceId!.isEmpty) {
      final userId = currentUser?.id ?? '';
      final userSpaces = await getUserSpaces(userId);
      return userSpaces.firstOrNull;
    }
    return getSpace(spaceId);
  }

  Future<List<ApiSpace?>> getUserSpaces(String userId) async {
    final spaceMembers = await spaceService.getSpaceMemberByUserId(userId);
    final spaceIds = spaceMembers.map((member) => member.space_id).toSet();
    final spaceList =
        await Future.wait(spaceIds.map((spaceId) => getSpace(spaceId)));
    return spaceList.toList();
  }

  Future<ApiSpace?> getSpace(String spaceId) async {
    return spaceService.getSpace(spaceId);
  }

  Future<Future<List<ApiSpaceMember>>> getMemberBySpaceId(
      String spaceId) async {
    return spaceService.getMembersBySpaceId(spaceId);
  }

  Future<String?> getInviteCode(String spaceId) async {
    final code = await spaceInvitationService.getSpaceInviteCode(spaceId);
    if (code?.isExpired ?? false) {
      return spaceInvitationService.regenerateInvitationCode(spaceId);
    }
    return code?.code;
  }

  Future<void> enableLocation(
      String spaceId, String userId, bool locationEnabled) async {
    await spaceService.enableLocation(spaceId, userId, locationEnabled);
  }

  Future<void> deleteUserSpaces() async {
    final userId = currentUser?.id ?? '';
    final allSpace = await getUserSpaces(userId);
    final ownSpace = allSpace.where((space) => space?.admin_id == userId).toList();
    final joinedSpace = allSpace.where((space) => space?.admin_id != userId).toList();

    for (final space in ownSpace) {
      await deleteSpace(space!.id);
    }

    for (final space in joinedSpace) {
      await spaceService.removeUserFromSpace(space!.id, userId);
    }
  }

  Future<void> deleteSpace(String spaceId) async {
    await spaceInvitationService.deleteInvitations(spaceId);
    await spaceService.deleteSpace(spaceId);
    final userId = currentUser?.id ?? '';
    final userSpaces = await getUserSpaces(userId);
    userSpaces.sort((a, b) => (a?.created_at ?? 0).compareTo(b?.created_at ?? 0));
    final currentSpaceId = userSpaces.isNotEmpty ? userSpaces.firstOrNull?.id ?? '' : '';
    this.currentSpaceId = currentSpaceId;
  }

  Future<void> leaveSpace(String spaceId) async {
    final userId = currentUser?.id ?? '';
    await spaceService.removeUserFromSpace(spaceId, userId);
    final userSpaces = await getUserSpaces(userId);
    userSpaces.sort((a, b) => (a?.created_at ?? 0).compareTo(b?.created_at ?? 0));
    final currentSpaceId = userSpaces.isNotEmpty ? userSpaces.firstOrNull?.id ?? '' : '';
    this.currentSpaceId = currentSpaceId;
  }

  Future<void> updateSpace(ApiSpace newSpace) async {
    await spaceService.updateSpace(newSpace);
  }
}
