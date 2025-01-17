import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class BlobConverter implements JsonConverter<Uint8List, String> {
  const BlobConverter();

  @override
  Uint8List fromJson(String json) {
      return base64Decode(json);
  }

  @override
  String toJson(Uint8List object) {
    return base64UrlEncode(object);
  }
}
