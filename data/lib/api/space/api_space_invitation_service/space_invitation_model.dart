import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'space_invitation_model.freezed.dart';
part 'space_invitation_model.g.dart';

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
}