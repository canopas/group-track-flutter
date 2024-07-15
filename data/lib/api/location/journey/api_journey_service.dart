import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/utils/location_converters.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../storage/database/location_table_dao.dart';
import 'journey.dart';

class ApiJourneyService {
  late FirebaseFirestore _db;

  final LocationTableDao locationTableDao = LocationTableDao();

  ApiJourneyService(FirebaseFirestore fireStore) {
    _db = fireStore;
  }

  CollectionReference get _userRef => _db.collection("users");

  CollectionReference _journeyRef(String userId) =>
      _userRef.doc(userId).collection("user_journeys");

  Future<ApiLocationJourney?> getLastJourneyLocation(String userId) async {
    final querySnapshot = await _journeyRef(userId)
        .where('user_id', isEqualTo: userId)
        .orderBy('created_at', descending: true)
        .limit(1)
        .get();

    final doc = querySnapshot.docs.firstOrNull;
    if (doc != null) {
      return ApiLocationJourney.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> saveCurrentJourney({
    required String userId,
    required double fromLatitude,
    required double fromLongitude,
    double? toLatitude,
    double? toLongitude,
    LatLng? toLatLng,
    double? routeDistance,
    int? routeDuration,
    int? created_at,
    int? updated_at,
  }) async {
    final fromLatLng = LatLng(fromLatitude, fromLongitude);
    final toLatLng = (toLatitude != null && toLongitude != null)
        ? LatLng(toLatitude, toLongitude)
        : null;

    final docRef = _journeyRef(userId).doc();

    final journey = ApiLocationJourney(
      id: docRef.id,
      user_id: userId,
      from_latitude: fromLatLng.latitude,
      from_longitude: fromLatLng.longitude,
      to_latitude: toLatLng?.latitude,
      to_longitude: toLatLng?.longitude,
      route_distance: routeDistance,
      route_duration: routeDuration,
      routes: [],
      created_at: created_at ?? DateTime.now().millisecondsSinceEpoch,
      update_at: created_at ?? DateTime.now().millisecondsSinceEpoch,
    );
    await docRef.set(journey.toJson());
    await _updateLocationJourneyInDatabase(userId, journey);
  }

  Future<void> updateLastLocationJourney(
    String userId,
    ApiLocationJourney journey,
  ) async {
    await _updateLocationJourneyInDatabase(userId, journey);
    await _journeyRef(userId).doc(journey.id).set(journey.toJson());
  }

  Future<void> _updateLocationJourneyInDatabase(
    String userId,
    ApiLocationJourney journey,
  ) async {
    final locationData = await locationTableDao.getLocationData(userId);
    if (locationData != null) {
      final updatedLocationData = locationData.copyWith(
        lastLocationJourney: LocationConverters.journeyToString(journey),
      );
      await locationTableDao.updateLocationTable(updatedLocationData);
    }
  }
}
