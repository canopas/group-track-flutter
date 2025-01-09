// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_group_key_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApiGroupKeyImpl _$$ApiGroupKeyImplFromJson(Map<String, dynamic> json) =>
    _$ApiGroupKeyImpl(
      docUpdatedAt: (json['docUpdatedAt'] as num).toInt(),
      memberKeys: (json['memberKeys'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
                k, ApiMemberKeyData.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
    );

Map<String, dynamic> _$$ApiGroupKeyImplToJson(_$ApiGroupKeyImpl instance) =>
    <String, dynamic>{
      'docUpdatedAt': instance.docUpdatedAt,
      'memberKeys': instance.memberKeys.map((k, e) => MapEntry(k, e.toJson())),
    };

_$ApiMemberKeyDataImpl _$$ApiMemberKeyDataImplFromJson(
        Map<String, dynamic> json) =>
    _$ApiMemberKeyDataImpl(
      member_device_id: (json['member_device_id'] as num?)?.toInt() ?? 0,
      data_updated_at: (json['data_updated_at'] as num?)?.toInt() ?? 0,
      distributions: (json['distributions'] as List<dynamic>?)
              ?.map((e) =>
                  EncryptedDistribution.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ApiMemberKeyDataImplToJson(
        _$ApiMemberKeyDataImpl instance) =>
    <String, dynamic>{
      'member_device_id': instance.member_device_id,
      'data_updated_at': instance.data_updated_at,
      'distributions': instance.distributions.map((e) => e.toJson()).toList(),
    };

_$EncryptedDistributionImpl _$$EncryptedDistributionImplFromJson(
        Map<String, dynamic> json) =>
    _$EncryptedDistributionImpl(
      recipientId: json['recipientId'] as String? ?? "",
      ephemeralPub: const BlobConverter()
          .fromJson(json['ephemeralPub'] as Map<String, dynamic>?),
      iv: const BlobConverter().fromJson(json['iv'] as Map<String, dynamic>?),
      ciphertext: const BlobConverter()
          .fromJson(json['ciphertext'] as Map<String, dynamic>?),
    );

Map<String, dynamic> _$$EncryptedDistributionImplToJson(
        _$EncryptedDistributionImpl instance) =>
    <String, dynamic>{
      'recipientId': instance.recipientId,
      'ephemeralPub': const BlobConverter().toJson(instance.ephemeralPub),
      'iv': const BlobConverter().toJson(instance.iv),
      'ciphertext': const BlobConverter().toJson(instance.ciphertext),
    };

_$ApiSenderKeyRecordImpl _$$ApiSenderKeyRecordImplFromJson(
        Map<String, dynamic> json) =>
    _$ApiSenderKeyRecordImpl(
      id: json['id'] as String,
      device_id: (json['device_id'] as num).toInt(),
      distribution_id: json['distribution_id'] as String,
      record: const BlobConverter()
          .fromJson(json['record'] as Map<String, dynamic>?),
      address: json['address'] as String? ?? '',
      created_at: (json['created_at'] as num).toInt(),
    );

Map<String, dynamic> _$$ApiSenderKeyRecordImplToJson(
        _$ApiSenderKeyRecordImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'device_id': instance.device_id,
      'distribution_id': instance.distribution_id,
      'record': const BlobConverter().toJson(instance.record),
      'address': instance.address,
      'created_at': instance.created_at,
    };
