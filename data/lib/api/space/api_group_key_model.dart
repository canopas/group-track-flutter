
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/converter/blob_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_group_key_model.freezed.dart';
part 'api_group_key_model.g.dart';

@freezed
class ApiGroupKey with _$ApiGroupKey {
  const ApiGroupKey._();

  const factory ApiGroupKey({
    required int docUpdatedAt,
    @Default({}) Map<String, ApiMemberKeyData> memberKeys,
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
    @Default(0)int memberDeviceId,
    @Default(0) int dataUpdatedAt,
    @Default([]) List<EncryptedDistribution> distributions,
  }) = _ApiMemberKeyData;

  factory ApiMemberKeyData.fromJson(Map<String, dynamic> data) =>
      _$ApiMemberKeyDataFromJson(data);

}

@freezed
class EncryptedDistribution with _$EncryptedDistribution {
  const EncryptedDistribution._();

  const factory EncryptedDistribution({
    @Default("") String recipientId,
    @BlobConverter() required Blob ephemeralPub,
    @BlobConverter() required Blob iv,
    @BlobConverter() required Blob ciphertext,
  }) = _EncryptedDistribution;

  factory EncryptedDistribution.fromJson(Map<String, dynamic> data) =>
      _$EncryptedDistributionFromJson(data);

  void validateFieldSizes() {
    if (ephemeralPub.bytes.length != 33 && ephemeralPub.bytes.isNotEmpty) {
      throw ArgumentError(
          "Invalid size for ephemeralPub: expected 33 bytes, got ${ephemeralPub.bytes.length} bytes.");
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