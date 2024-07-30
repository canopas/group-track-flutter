// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_table.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LocationTableImpl _$$LocationTableImplFromJson(Map<String, dynamic> json) =>
    _$LocationTableImpl(
      userId: json['userId'] as String,
      lastFiveMinutesLocations: json['lastFiveMinutesLocations'] as String?,
      lastLocationJourney: json['lastLocationJourney'] as String?,
    );

Map<String, dynamic> _$$LocationTableImplToJson(_$LocationTableImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'lastFiveMinutesLocations': instance.lastFiveMinutesLocations,
      'lastLocationJourney': instance.lastLocationJourney,
    };
