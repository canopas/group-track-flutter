// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'space_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApiSpaceImpl _$$ApiSpaceImplFromJson(Map<String, dynamic> json) =>
    _$ApiSpaceImpl(
      id: json['id'] as String,
      admin_id: json['admin_id'] as String,
      name: json['name'] as String,
      created_at: (json['created_at'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$ApiSpaceImplToJson(_$ApiSpaceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'admin_id': instance.admin_id,
      'name': instance.name,
      'created_at': instance.created_at,
    };

_$ApiSpaceMemberImpl _$$ApiSpaceMemberImplFromJson(Map<String, dynamic> json) =>
    _$ApiSpaceMemberImpl(
      id: json['id'] as String,
      space_id: json['space_id'] as String,
      user_id: json['user_id'] as String,
      role: (json['role'] as num).toInt(),
      location_enabled: json['location_enabled'] as bool,
      identity_key_public:
          const BlobConverter().fromJson(json['identity_key_public']),
      created_at: (json['created_at'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$ApiSpaceMemberImplToJson(
        _$ApiSpaceMemberImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'space_id': instance.space_id,
      'user_id': instance.user_id,
      'role': instance.role,
      'location_enabled': instance.location_enabled,
      'identity_key_public': _$JsonConverterToJson<dynamic, Blob>(
          instance.identity_key_public, const BlobConverter().toJson),
      'created_at': instance.created_at,
    };

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);

_$ApiSpaceInvitationImpl _$$ApiSpaceInvitationImplFromJson(
        Map<String, dynamic> json) =>
    _$ApiSpaceInvitationImpl(
      id: json['id'] as String,
      space_id: json['space_id'] as String,
      code: json['code'] as String,
      created_at: (json['created_at'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$ApiSpaceInvitationImplToJson(
        _$ApiSpaceInvitationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'space_id': instance.space_id,
      'code': instance.code,
      'created_at': instance.created_at,
    };

_$SpaceInfoImpl _$$SpaceInfoImplFromJson(Map<String, dynamic> json) =>
    _$SpaceInfoImpl(
      space: ApiSpace.fromJson(json['space'] as Map<String, dynamic>),
      members: (json['members'] as List<dynamic>)
          .map((e) => ApiUserInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$SpaceInfoImplToJson(_$SpaceInfoImpl instance) =>
    <String, dynamic>{
      'space': instance.space.toJson(),
      'members': instance.members.map((e) => e.toJson()).toList(),
    };
