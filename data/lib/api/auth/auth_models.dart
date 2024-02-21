import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_models.freezed.dart';
part 'auth_models.g.dart';

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
    DateTime? created_at,
  }) = _ApiUser;

  factory ApiUser.fromJson(Map<String, dynamic> json) =>
      _$ApiUserFromJson(json);
}

@freezed
class ApiSession with _$ApiSession {
  const factory ApiSession(
      {required String id,
      required String user_id,
      int? platform,
      String? fcm_token,
      required bool session_active,
      String? device_name,
      String? device_id,
      DateTime? created_at,
      String? battery_status,
      int? app_version}) = _ApiSession;

  factory ApiSession.fromJson(Map<String, dynamic> json) =>
      _$ApiSessionFromJson(json);
}
