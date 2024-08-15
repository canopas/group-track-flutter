// ignore_for_file: constant_identifier_names
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/api/place/api_place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../api/network/client.dart';
import '../api/space/space_models.dart';
import '../config.dart';

const DEFAULT_RADIUS = 1500;
const PLACE_BASE_URL = 'https://places.googleapis.com/v1/places:searchText';

final placeServiceProvider = Provider(
  (ref) => PlaceService(
    ref.read(firestoreProvider),
  ),
);

class PlaceService {
  final FirebaseFirestore _db;

  PlaceService(this._db);

  CollectionReference get _spaceRef => _db.collection('spaces').withConverter<ApiSpace>(
      fromFirestore: ApiSpace.fromFireStore,
      toFirestore: (space, options) => space.toJson());

  CollectionReference spacePlacesRef(String spaceId) =>
      _spaceRef.doc(spaceId).collection('space_places');

  CollectionReference spacePlacesSettingsRef(String spaceId, String placeId) {
    return spacePlacesRef(spaceId)
        .doc(placeId)
        .collection('place_settings_by_members');
  }

  Stream<List<ApiPlace>> getAllPlacesStream(String spaceId) {
    return spacePlacesRef(spaceId).snapshots().map((snapshot) => snapshot.docs
        .map((doc) => ApiPlace.fromJson(doc.data() as Map<String, dynamic>))
        .toList());
  }

  Future<List<ApiPlace>> getAllPlace(String spaceId) async {
    final snapshot = await spacePlacesRef(spaceId).get();
    return snapshot.docs
        .map((doc) => ApiPlace.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<ApiPlace?> getPlace(String placeId) async {
    final querySnapshot = await _spaceRef.firestore
        .collectionGroup('space_places')
        .where('id', isEqualTo: placeId)
        .orderBy('created_at', descending: false)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.data() as ApiPlace;
    }
    return null;
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
    final placeDoc = spacePlacesRef(spaceId).doc();

    final place = ApiPlace(
      id: placeDoc.id,
      space_id: spaceId,
      created_by: createdBy,
      latitude: latitude,
      longitude: longitude,
      name: name,
      created_at: DateTime.now(),
      space_member_ids: spaceMemberIds,
    );

    await placeDoc.set(place.toJson());

    final settings = spaceMemberIds.map((memberId) {
      final filterIds = spaceMemberIds.where((id) => id != memberId).toList();
      return ApiPlaceMemberSetting(
        user_id: memberId,
        place_id: place.id,
        alert_enable: true,
        leave_alert_for: filterIds,
        arrival_alert_for: filterIds,
      );
    }).toList();

    for (final setting in settings) {
      await spacePlacesSettingsRef(spaceId, place.id)
          .doc(setting.user_id)
          .set(setting.toJson());
    }
  }

  Future<ApiPlaceMemberSetting?> getPlaceMemberSetting(
    String placeId,
    String spaceId,
    String userId,
  ) async {
    final setting = await spacePlacesSettingsRef(spaceId, placeId)
        .where("user_id", isEqualTo: userId)
        .limit(1)
        .get();

    if (setting.docs.isNotEmpty) {
      return ApiPlaceMemberSetting.fromJson(
          setting.docs.first.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> updatePlaceSetting(
    String spaceId,
    String placeId,
    String userId,
    ApiPlaceMemberSetting setting,
  ) async {
    await spacePlacesSettingsRef(spaceId, placeId).doc(userId).set(
          setting.toJson(),
        );
  }

  Future<void> updatePlace(ApiPlace place) async {
    await spacePlacesRef(place.space_id).doc(place.id).set(place.toJson());
  }

  Future<List<ApiNearbyPlace>> searchNearbyPlaces(
    String query,
    double? lat,
    double? lng,
  ) async {
    final placeRadius = (lat != null && lng != null) ? DEFAULT_RADIUS : 0;
    final headers = {
      "Content-Type": "application/json",
      "X-Goog-Api-Key": AppConfig.placeApiKey,
      "X-Goog-FieldMask":
          "places.id,places.displayName,places.formattedAddress,places.location,nextPageToken",
    };
    final body = jsonEncode({
      'textQuery': query,
      'pageSize': 8,
      "locationBias": {
        "circle": {
          "center": {"latitude": lat, "longitude": lng},
          "radius": placeRadius
        }
      },
    });

    final response = await http.post(
      Uri.parse(PLACE_BASE_URL),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> results = data['places'];
      return results.map((result) {
        return ApiNearbyPlace(
          id: result['id'] ?? '',
          name: result['displayName']['text'] ?? '',
          formatted_address: result['formattedAddress'] ?? '',
          lat: result['location']['latitude']?.toDouble() ?? 0.0,
          lng: result['location']['longitude']?.toDouble() ?? 0.0,
        );
      }).toList();
    } else {
      throw Exception('Failed to load nearby places');
    }
  }
}
