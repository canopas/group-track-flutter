import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_models.freezed.dart';
part 'auth_models.g.dart';

const LOGIN_TYPE_GOOGLE = 1;
const LOGIN_TYPE_PHONE = 2;

@freezed
class ApiUser with _$ApiUser {
  const ApiUser._();

  const factory ApiUser({
    required String id,
    String? first_name,
    String? last_name,
    String? phone,
    String? email,
    String? profile_image,
    String? provider_firebase_id_token,
    required int auth_type,
    int? created_at,
  }) = _ApiUser;

  factory ApiUser.fromJson(Map<String, dynamic> json) =>
      _$ApiUserFromJson(json);

  factory ApiUser.fromFireStore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    Map<String, dynamic>? data = snapshot.data();
    return ApiUser.fromJson(data!);
  }

  String toJsonString() => jsonEncode(toJson());

  Map<String, dynamic> toFireStore(ApiUser instance) => instance.toJson();
}

@freezed
class ApiSession with _$ApiSession {
  const ApiSession._();

  const factory ApiSession(
      {required String id,
      required String user_id,
      int? platform,
      String? fcm_token,
      required bool session_active,
      String? device_name,
      String? device_id,
      int? created_at,
      String? battery_status,
      int? app_version}) = _ApiSession;

  factory ApiSession.fromJson(Map<String, dynamic> json) =>
      _$ApiSessionFromJson(json);

  factory ApiSession.fromFireStore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    Map<String, dynamic>? data = snapshot.data();
    return ApiSession.fromJson(data!);
  }

  String toJsonString() => jsonEncode(toJson());

  Map<String, dynamic> toFireStore(ApiSession instance) => instance.toJson();
}
