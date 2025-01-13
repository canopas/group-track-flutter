// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_sender_key_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApiSenderKeyRecordImpl _$$ApiSenderKeyRecordImplFromJson(
        Map<String, dynamic> json) =>
    _$ApiSenderKeyRecordImpl(
      id: json['id'] as String,
      deviceId: (json['deviceId'] as num?)?.toInt() ?? 0,
      address: json['address'] as String? ?? '',
      distributionId: json['distributionId'] as String? ?? '',
      created_at: (json['created_at'] as num).toInt(),
      record: const BlobConverter().fromJson(json['record']),
    );

Map<String, dynamic> _$$ApiSenderKeyRecordImplToJson(
        _$ApiSenderKeyRecordImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'deviceId': instance.deviceId,
      'address': instance.address,
      'distributionId': instance.distributionId,
      'created_at': instance.created_at,
      'record': const BlobConverter().toJson(instance.record),
    };
