import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'space_models.freezed.dart';
part 'space_models.g.dart';

@freezed
class ApiSpace with _$ApiSpace {
  const ApiSpace._();

  const factory ApiSpace({
    required String id,
    required String admin_id,
    required String name,
    int? created_at,
  }) = _ApiSpace;

  factory ApiSpace.fromJson(Map<String, dynamic> data) =>
      _$ApiSpaceFromJson(data);

  factory ApiSpace.fromFireStore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    Map<String, dynamic>? data = snapshot.data();
    return ApiSpace.fromJson(data!);
  }

  Map<String, dynamic> toFireStore(ApiSpace space) => space.toJson();
}
