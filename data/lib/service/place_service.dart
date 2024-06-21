import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/api/place/api_place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_webservice/places.dart';

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

  Future<void> findPlace(String text, double lat, double lng) async {
    final places = GoogleMapsPlaces(apiKey: placeApiKey);
    final result = await places.searchNearbyWithRadius(
      Location(lat: lat, lng: lng),
      5000,
      keyword: text,
    );
    if (result.status == "OK") {
     print('XXX data test:${result.results}');
    } else {
      throw Exception(result.errorMessage);
    }
  }
}
