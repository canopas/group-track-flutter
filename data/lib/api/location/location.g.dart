// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApiLocationImpl _$$ApiLocationImplFromJson(Map<String, dynamic> json) =>
    _$ApiLocationImpl(
      id: json['id'] as String,
      user_id: json['user_id'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      created_at: (json['created_at'] as num).toInt(),
    );

Map<String, dynamic> _$$ApiLocationImplToJson(_$ApiLocationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.user_id,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'created_at': instance.created_at,
    };

_$EncryptedApiLocationImpl _$$EncryptedApiLocationImplFromJson(
        Map<String, dynamic> json) =>
    _$EncryptedApiLocationImpl(
      id: json['id'] as String,
      user_id: json['user_id'] as String,
      latitude: const BlobConverter()
          .fromJson(json['latitude'] as Map<String, dynamic>?),
      longitude: const BlobConverter()
          .fromJson(json['longitude'] as Map<String, dynamic>?),
      created_at: (json['created_at'] as num).toInt(),
    );

Map<String, dynamic> _$$EncryptedApiLocationImplToJson(
        _$EncryptedApiLocationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.user_id,
      'latitude': const BlobConverter().toJson(instance.latitude),
      'longitude': const BlobConverter().toJson(instance.longitude),
      'created_at': instance.created_at,
    };
