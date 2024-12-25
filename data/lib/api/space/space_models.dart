// ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/api/auth/auth_models.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'space_models.freezed.dart';
part 'space_models.g.dart';

@freezed
class ApiSpace with _$ApiSpace {
  const ApiSpace._();

  const factory ApiSpace({
    required String id,
    required String admin_id,
    required String name,
    int? created_at,
  }) = _ApiSpace;

  factory ApiSpace.fromJson(Map<String, dynamic> data) =>
      _$ApiSpaceFromJson(data);

  factory ApiSpace.fromFireStore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    Map<String, dynamic>? data = snapshot.data();
    return ApiSpace.fromJson(data!);
  }

  Map<String, dynamic> toFireStore(ApiSpace space) => space.toJson();
}

@freezed
class ApiSpaceMember with _$ApiSpaceMember {
  const ApiSpaceMember._();

  const factory ApiSpaceMember({
    required String id,
    required String space_id,
    required String user_id,
    required int role,
    required bool location_enabled,
    int? created_at,
  }) = _ApiSpaceMember;

  factory ApiSpaceMember.fromJson(Map<String, dynamic> data) =>
      _$ApiSpaceMemberFromJson(data);

  factory ApiSpaceMember.fromFireStore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    Map<String, dynamic>? data = snapshot.data();
    return ApiSpaceMember.fromJson(data!);
  }

  Map<String, dynamic> toFireStore(ApiSpaceMember space) => space.toJson();
}

@freezed
class ApiSpaceInvitation with _$ApiSpaceInvitation {
  const ApiSpaceInvitation._();

  const factory ApiSpaceInvitation({
    required String id,
    required String space_id,
    required String code,
    int? created_at,
  }) = _ApiSpaceInvitation;

  factory ApiSpaceInvitation.fromJson(Map<String, dynamic> data) =>
      _$ApiSpaceInvitationFromJson(data);

  factory ApiSpaceInvitation.fromFireStore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    Map<String, dynamic>? data = snapshot.data();
    return ApiSpaceInvitation.fromJson(data!);
  }

  Map<String, dynamic> toFireStore() => toJson();

  bool get isExpired {
    if (created_at == null) return true;
    final currentTimeMillis = DateTime.now().millisecondsSinceEpoch;
    const twoDaysMillis = 2 * 24 * 60 * 60 * 1000;

    final differenceMillis = currentTimeMillis - created_at!;
    return differenceMillis > twoDaysMillis;
  }

  Duration? get remainingTime {
    if (created_at == null) return null;
    const twoDaysMillis = 2 * 24 * 60 * 60 * 1000;
    final expirationTime = created_at! + twoDaysMillis;
    final currentTimeMillis = DateTime.now().millisecondsSinceEpoch;

    if (currentTimeMillis > expirationTime) {
      return Duration.zero;
    }

    return Duration(milliseconds: expirationTime - currentTimeMillis);
  }
}

@freezed
class SpaceInfo with _$SpaceInfo {
  const SpaceInfo._();

  const factory SpaceInfo({
    required ApiSpace space,
    required List<ApiUserInfo> members,
  }) = _SpaceInfo;

  factory SpaceInfo.fromJson(Map<String, dynamic> data) =>
      _$SpaceInfoFromJson(data);

  factory SpaceInfo.fromFireStore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    Map<String, dynamic>? data = snapshot.data();
    return SpaceInfo.fromJson(data!);
  }

  Map<String, dynamic> toFireStore() => toJson();
}

const SPACE_MEMBER_ROLE_ADMIN = 1;
const SPACE_MEMBER_ROLE_MEMBER = 2;