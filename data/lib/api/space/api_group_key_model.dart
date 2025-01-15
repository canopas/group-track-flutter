
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/converter/blob_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_group_key_model.freezed.dart';
part 'api_group_key_model.g.dart';

@freezed
class ApiGroupKey with _$ApiGroupKey {
  const ApiGroupKey._();

  const factory ApiGroupKey({
    required int doc_updated_at,
    @Default({}) Map<String, ApiMemberKeyData> member_keys,
  }) = _ApiGroupKey;

  factory ApiGroupKey.fromJson(Map<String, dynamic> data) =>
      _$ApiGroupKeyFromJson(data);

  factory ApiGroupKey.fromFireStore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    Map<String, dynamic>? data = snapshot.data();
    return ApiGroupKey.fromJson(data!);
  }

  Map<String, dynamic> toFireStore(ApiGroupKey key) => key.toJson();

}

@freezed
class ApiMemberKeyData with _$ApiMemberKeyData {
  const factory ApiMemberKeyData({
    @Default(0)int member_device_id,
    @Default(0) int data_updated_at,
    @Default([]) List<EncryptedDistribution> distributions,
  }) = _ApiMemberKeyData;

  factory ApiMemberKeyData.fromJson(Map<String, dynamic> data) =>
      _$ApiMemberKeyDataFromJson(data);

}

@freezed
class EncryptedDistribution with _$EncryptedDistribution {
  const EncryptedDistribution._();

  const factory EncryptedDistribution({
    @Default("") String recipient_id,
    @BlobConverter() required Blob ephemeral_pub,
    @BlobConverter() required Blob iv,
    @BlobConverter() required Blob ciphertext,
    @Default(0) int created_at,
  }) = _EncryptedDistribution;

  factory EncryptedDistribution.fromJson(Map<String, dynamic> data) =>
      _$EncryptedDistributionFromJson(data);

  void validateFieldSizes() {
    if (ephemeral_pub.bytes.length != 33 && ephemeral_pub.bytes.isNotEmpty) {
      throw ArgumentError(
          "Invalid size for ephemeralPub: expected 33 bytes, got ${ephemeral_pub.bytes.length} bytes.");
    }
    if (iv.bytes.length != 16 && iv.bytes.isNotEmpty) {
      throw ArgumentError(
          "Invalid size for iv: expected 16 bytes, got ${iv.bytes.length} bytes.");
    }
    if (ciphertext.bytes.length > 64 * 1024 && ciphertext.bytes.isNotEmpty) {
      throw ArgumentError(
          "Invalid size for ciphertext: maximum allowed size is 64 KB, got ${ciphertext.bytes.length} bytes.");
    }
  }
}

@freezed
class ApiSenderKeyRecord with _$ApiSenderKeyRecord {
  const ApiSenderKeyRecord._();

  const factory ApiSenderKeyRecord({
    required String id,
    required int device_id,
    required String distribution_id,
    @BlobConverter() required Blob record,
    @Default('') String address,
    required int created_at,
  }) = _ApiSenderKeyRecord;

  factory ApiSenderKeyRecord.fromJson(Map<String, dynamic> json) =>
      _$ApiSenderKeyRecordFromJson(json);

  factory ApiSenderKeyRecord.fromFireStore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    Map<String, dynamic>? data = snapshot.data();
    return ApiSenderKeyRecord.fromJson(data!);
  }

  Map<String, dynamic> toFireStore(ApiSenderKeyRecord instance) => instance.toJson();
}
