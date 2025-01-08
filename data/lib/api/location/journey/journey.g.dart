// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journey.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LocationJourneyImpl _$$LocationJourneyImplFromJson(
        Map<String, dynamic> json) =>
    _$LocationJourneyImpl(
      id: json['id'] as String?,
      user_id: json['user_id'] as String,
      from_latitude: (json['from_latitude'] as num).toDouble(),
      from_longitude: (json['from_longitude'] as num).toDouble(),
      to_latitude: (json['to_latitude'] as num?)?.toDouble(),
      to_longitude: (json['to_longitude'] as num?)?.toDouble(),
      routes: (json['routes'] as List<dynamic>?)
              ?.map((e) => JourneyRoute.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      route_distance: (json['route_distance'] as num?)?.toDouble(),
      route_duration: (json['route_duration'] as num?)?.toInt(),
      created_at: (json['created_at'] as num).toInt(),
      updated_at: (json['updated_at'] as num).toInt(),
      type: json['type'] as String,
    );

Map<String, dynamic> _$$LocationJourneyImplToJson(
        _$LocationJourneyImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.user_id,
      'from_latitude': instance.from_latitude,
      'from_longitude': instance.from_longitude,
      'to_latitude': instance.to_latitude,
      'to_longitude': instance.to_longitude,
      'routes': instance.routes.map((e) => e.toJson()).toList(),
      'route_distance': instance.route_distance,
      'route_duration': instance.route_duration,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
      'type': instance.type,
    };

_$JourneyRouteImpl _$$JourneyRouteImplFromJson(Map<String, dynamic> json) =>
    _$JourneyRouteImpl(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$$JourneyRouteImplToJson(_$JourneyRouteImpl instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

_$EncryptedLocationJourneyImpl _$$EncryptedLocationJourneyImplFromJson(
        Map<String, dynamic> json) =>
    _$EncryptedLocationJourneyImpl(
      id: json['id'] as String?,
      user_id: json['user_id'] as String,
      from_latitude: const BlobConverter()
          .fromJson(json['from_latitude'] as Map<String, dynamic>?),
      from_longitude: const BlobConverter()
          .fromJson(json['from_longitude'] as Map<String, dynamic>?),
      to_latitude: const BlobConverter()
          .fromJson(json['to_latitude'] as Map<String, dynamic>?),
      to_longitude: const BlobConverter()
          .fromJson(json['to_longitude'] as Map<String, dynamic>?),
      routes: (json['routes'] as List<dynamic>?)
              ?.map((e) =>
                  EncryptedJourneyRoute.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      route_distance: (json['route_distance'] as num?)?.toDouble(),
      route_duration: (json['route_duration'] as num?)?.toInt(),
      created_at: (json['created_at'] as num).toInt(),
      updated_at: (json['updated_at'] as num).toInt(),
      type: json['type'] as String,
    );

Map<String, dynamic> _$$EncryptedLocationJourneyImplToJson(
        _$EncryptedLocationJourneyImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.user_id,
      'from_latitude': const BlobConverter().toJson(instance.from_latitude),
      'from_longitude': const BlobConverter().toJson(instance.from_longitude),
      'to_latitude': _$JsonConverterToJson<Map<String, dynamic>?, Blob>(
          instance.to_latitude, const BlobConverter().toJson),
      'to_longitude': _$JsonConverterToJson<Map<String, dynamic>?, Blob>(
          instance.to_longitude, const BlobConverter().toJson),
      'routes': instance.routes.map((e) => e.toJson()).toList(),
      'route_distance': instance.route_distance,
      'route_duration': instance.route_duration,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
      'type': instance.type,
    };

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);

_$EncryptedJourneyRouteImpl _$$EncryptedJourneyRouteImplFromJson(
        Map<String, dynamic> json) =>
    _$EncryptedJourneyRouteImpl(
      latitude: const BlobConverter()
          .fromJson(json['latitude'] as Map<String, dynamic>?),
      longitude: const BlobConverter()
          .fromJson(json['longitude'] as Map<String, dynamic>?),
    );

Map<String, dynamic> _$$EncryptedJourneyRouteImplToJson(
        _$EncryptedJourneyRouteImpl instance) =>
    <String, dynamic>{
      'latitude': const BlobConverter().toJson(instance.latitude),
      'longitude': const BlobConverter().toJson(instance.longitude),
    };
