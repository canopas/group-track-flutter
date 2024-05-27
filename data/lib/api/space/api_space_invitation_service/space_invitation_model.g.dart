// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'space_invitation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
