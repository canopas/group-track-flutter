import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_place.freezed.dart';
part 'api_place.g.dart';

const geofenceDefaultPlaceRadius = 200.0;

@freezed
class ApiPlace with _$ApiPlace {
  const ApiPlace._();

  const factory ApiPlace({
    required String id,
    required String created_by,
    required String space_id,
    required String name,
    required double latitude,
    required double longitude,
    required double radius,
    DateTime? created_at,
  }) = _ApiPlace;

  factory ApiPlace.fromJson(Map<String, dynamic> data) =>
      _$ApiPlaceFromJson(_convertTimestamps(data));

  factory ApiPlace.fromFireStore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    Map<String, dynamic>? data = snapshot.data();
    return ApiPlace.fromJson(data!);
  }

  Map<String, dynamic> toFireStore(ApiPlace space) => space.toJson();
}

Map<String, dynamic> _convertTimestamps(Map<String, dynamic> json) {
  json.update('created_at', (value) => (value as Timestamp).toDate().toString(),
      ifAbsent: () => null);
  return json;
}

@freezed
class ApiPlaceMemberSetting with _$ApiPlaceMemberSetting {
  const ApiPlaceMemberSetting._();

  const factory ApiPlaceMemberSetting({
    required String user_id,
    required String place_id,
    required bool alert_enabled,
    required List<String> arrival_alert_for,
    required List<String> leave_alert_for,
  }) = _ApiPlaceMemberSetting;

  factory ApiPlaceMemberSetting.fromJson(Map<String, dynamic> data) =>
      _$ApiPlaceMemberSettingFromJson(data);

  factory ApiPlaceMemberSetting.fromFireStore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    Map<String, dynamic>? data = snapshot.data();
    return ApiPlaceMemberSetting.fromJson(data!);
  }

  Map<String, dynamic> toFireStore(ApiPlaceMemberSetting space) =>
      space.toJson();
}
