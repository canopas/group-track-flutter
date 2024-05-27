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
