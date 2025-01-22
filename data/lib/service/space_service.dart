import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/api/auth/api_user_service.dart';
import 'package:data/api/space/api_space_invitation_service.dart';
import 'package:data/api/space/api_space_service.dart';
import 'package:data/api/space/space_models.dart';
import 'package:data/service/place_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

import '../api/auth/auth_models.dart';
import '../api/place/api_place.dart';
import '../storage/app_preferences.dart';
import 'location_service.dart';

final spaceServiceProvider = Provider((ref) {
  final provider = SpaceService(
      ref.read(currentUserPod),
      ref.read(apiSpaceServiceProvider),
      ref.read(apiSpaceInvitationServiceProvider),
      ref.read(currentSpaceId.notifier),
      ref.read(apiUserServiceProvider),
      ref.read(locationServiceProvider),
      ref.read(placeServiceProvider));

  ref.listen(currentUserPod, (prev, user) {
    provider._onUpdateUser(prevUser: prev, currentUser: user);
  });

  return provider;
});

class SpaceService {
  ApiUser? _currentUser;
  final ApiSpaceService spaceService;
  final ApiSpaceInvitationService spaceInvitationService;
  final StateController<String?> _currentSpaceIdController;
  final ApiUserService userService;
  final LocationService locationService;
  final PlaceService placeService;

  SpaceService(
    this._currentUser,
    this.spaceService,
    this.spaceInvitationService,
    this._currentSpaceIdController,
    this.userService,
    this.locationService,
    this.placeService,
  );

  String? get currentSpaceId => _currentSpaceIdController.state;

  set currentSpaceId(String? value) {
    _currentSpaceIdController.state = value;
  }

  void _onUpdateUser({ApiUser? prevUser, ApiUser? currentUser}) {
    _currentUser = currentUser;
  }

  Future<String> createSpaceAndGetInviteCode({
    required String spaceName,
    required String userId,
    required Uint8List? identityKeyPublic,
  }) async {
    final spaceId =
        await spaceService.createSpace(spaceName, userId, identityKeyPublic);
    final generatedCode =
        await spaceInvitationService.createInvitation(spaceId);
    currentSpaceId = spaceId;
    return generatedCode;
  }

  Future<void> joinSpace(String spaceId) async {
    final user = _currentUser;
    if (user == null) return;

    await spaceService.joinSpace(spaceId, user.id, user.identity_key_public);
    await placeService.joinUserToExistingPlaces(
        userId: user.id, spaceId: spaceId);
    currentSpaceId = spaceId;
  }

  Stream<List<SpaceInfo>> streamAllSpace(String userId) {
    return streamUserSpaces(userId).switchMap((spaces) {
      if (spaces.isEmpty) {
        return Stream.value([]);
      }

      final spaceInfoStreams = spaces.map((space) {
        if (space == null) return Stream.value(null);

        return spaceService
            .getStreamSpaceMemberBySpaceId(space.id)
            .switchMap((members) {
          final memberInfoStreams = members.map((member) {
            return CombineLatestStream.combine2(
              userService.getUserStream(member.user_id),
              Stream.value(member.location_enabled),
              (user, isLocationEnabled) {
                return user != null
                    ? ApiUserInfo(
                        user: user,
                        isLocationEnabled: isLocationEnabled,
                      )
                    : null;
              },
            );
          }).toList();

          return CombineLatestStream.list(memberInfoStreams)
              .map((memberInfoList) {
            final nonNullMembers =
                memberInfoList.whereType<ApiUserInfo>().toList();
            return SpaceInfo(space: space, members: nonNullMembers);
          });
        });
      }).toList();

      return CombineLatestStream.list(spaceInfoStreams).map((spaceInfoList) {
        return spaceInfoList
            .where((spaceInfo) => spaceInfo != null)
            .cast<SpaceInfo>()
            .toList();
      });
    });
  }

  Future<SpaceInfo?> getSpaceInfo(String spaceId) async {
    final space = await getSpace(spaceId);
    if (space == null) return null;

    final members = await spaceService.getMembersBySpaceId(space.id);
    final memberInfo = await Future.wait(members.map((member) async {
      final user = await userService.getUser(member.user_id);
      return user != null
          ? ApiUserInfo(user: user, isLocationEnabled: member.location_enabled)
          : null;
    }).toList());

    return SpaceInfo(
      space: space,
      members: memberInfo.whereType<ApiUserInfo>().toList(),
    );
  }

