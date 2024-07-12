// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApiLocationImpl _$$ApiLocationImplFromJson(Map<String, dynamic> json) =>
    _$ApiLocationImpl(
      id: json['id'] as String?,
      user_id: json['user_id'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      user_state: (json['user_state'] as num?)?.toInt(),
      created_at: (json['created_at'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$ApiLocationImplToJson(_$ApiLocationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.user_id,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'user_state': instance.user_state,
      'created_at': instance.created_at,
    };
