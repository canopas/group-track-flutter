import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

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
    int? user_state,
    int? created_at,
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

// @JsonEnum(valueField: "value")
// enum UserState {
//   steady(0),
//   moving(1),
//
//   final int value;
//
//   const UserState(this.value);
// }