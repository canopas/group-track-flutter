import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/api/location/location.dart';
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
    @Default([]) List<JourneyRoute> routes,
    double? route_distance,
    int? route_duration,
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

  LocationData toPositionFromSteadyJourney() {
    return LocationData(latitude: from_latitude, longitude: from_longitude, timestamp: DateTime.now());
  }

  LocationData toPositionFromMovingJourney() {
    return LocationData(latitude: to_latitude ?? 0, longitude: to_longitude ?? 0, timestamp: DateTime.now());
  }

  JourneyRoute toRouteFromSteadyJourney() {
    return JourneyRoute(latitude: from_latitude, longitude: from_longitude);
  }

  static ApiLocationJourney fromPosition(LocationData pos, String userId, String newJourneyId) {
    return ApiLocationJourney(
      id: newJourneyId,
      user_id: userId,
      from_latitude: pos.latitude,
      from_longitude: pos.longitude,
      created_at: pos.timestamp.millisecondsSinceEpoch,
    );
  }
}

@freezed
class JourneyRoute with _$JourneyRoute {
  const factory JourneyRoute({
    required double latitude,
    required double longitude,
  }) = _JourneyRoute;

  factory JourneyRoute.fromJson(Map<String, dynamic> json) =>
      _$JourneyRouteFromJson(json);
}
