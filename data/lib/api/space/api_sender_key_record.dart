// ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../converter/blob_converter.dart';
import 'dart:typed_data';

part 'api_sender_key_record.freezed.dart';
part 'api_sender_key_record.g.dart';

@freezed
class ApiSenderKeyRecord with _$ApiSenderKeyRecord {
  const ApiSenderKeyRecord._();

  const factory ApiSenderKeyRecord({
    required String id,
    @Default(0) int deviceId,
    @Default('') String address,
    @Default('') String distributionId,
    required int created_at,
    @BlobConverter() required Uint8List record,
  }) = _ApiSenderKeyRecord;

  factory ApiSenderKeyRecord.fromJson(Map<String, dynamic> data) =>
      _$ApiSenderKeyRecordFromJson(data);
}