  Future<List<ApiSpace?>> getUserSpaces(String userId) async {
    final spaceMembers = await spaceService.getSpaceMemberByUserId(userId);
    return await Future.wait(spaceMembers.map((spaceMember) async {
      final spaceId = spaceMember.space_id;
      final space = await spaceService.getSpace(spaceId);
      return space;
    }).toList());
  }

  Stream<List<ApiSpace?>> streamUserSpaces(String userId) {
    return spaceService
        .streamSpaceMemberByUserId(userId)
        .asyncMap((members) async {
      final spaces = await Future.wait(members.map((spaceMember) async {
        final spaceId = spaceMember.space_id;
        return await spaceService.getSpace(spaceId);
      }).toList());
      return spaces;
    });
  }

  Future<ApiSpace?> getSpace(String spaceId) async {
    return spaceService.getSpace(spaceId);
  }

  Future<List<ApiSpaceMember>> getMemberBySpaceId(String spaceId) async {
    return spaceService.getMembersBySpaceId(spaceId);
  }

  Future<String?> getInviteCode(String spaceId) async {
    final code = await spaceInvitationService.getSpaceInviteCode(spaceId);
    if (code?.isExpired ?? false) {
      final newInvitation =
          await spaceInvitationService.regenerateInvitationCode(spaceId);
      return newInvitation?.code;
    }
    return code?.code;
  }

  Future<void> enableLocation(
    String spaceId,
    String userId,
    bool locationEnabled,
  ) async {
    await spaceService.enableLocation(spaceId, userId, locationEnabled);
  }

  Future<void> deleteUserSpaces(String userId) async {
    final allSpace = await getUserSpaces(userId);
    if (allSpace.isEmpty) return;
    final ownSpace = allSpace
        .where((space) => space != null && space.admin_id == userId)
        .toList();
    final joinedSpace = allSpace
        .where((space) => space != null && space.admin_id != userId)
        .toList();

    for (final space in ownSpace) {
      await spaceInvitationService.deleteInvitations(space!.id);
      await spaceService.deleteSpace(space.id);
    }

    for (final space in joinedSpace) {
      leaveSpace(space!.id, userId);
    }
    currentSpaceId = null;
  }

  Future<void> deleteSpace(String spaceId) async {
    await userService.removeSpaceIdForAllSpaceMember(spaceId: spaceId);
    await spaceInvitationService.deleteInvitations(spaceId);
    await spaceService.deleteSpace(spaceId);
    currentSpaceId = null;
  }

  Future<void> leaveSpace(String spaceId, String userId) async {
    await userService.removeSpaceId(userId: userId, spaceId: spaceId);
    await placeService.removedUserFromExistingPlaces(spaceId, userId);
    await spaceService.removeUserFromSpace(spaceId, userId);
    currentSpaceId = null;
  }

  Future<void> updateSpace(ApiSpace newSpace) async {
    await spaceService.updateSpace(newSpace);
  }

  Stream<List<ApiUserInfo>> getMemberWithLocation(String spaceId) {
    if (spaceId.isEmpty) {
      return Stream.value([]);
    }

    return spaceService
        .getStreamSpaceMemberBySpaceId(spaceId)
        .switchMap((members) {
      if (members.isEmpty) {
        return Stream.value([]);
      }

      List<Stream<ApiUserInfo>> userInfoStreams = members.map((member) {
        return CombineLatestStream.combine4(
          userService.getUserStream(member.user_id),
          locationService.getCurrentLocationStream(spaceId, member.user_id),
          Stream.value(member.location_enabled),
          userService.getUserSessionStream(member.user_id),
          (user, location, isLocationEnabled, session) {
            return ApiUserInfo(
              user: user!,
              location: location?.firstOrNull,
              isLocationEnabled: isLocationEnabled,
              session: session,
            );
          },
        );
      }).toList();

      return CombineLatestStream.list(userInfoStreams)
          .map((userInfoList) => userInfoList.toList());
    });
  }

  Stream<List<ApiPlace>> getStreamPlacesByUserId(List<String> spaceIds) {
    if (spaceIds.isEmpty) return Stream.value([]);

    final placeStreams = spaceIds.map((spaceId) {
      return placeService.getAllPlacesStream(spaceId);
    }).toList();

    return CombineLatestStream.list(placeStreams).map((placesLists) {
      return placesLists.expand((places) => places).toList();
    });
  }
}
