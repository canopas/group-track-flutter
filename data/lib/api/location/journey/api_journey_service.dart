import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../../../log/logger.dart';
import '../../network/client.dart';
import 'journey.dart';

final journeyServiceProvider = Provider((ref) => ApiJourneyService(
      ref.read(firestoreProvider),
    ));

class ApiJourneyService {
  late FirebaseFirestore _db;

  ApiJourneyService(FirebaseFirestore fireStore) {
    _db = fireStore;
  }

  CollectionReference get _userRef => _db.collection("users");

  CollectionReference _journeyRef(String userId) =>
      _userRef.doc(userId).collection("user_journeys");

  Future<String> saveCurrentJourney({
    required String userId,
    required double fromLatitude,
    required double fromLongitude,
    double? toLatitude,
    double? toLongitude,
    LatLng? toLatLng,
    List<JourneyRoute>? routes,
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
      routes: routes ?? [],
      route_distance: routeDistance,
      route_duration: routeDuration,
      created_at: created_at ?? DateTime.now().millisecondsSinceEpoch,
      update_at: updated_at ?? DateTime.now().millisecondsSinceEpoch,
    );
    await docRef.set(journey.toJson());
    return docRef.id;
  }

  Future<void> updateLastLocationJourney(
    String userId,
    ApiLocationJourney journey,
  ) async {
    try {
      await _journeyRef(userId).doc(journey.id).set(journey.toJson());
    } catch (error) {
      logger.e(
        'ApiJourneyService: Error while updating last location journey',
        error: error,
      );
    }
  }

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

  Future<ApiLocationJourney?> getUserJourneyById(
    String journeyId,
    String userId,
  ) async {
    final querySnapshot = await _journeyRef(userId).doc(journeyId).get();

    if (querySnapshot.exists) {
      return ApiLocationJourney.fromJson(
        querySnapshot.data() as Map<String, dynamic>,
      );
    }
    return null;
  }

  Future<void> uploadLogFileToFirebase() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final logFile = File('${directory.path}/app.log');
      final storage = FirebaseStorage.instance;
      final fileName = 'LOG_${DateTime.now().millisecondsSinceEpoch}.log';
      final logFileRef = storage.ref().child('logs/$fileName');
      await logFileRef.putFile(logFile);
    } catch (e) {
      logger.e('Error uploading log file: $e');
    }
  }
}
