//ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/converter/blob_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'location.freezed.dart';

part 'location.g.dart';

@freezed
class ApiLocation with _$ApiLocation {
  const ApiLocation._();

  const factory ApiLocation({
    required String id,
    required String user_id,
    required double latitude,
    required double longitude,
    required int created_at,
  }) = _ApiLocation;

  factory ApiLocation.fromJson(Map<String, dynamic> data) =>
      _$ApiLocationFromJson(data);

  factory ApiLocation.fromFireStore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    Map<String, dynamic>? data = snapshot.data();
    return ApiLocation.fromJson(data!);
  }

  Map<String, dynamic> toFireStore(ApiLocation space) => space.toJson();
}

@freezed
class EncryptedApiLocation with _$EncryptedApiLocation {
  const EncryptedApiLocation._();

  const factory EncryptedApiLocation({
    required String id,
    required String user_id,
    @BlobConverter() required Blob latitude,
    @BlobConverter() required Blob longitude,
    required int created_at,
  }) = _EncryptedApiLocation;

  factory EncryptedApiLocation.fromJson(Map<String, dynamic> data) =>
      _$EncryptedApiLocationFromJson(data);

  factory EncryptedApiLocation.fromFireStore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    Map<String, dynamic>? data = snapshot.data();
    return EncryptedApiLocation.fromJson(data!);
  }

  Map<String, dynamic> toFireStore(ApiLocation space) => space.toJson();
}

class LocationData {
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  LocationData({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });

  double distanceTo(LocationData other) {
    return Geolocator.distanceBetween(
        latitude, longitude, other.latitude, other.longitude);
  }
}

class MapTypeInfo {
  final MapType mapType;
  final int index;

  MapTypeInfo(this.mapType, this.index);
}
