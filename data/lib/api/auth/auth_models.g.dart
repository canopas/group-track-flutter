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
      email: json['email'] as String?,
      provider_firebase_id_token: json['provider_firebase_id_token'] as String?,
      auth_type: (json['auth_type'] as num).toInt(),
      profile_image: json['profile_image'] as String?,
      location_enabled: json['location_enabled'] as bool? ?? true,
      space_ids: (json['space_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      battery_pct: (json['battery_pct'] as num?)?.toInt(),
      fcm_token: json['fcm_token'] as String? ?? "",
      public_key: json['public_key'] as String?,
      private_key_encrypted: json['private_key_encrypted'] as String?,
      pre_key_bundle: json['pre_key_bundle'] == null
          ? null
          : ApiUserPreKeyBundle.fromJson(
              json['pre_key_bundle'] as Map<String, dynamic>),
      state: (json['state'] as num?)?.toInt(),
      created_at: (json['created_at'] as num?)?.toInt(),
      updated_at: (json['updated_at'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$ApiUserImplToJson(_$ApiUserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'first_name': instance.first_name,
      'last_name': instance.last_name,
      'email': instance.email,
      'provider_firebase_id_token': instance.provider_firebase_id_token,
      'auth_type': instance.auth_type,
      'profile_image': instance.profile_image,
      'location_enabled': instance.location_enabled,
      'space_ids': instance.space_ids,
      'battery_pct': instance.battery_pct,
      'fcm_token': instance.fcm_token,
      'public_key': instance.public_key,
      'private_key_encrypted': instance.private_key_encrypted,
      'pre_key_bundle': instance.pre_key_bundle?.toJson(),
      'state': instance.state,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
    };

_$ApiUserPreKeyBundleImpl _$$ApiUserPreKeyBundleImplFromJson(
        Map<String, dynamic> json) =>
    _$ApiUserPreKeyBundleImpl(
      identity_key: json['identity_key'] as String,
      signed_prekeys: (json['signed_prekeys'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      one_time_prekeys: (json['one_time_prekeys'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$ApiUserPreKeyBundleImplToJson(
        _$ApiUserPreKeyBundleImpl instance) =>
    <String, dynamic>{
      'identity_key': instance.identity_key,
      'signed_prekeys': instance.signed_prekeys,
      'one_time_prekeys': instance.one_time_prekeys,
    };

_$ApiSessionImpl _$$ApiSessionImplFromJson(Map<String, dynamic> json) =>
    _$ApiSessionImpl(
      id: json['id'] as String,
      user_id: json['user_id'] as String,
      platform: (json['platform'] as num?)?.toInt() ?? 1,
      session_active: json['session_active'] as bool,
      device_name: json['device_name'] as String?,
      device_id: json['device_id'] as String?,
      created_at: (json['created_at'] as num?)?.toInt(),
      app_version: (json['app_version'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$ApiSessionImplToJson(_$ApiSessionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.user_id,
      'platform': instance.platform,
      'session_active': instance.session_active,
      'device_name': instance.device_name,
      'device_id': instance.device_id,
      'created_at': instance.created_at,
      'app_version': instance.app_version,
    };
