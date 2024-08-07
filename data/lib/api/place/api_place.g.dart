// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_place.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApiPlaceImpl _$$ApiPlaceImplFromJson(Map<String, dynamic> json) =>
    _$ApiPlaceImpl(
      id: json['id'] as String,
      created_by: json['created_by'] as String,
      space_id: json['space_id'] as String,
      name: json['name'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      radius: (json['radius'] as num?)?.toDouble() ?? 200.0,
      created_at: _$JsonConverterFromJson<Timestamp, DateTime>(
          json['created_at'], const TimeStampJsonConverter().fromJson),
      space_member_ids: (json['space_member_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ApiPlaceImplToJson(_$ApiPlaceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_by': instance.created_by,
      'space_id': instance.space_id,
      'name': instance.name,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'radius': instance.radius,
      'created_at': _$JsonConverterToJson<Timestamp, DateTime>(
          instance.created_at, const TimeStampJsonConverter().toJson),
      'space_member_ids': instance.space_member_ids,
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

_$ApiPlaceMemberSettingImpl _$$ApiPlaceMemberSettingImplFromJson(
        Map<String, dynamic> json) =>
    _$ApiPlaceMemberSettingImpl(
      user_id: json['user_id'] as String,
      place_id: json['place_id'] as String,
      alert_enable: json['alert_enable'] as bool? ?? false,
      arrival_alert_for: (json['arrival_alert_for'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      leave_alert_for: (json['leave_alert_for'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ApiPlaceMemberSettingImplToJson(
        _$ApiPlaceMemberSettingImpl instance) =>
    <String, dynamic>{
      'user_id': instance.user_id,
      'place_id': instance.place_id,
      'alert_enable': instance.alert_enable,
      'arrival_alert_for': instance.arrival_alert_for,
      'leave_alert_for': instance.leave_alert_for,
    };

_$ApiNearbyPlaceImpl _$$ApiNearbyPlaceImplFromJson(Map<String, dynamic> json) =>
    _$ApiNearbyPlaceImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      formatted_address: json['formatted_address'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );

Map<String, dynamic> _$$ApiNearbyPlaceImplToJson(
        _$ApiNearbyPlaceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'formatted_address': instance.formatted_address,
      'lat': instance.lat,
      'lng': instance.lng,
    };
