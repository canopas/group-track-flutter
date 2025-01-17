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
      identity_key_public: _$JsonConverterFromJson<String, Uint8List>(
          json['identity_key_public'], const BlobConverter().fromJson),
      identity_key_private: _$JsonConverterFromJson<String, Uint8List>(
          json['identity_key_private'], const BlobConverter().fromJson),
      identity_key_salt: _$JsonConverterFromJson<String, Uint8List>(
          json['identity_key_salt'], const BlobConverter().fromJson),
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
      'identity_key_public': _$JsonConverterToJson<String, Uint8List>(
          instance.identity_key_public, const BlobConverter().toJson),
      'identity_key_private': _$JsonConverterToJson<String, Uint8List>(
          instance.identity_key_private, const BlobConverter().toJson),
      'identity_key_salt': _$JsonConverterToJson<String, Uint8List>(
          instance.identity_key_salt, const BlobConverter().toJson),
      'state': instance.state,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);

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

_$ApiUserInfoImpl _$$ApiUserInfoImplFromJson(Map<String, dynamic> json) =>
    _$ApiUserInfoImpl(
      user: ApiUser.fromJson(json['user'] as Map<String, dynamic>),
      location: json['location'] == null
          ? null
          : ApiLocation.fromJson(json['location'] as Map<String, dynamic>),
      isLocationEnabled: json['isLocationEnabled'] as bool,
      session: json['session'] == null
          ? null
          : ApiSession.fromJson(json['session'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ApiUserInfoImplToJson(_$ApiUserInfoImpl instance) =>
    <String, dynamic>{
      'user': instance.user.toJson(),
      'location': instance.location?.toJson(),
      'isLocationEnabled': instance.isLocationEnabled,
      'session': instance.session?.toJson(),
    };
