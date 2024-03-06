// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApiUserImpl _$$ApiUserImplFromJson(Map<String, dynamic> json) =>
    _$ApiUserImpl(
      id: json['id'] as String,
      first_name: json['first_name'] as String?,
      last_name: json['last_name'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      provider_firebase_id_token: json['provider_firebase_id_token'] as String?,
      auth_type: json['auth_type'] as int,
      profile_image: json['profile_image'] as String?,
      location_enabled: json['location_enabled'] as bool? ?? true,
      space_ids: (json['space_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      created_at: json['created_at'] as int?,
    );

Map<String, dynamic> _$$ApiUserImplToJson(_$ApiUserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'first_name': instance.first_name,
      'last_name': instance.last_name,
      'phone': instance.phone,
      'email': instance.email,
      'provider_firebase_id_token': instance.provider_firebase_id_token,
      'auth_type': instance.auth_type,
      'profile_image': instance.profile_image,
      'location_enabled': instance.location_enabled,
      'space_ids': instance.space_ids,
      'created_at': instance.created_at,
    };

_$ApiSessionImpl _$$ApiSessionImplFromJson(Map<String, dynamic> json) =>
    _$ApiSessionImpl(
      id: json['id'] as String,
      user_id: json['user_id'] as String,
      platform: json['platform'] as int? ?? 1,
      fcm_token: json['fcm_token'] as String? ?? "",
      session_active: json['session_active'] as bool,
      device_name: json['device_name'] as String?,
      device_id: json['device_id'] as String?,
      created_at: json['created_at'] as int?,
      battery_status: json['battery_status'] as String?,
      app_version: json['app_version'] as int?,
    );

Map<String, dynamic> _$$ApiSessionImplToJson(_$ApiSessionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.user_id,
      'platform': instance.platform,
      'fcm_token': instance.fcm_token,
      'session_active': instance.session_active,
      'device_name': instance.device_name,
      'device_id': instance.device_id,
      'created_at': instance.created_at,
      'battery_status': instance.battery_status,
      'app_version': instance.app_version,
    };
