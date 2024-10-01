import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../api/auth/auth_models.dart';
import '../api/location/location.dart';
import '../api/network/client.dart';

final locationServiceProvider = Provider((ref) => LocationService(
      ref.read(firestoreProvider),
    ));

class LocationService {
  final FirebaseFirestore _db;

  LocationService(this._db);

  CollectionReference get _userRef =>
      _db.collection("users").withConverter<ApiUser>(
          fromFirestore: ApiUser.fromFireStore,
          toFirestore: (user, options) => user.toJson());

  CollectionReference _locationRef(String userId) => _userRef
      .doc(userId)
      .collection("user_locations")
      .withConverter<ApiLocation>(
          fromFirestore: ApiLocation.fromFireStore,
          toFirestore: (location, _) => location.toJson());

  Stream<List<ApiLocation>?> getCurrentLocationStream(String userId) {
    return _locationRef(userId)
        .where("user_id", isEqualTo: userId)
        .orderBy('created_at', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) => doc.data() as ApiLocation).toList();
      }
      return null;
    });
  }

  Future<void> saveCurrentLocation(
    String userId,
    LatLng latLng,
    int recodedAt,
  ) async {
    final docRef = _locationRef(userId).doc();

    final location = ApiLocation(
        id: docRef.id,
        user_id: userId,
        latitude: latLng.latitude,
        longitude: latLng.longitude,
        created_at: recodedAt);

    await docRef.set(location);
  }
}
