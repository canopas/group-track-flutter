import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../log/logger.dart';
import '../../network/client.dart';
import '../../space/space_models.dart';
import 'journey.dart';

final journeyServiceProvider = Provider((ref) => ApiJourneyService(
      ref.read(firestoreProvider),
    ));

class ApiJourneyService {
  late FirebaseFirestore _db;

  ApiJourneyService(FirebaseFirestore fireStore) {
    _db = fireStore;
  }

  CollectionReference get _spaceRef =>
      _db.collection("spaces").withConverter<ApiSpace>(
          fromFirestore: ApiSpace.fromFireStore,
          toFirestore: (space, options) => space.toJson());

  CollectionReference _spaceMemberRef(String spaceId) => _spaceRef
      .doc(spaceId)
      .collection("space_members")
      .withConverter<ApiSpaceMember>(
      fromFirestore: ApiSpaceMember.fromFireStore,
      toFirestore: (member, _) => member.toJson());

  CollectionReference _userJourneyRef(String spaceId, String userId) =>
      _spaceMemberRef(spaceId)
          .doc(userId)
          .collection("user_journeys");


  Future<List<String>> saveCurrentJourney({
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

    final spaces = await getUserSpaces(userId);

    final journeyIds = <String>[];

    for (final space in spaces) {
      final docRef = _userJourneyRef(space!.id, userId).doc();

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
      journeyIds.add(docRef.id);
    }
    return journeyIds;
  }

  Future<void> updateLastLocationJourney(String userId, ApiLocationJourney journey) async {
    try {
      final spaces = await getUserSpaces(userId);
      for (final space in spaces) {
        await _userJourneyRef(space!.id, userId).doc(journey.id).set(journey.toJson());
      }
    } catch (error) {
      logger.e(
        'ApiJourneyService: Error while updating last location journey',
        error: error,
      );
    }
  }

  Future<ApiLocationJourney?> getLastJourneyLocation(String userId) async {
    final preferences = await SharedPreferences.getInstance();
    final spaceId = preferences.get('current_space_id');
    if (spaceId == null) {
      return null;
    }
    final querySnapshot = await _userJourneyRef(spaceId.toString(), userId)
        .orderBy('created_at', descending: true)
        .limit(1)
        .get();

    final doc = querySnapshot.docs.firstOrNull;
    if (doc != null) {
      return ApiLocationJourney.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<List<ApiLocationJourney>> getJourneyHistory({
    required String spaceId,
    required String userId,
    int? from,
    int? to,
  }) async {
    final querySnapshot = await _userJourneyRef(spaceId, userId)
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

  Future<List<ApiLocationJourney>> getMoreJourneyHistory({
    required String spaceId,
    required String userId,
    int? from,
  }) async {
    final querySnapshot = await _userJourneyRef(spaceId, userId)
        .where('created_at', isLessThan: from)
        .orderBy('created_at', descending: true)
        .limit(20)
        .get();

    return querySnapshot.docs
        .map((doc) =>
        ApiLocationJourney.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<ApiSpace?>> getUserSpaces(String userId) async {
    final spaceMembers = await getSpaceMemberByUserId(userId);
    final spaces = await Future.wait(spaceMembers.map((spaceMember) async {
      final spaceId = spaceMember.space_id;
      final space = await getSpace(spaceId);
      return space;
    }).toList());
    return spaces;
  }

  Future<List<ApiSpaceMember>> getSpaceMemberByUserId(String userId) async {
    final querySnapshot = await _spaceRef.firestore
        .collectionGroup('space_members')
        .where("user_id", isEqualTo: userId)
        .get();
    return querySnapshot.docs
        .map((doc) => ApiSpaceMember.fromJson(doc.data()))
        .toList();
  }

  Future<ApiSpace?> getSpace(String spaceId) async {
    final docSnapshot = await _spaceRef.doc(spaceId).get();
    if (docSnapshot.exists) {
      return docSnapshot.data() as ApiSpace;
    }
    return null;
  }
}
