import 'dart:async';

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

  Stream<List<SpaceInfo>> getAllSpaceInfo() {
    final userId = currentUser?.id ?? '';
    return userSpacesStream(userId).asyncMap((List<ApiSpace> spaces) async {
      var spaceInfo = await Future.wait(spaces.map((space) async {
        List<ApiSpaceMember> members =
        await spaceService.getMembersBySpaceId(space.id);
        var userInfo = await Future.wait(members.map((member) async {
          var user = await userService.getUser(member.user_id);
          return user == null
              ? null
              : ApiUserInfo(user: user, isLocationEnabled: member.location_enabled);
        }).toList());

        userInfo.removeWhere((userInfo) => userInfo == null);
        List<ApiUserInfo> validUserInfo = userInfo.cast<ApiUserInfo>();
        return SpaceInfo(space: space, members: validUserInfo);
      }).toList());
      return spaceInfo;
    });
  }

  Stream<SpaceInfo?> streamCurrentSpaceInfo() async* {
    final currentSpaceStream = getCurrentSpace();

    await for (final currentSpace in currentSpaceStream) {
      if (currentSpace == null) {
        yield null;
      } else {
        final members = await spaceService.getMembersBySpaceId(currentSpace.id);
        final memberInfoList = await Future.wait(
          members.map((member) async {
            final user = await userService.getUser(member.user_id);
            return user != null
                ? ApiUserInfo(
                    user: user, isLocationEnabled: member.location_enabled)
                : null;
          }),
        );

        final nonNullMembers = memberInfoList.whereType<ApiUserInfo>().toList();

        yield SpaceInfo(
          space: currentSpace,
          members: nonNullMembers,
        );
      }
    }
  }

  Future<SpaceInfo?> getSpaceInfo(String spaceId) async {
    final space = await getSpace(spaceId);
    if (space == null) return null;
    final members = await spaceService.getMembersBySpaceId(space.id);
    return SpaceInfo(
      space: space,
      members: members
          .map((member) async {
            final user = await userService.getUser(member.user_id);
            return user != null
                ? ApiUserInfo(
                    user: user, isLocationEnabled: member.location_enabled)
                : null;
          })
          .whereType<ApiUserInfo>()
          .toList(),
    );
  }

  Stream<ApiSpace?> getCurrentSpace() async* {
    final spaceId = currentSpaceId;
    if (spaceId!.isEmpty) {
      final userId = currentUser?.id ?? '';
      final userSpaces = await userSpacesStream(userId).first;
      yield userSpaces.firstOrNull;
    } else {
      final space = await getSpace(spaceId);
      yield space;
    }
  }

  Stream<List<ApiSpace>> userSpacesStream(String userId) {
    return spaceService
        .getSpaceMemberByUserId(userId)
        .asyncMap(((List<ApiSpaceMember> members) async {
      var spaces = await Future.wait(members
          .map((member) async => spaceService.getSpace(member.space_id)));
      return spaces.whereType<ApiSpace>().toList();
    }));
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
}
