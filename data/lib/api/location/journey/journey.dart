import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'journey.freezed.dart';
part 'journey.g.dart';

@freezed
class ApiLocationJourney with _$ApiLocationJourney {
  const ApiLocationJourney._();

  const factory ApiLocationJourney({
    String? id,
    required String user_id,
    required double from_latitude,
    required double from_longitude,
    double? to_latitude,
    double? to_longitude,
    double? route_distance,
    int? route_duration,
    @Default([]) List<JourneyRoute> routes,
    int? created_at,
    int? update_at,
  }) = _LocationJourney;

  factory ApiLocationJourney.fromJson(Map<String, dynamic> json) =>
      _$ApiLocationJourneyFromJson(json);

  factory ApiLocationJourney.fromFireStore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    Map<String, dynamic>? data = snapshot.data();
    return ApiLocationJourney.fromJson(data!);
  }

  bool isSteadyLocation() {
    return to_latitude == null && to_longitude == null;
  }
}

@freezed
class JourneyRoute with _$JourneyRoute {
  const factory JourneyRoute({
    @Default(0.0) double latitude,
    @Default(0.0) double longitude,
  }) = _JourneyRoute;

  factory JourneyRoute.fromJson(Map<String, dynamic> json) =>
      _$JourneyRouteFromJson(json);
}
