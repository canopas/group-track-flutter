import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'journey.freezed.dart';
part 'journey.g.dart';



@freezed
class ApiLocationJourney with _$ApiLocationJourney {
  const ApiLocationJourney._();

  @JsonSerializable(explicitToJson: true)
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

  // @override
  // Map<String, dynamic> toJson() {
  //   print('XXX data route:${routes.map((route) => route.toJson()).toList()}');
  //   return {
  //     'id': id,
  //     'user_id': user_id,
  //     'from_latitude': from_latitude,
  //     'from_longitude': from_longitude,
  //     'to_latitude': to_latitude,
  //     'to_longitude': to_longitude,
  //     'route_distance': route_distance,
  //     'route_duration': route_duration,
  //     'routes': [],
  //     'created_at': created_at,
  //     'update_at': update_at,
  //   };
  // }
}

@freezed
class JourneyRoute with _$JourneyRoute {
  const factory JourneyRoute({
    required double latitude,
    required double longitude,
  }) = _JourneyRoute;

  factory JourneyRoute.fromJson(Map<String, dynamic> json) =>
      _$JourneyRouteFromJson(json);

  // @override
  // Map<String, dynamic> toJson() {
  //   return {
  //     'latitude': latitude,
  //     'longitude': longitude,
  //   };
  // }
}
