import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/api/place/api_place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/network/client.dart';

const placeApiKey = "AIzaSyDLlL9HqzRyfVQHsNkNZjJf1ItdwvEJTOc";

final placeServiceProvider = Provider(
  (ref) => PlaceService(
    ref.read(firestoreProvider),
  ),
);

class PlaceService {
  final FirebaseFirestore _db;

  PlaceService(this._db);

  CollectionReference get _spaceRef => _db.collection('spaces');

  CollectionReference spacePlacesRef(String spaceId) =>
      _spaceRef.doc(spaceId).collection('space_places');

  Stream<List<ApiPlace>> getAllPlacesStream(String spaceId) {
    return spacePlacesRef(spaceId).snapshots().map((snapshot) => snapshot.docs
        .map((doc) => ApiPlace.fromJson(doc.data() as Map<String, dynamic>))
        .toList());
  }

  Future<void> deletePlace(String spaceId, String placeId) async {
    await spacePlacesRef(spaceId).doc(placeId).delete();
  }

  Future<void> addPlace(
    String spaceId,
    String name,
    double latitude,
    double longitude,
    String createdBy,
    List<String> spaceMemberIds,
  ) async {


  }
}
