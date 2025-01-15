// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_group_key_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApiGroupKeyImpl _$$ApiGroupKeyImplFromJson(Map<String, dynamic> json) =>
    _$ApiGroupKeyImpl(
      doc_updated_at: (json['doc_updated_at'] as num).toInt(),
      member_keys: (json['member_keys'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
                k, ApiMemberKeyData.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
    );

Map<String, dynamic> _$$ApiGroupKeyImplToJson(_$ApiGroupKeyImpl instance) =>
    <String, dynamic>{
      'doc_updated_at': instance.doc_updated_at,
      'member_keys':
          instance.member_keys.map((k, e) => MapEntry(k, e.toJson())),
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
      recipient_id: json['recipient_id'] as String? ?? "",
      ephemeral_pub: const BlobConverter().fromJson(json['ephemeral_pub']),
      iv: const BlobConverter().fromJson(json['iv']),
      ciphertext: const BlobConverter().fromJson(json['ciphertext']),
      created_at: (json['created_at'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$EncryptedDistributionImplToJson(
        _$EncryptedDistributionImpl instance) =>
    <String, dynamic>{
      'recipient_id': instance.recipient_id,
      'ephemeral_pub': const BlobConverter().toJson(instance.ephemeral_pub),
      'iv': const BlobConverter().toJson(instance.iv),
      'ciphertext': const BlobConverter().toJson(instance.ciphertext),
      'created_at': instance.created_at,
    };

_$ApiSenderKeyRecordImpl _$$ApiSenderKeyRecordImplFromJson(
        Map<String, dynamic> json) =>
    _$ApiSenderKeyRecordImpl(
      id: json['id'] as String,
      device_id: (json['device_id'] as num).toInt(),
      distribution_id: json['distribution_id'] as String,
      record: const BlobConverter().fromJson(json['record']),
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
