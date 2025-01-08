import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class BlobConverter implements JsonConverter<Blob, Map<String, dynamic>?> {
  const BlobConverter();

  @override
  Blob fromJson(Map<String, dynamic>? json) {
    if (json == null || !json.containsKey('_byteString'))  return Blob(Uint8List(0));
    final byteString = json['_byteString'] as String;
    final bytes = base64Decode(byteString);
    return Blob(Uint8List.fromList(bytes));
  }

  @override
  Map<String, dynamic>? toJson(Blob? blob) {
    if (blob == null) return null;
    return {
      '_byteString': base64Encode(blob.bytes),
    };
  }

}