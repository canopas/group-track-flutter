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
      memberDeviceId: (json['memberDeviceId'] as num?)?.toInt() ?? 0,
      dataUpdatedAt: (json['dataUpdatedAt'] as num?)?.toInt() ?? 0,
      distributions: (json['distributions'] as List<dynamic>?)
              ?.map((e) =>
                  EncryptedDistribution.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ApiMemberKeyDataImplToJson(
        _$ApiMemberKeyDataImpl instance) =>
    <String, dynamic>{
      'memberDeviceId': instance.memberDeviceId,
      'dataUpdatedAt': instance.dataUpdatedAt,
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
