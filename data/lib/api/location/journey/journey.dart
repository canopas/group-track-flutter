// ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/api/location/location.dart';
import 'package:data/domain/journey_lat_lng_entension.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'journey.freezed.dart';

part 'journey.g.dart';

const JOURNEY_TYPE_STEADY = 'steady';
const JOURNEY_TYPE_MOVING = 'moving';

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
    String? type,
  }) = _LocationJourney;

  factory ApiLocationJourney.fromJson(Map<String, dynamic> json) =>
      _$ApiLocationJourneyFromJson(json);

  factory ApiLocationJourney.fromFireStore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    Map<String, dynamic>? data = snapshot.data();
    return ApiLocationJourney.fromJson(data!);
  }

  bool isSteady() {
    if (type != null) {
      return type == JOURNEY_TYPE_STEADY;
    }
    return to_latitude == null || to_longitude == null;
  }

  bool isMoving() {
    if (type != null) {
      return type == JOURNEY_TYPE_MOVING;
    }
    return to_latitude != null && to_longitude != null;
  }

  List<LatLng> toRoute() {
    if (isSteady()) {
      return [];
    } else if (isMoving()) {
      List<LatLng> result = [LatLng(from_latitude, from_longitude)];
      result.addAll(routes.map((route) => route.toLatLng()));
      if (to_latitude != null && to_longitude != null) {
        result.add(LatLng(to_latitude!, to_longitude!));
      }
      return result;
    }
    return [];
  }

  LocationData toLocationFromSteadyJourney() {
    return LocationData(
        latitude: from_latitude,
        longitude: from_longitude,
        timestamp: DateTime.now());
  }

  LocationData toLocationFromMovingJourney() {
    return LocationData(
        latitude: to_latitude ?? 0,
        longitude: to_longitude ?? 0,
        timestamp: DateTime.now());
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
