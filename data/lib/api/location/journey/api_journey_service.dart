import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/utils/location_converters.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../log/logger.dart';
import '../../../storage/database/location_table_dao.dart';
import '../../network/client.dart';
import 'journey.dart';

final journeyServiceProvider = Provider((ref) => ApiJourneyService(
      ref.read(firestoreProvider),
    ));

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
      update_at: updated_at ?? created_at ?? DateTime.now().millisecondsSinceEpoch,
    );
    await docRef.set(journey.toJson());
    await _updateLocationJourneyInDatabase(userId, journey);
  }

  Future<void> updateLastLocationJourney(
    String userId,
    ApiLocationJourney journey,
  ) async {
    try {
      await _updateLocationJourneyInDatabase(userId, journey);
      await _journeyRef(userId).doc(journey.id).set(journey.toJson());
    } catch (error) {
      logger.e(
        'ApiJourneyService: Error while updating last location journey',
        error: error,
      );
    }
  }

  Future<void> _updateLocationJourneyInDatabase(
    String userId,
    ApiLocationJourney journey,
  ) async {
    try {
      final locationData = await locationTableDao.getLocationData(userId);
      if (locationData != null) {
        final updatedLocationData = locationData.copyWith(
          lastLocationJourney: LocationConverters.journeyToString(journey),
        );
        await locationTableDao.updateLocationTable(updatedLocationData);
      }
    } catch (error) {
      logger.e(
        'ApiJourneyService: Error while updating journey in database',
        error: error,
      );
    }
  }

  Future<List<ApiLocationJourney>> getJourneyHistory(
    String userId,
    int? from,
    int? to,
  ) async {
    if (from == null) {
      final querySnapshot = await _journeyRef(userId)
          .where('user_id', isEqualTo: userId)
          .orderBy('created_at', descending: true)
          .limit(20)
          .get();
      return querySnapshot.docs
          .map((doc) =>
              ApiLocationJourney.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } else if (to == null) {
      final querySnapshot = await _journeyRef(userId)
          .where('user_id', isEqualTo: userId)
          .where('created_at', isGreaterThanOrEqualTo: from)
          .orderBy('created_at', descending: true)
          .limit(20)
          .get();

      return querySnapshot.docs
          .map((doc) =>
              ApiLocationJourney.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } else {
      final querySnapshot = await _journeyRef(userId)
          .where('user_id', isEqualTo: userId)
          .where('created_at', isGreaterThanOrEqualTo: from)
          .where('created_at', isLessThanOrEqualTo: to)
          .orderBy('created_at', descending: true)
          .limit(20)
          .get();

      return querySnapshot.docs
          .map((doc) =>
              ApiLocationJourney.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    }
  }

  Future<List<ApiLocationJourney>> getMoreJourneyHistory(
    String userId,
    int? from,
  ) async {
    if (from == null) {
      final querySnapshot = await _journeyRef(userId)
          .where('user_id', isEqualTo: userId)
          .orderBy('created_at', descending: true)
          .limit(20)
          .get();
      return querySnapshot.docs
          .map((doc) =>
              ApiLocationJourney.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    }
    final querySnapshot = await _journeyRef(userId)
        .where('user_id', isEqualTo: userId)
        .where('created_at', isLessThan: from)
        .orderBy('created_at', descending: true)
        .limit(20)
        .get();
    return querySnapshot.docs
        .map((doc) =>
            ApiLocationJourney.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
