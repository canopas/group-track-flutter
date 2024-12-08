import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/api/space/space_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/location/location.dart';
import '../api/network/client.dart';

final locationServiceProvider = Provider((ref) => LocationService(
      ref.read(firestoreProvider),
    ));

class LocationService {
  final FirebaseFirestore _db;

  LocationService(this._db);

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

  CollectionReference _userLocationRef(String spaceId, String userId) =>
      _spaceMemberRef(spaceId)
          .doc(userId)
          .collection("user_locations")
          .withConverter<ApiLocation>(
          fromFirestore: ApiLocation.fromFireStore,
          toFirestore: (location, _) => location.toJson());

  Stream<ApiLocation?> streamUserLatestLocation({
    required String userId,
    required String spaceId,
  }) {
    return _userLocationRef(spaceId, userId)
        .orderBy('created_at', descending: true)
        .limit(1)
        .snapshots()
        .map((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data() as ApiLocation;
      }
      return null;
    });
  }

  Future<void> saveCurrentLocation({
    required String userId,
    required LocationData locationData,
  }) async {

    final spaces = await getUserSpaces(userId);

    for (final space in spaces) {
      final docRef = _userLocationRef(space!.id, userId).doc();

      final location = ApiLocation(
        id: docRef.id,
        latitude: locationData.latitude,
        longitude: locationData.longitude,
        created_at: DateTime.now().millisecondsSinceEpoch,
        user_id: userId,
      );
      await docRef.set(location);
    }
  }

  Future<void> saveCurrentLocationWithSpaceId({
    required String spaceId,
    required String userId,
    required LocationData locationData,
  }) async {
    final docRef = _userLocationRef(spaceId, userId).doc();

    final location = ApiLocation(
      id: docRef.id,
      latitude: locationData.latitude,
      longitude: locationData.longitude,
      created_at: DateTime.now().millisecondsSinceEpoch,
      user_id: userId,
    );

    await docRef.set(location);
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