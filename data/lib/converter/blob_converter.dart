import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class BlobConverter implements JsonConverter<Blob, dynamic> {
  const BlobConverter();

  @override
  Blob fromJson(dynamic json) {
    if (json is Blob) {
      return json;
    }

    if (json is Map<String, dynamic> && json.containsKey('_byteString')) {
      final base64String = json['_byteString'] as String;
      return Blob(base64Decode(base64String));
    }


    if (json is List<dynamic>) {
      return Blob(Uint8List.fromList(json.cast<int>()));
    }

    return Blob(Uint8List(0));
  }

  @override
  dynamic toJson(Blob blob) {
    return {
      '_byteString': base64Encode(blob.bytes),
    };
  }
}
