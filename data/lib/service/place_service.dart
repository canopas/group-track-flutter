// ignore_for_file: constant_identifier_names
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/api/place/api_place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../api/network/client.dart';
import '../api/space/api_space_service.dart';
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

  CollectionReference<ApiSpace> get _spaceRef =>
      _db.collection(FIRESTORE_SPACE_PATH).withConverter<ApiSpace>(
          fromFirestore: ApiSpace.fromFireStore,
          toFirestore: (space, options) => space.toJson());

  CollectionReference<ApiPlace> spacePlacesRef(String spaceId) =>
      _spaceRef.doc(spaceId).collection('space_places').withConverter<ApiPlace>(
          fromFirestore: ApiPlace.fromFireStore,
          toFirestore: (place, options) => place.toJson());

  CollectionReference<ApiPlaceMemberSetting> spacePlacesSettingsRef(
      String spaceId, String placeId) {
    return spacePlacesRef(spaceId)
        .doc(placeId)
        .collection('place_settings_by_members')
        .withConverter<ApiPlaceMemberSetting>(
            fromFirestore: ApiPlaceMemberSetting.fromFireStore,
            toFirestore: (settings, options) => settings.toJson());
  }

  Stream<List<ApiPlace>> getAllPlacesStream(String spaceId) {
    return spacePlacesRef(spaceId).snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => doc.data()).whereType<ApiPlace>().toList());
  }

  Future<List<ApiPlace>> getAllPlaces(String spaceId) async {
    final snapshot = await spacePlacesRef(spaceId).get();
    return snapshot.docs
        .map((doc) => doc.data())
        .whereType<ApiPlace>()
        .toList();
  }

  Future<ApiPlace?> getPlace(String placeId) async {
    final querySnapshot = await spacePlacesRef(placeId)
        .where("id", isEqualTo: placeId)
        .limit(1)
        .get();

    return querySnapshot.docs.firstOrNull?.data();
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

    await placeDoc.set(place);

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
          .set(setting);
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
      return setting.docs.first.data();
    }
    return null;
  }

  Future<void> updatePlaceSetting(
    String spaceId,
    String placeId,
    String userId,
    ApiPlaceMemberSetting setting,
  ) async {
    await spacePlacesSettingsRef(spaceId, placeId).doc(userId).set(setting);
  }

  Future<void> updatePlace(ApiPlace place) async {
    await spacePlacesRef(place.space_id).doc(place.id).set(place);
  }

  Future<void> joinUserToExistingPlaces({
    required String userId,
    required String spaceId,
  }) async {
    final allPlaces = await getAllPlaces(spaceId);

    if (allPlaces.isEmpty) return;

    for (final place in allPlaces) {
      final settings = await spacePlacesSettingsRef(spaceId, place.id).get();
      for (final settingDoc in settings.docs) {
        final setting = settingDoc.data();
        final updatedSetting = setting.copyWith(
          arrival_alert_for: {...setting.arrival_alert_for, userId}.toList(),
          leave_alert_for: {...setting.leave_alert_for, userId}.toList(),
        );
        await updatePlaceSetting(
            spaceId, place.id, setting.user_id, updatedSetting);
      }
      await updatePlace(place
          .copyWith(space_member_ids: [...place.space_member_ids, userId]));

      final newUserSettings = ApiPlaceMemberSetting(
        user_id: userId,
        place_id: place.id,
        alert_enable: true,
        arrival_alert_for: place.space_member_ids,
        leave_alert_for: place.space_member_ids,
      );
      await spacePlacesSettingsRef(spaceId, place.id)
          .doc(userId)
          .set(newUserSettings);
    }
  }

  Future<void> removedUserFromExistingPlaces(
      String spaceId, String userId) async {
    final allPlaces = await getAllPlaces(spaceId);

    for (final place in allPlaces) {
      final spaceMemberIds =
          place.space_member_ids.where((id) => id != userId).toList();

      final settings = await spacePlacesSettingsRef(spaceId, place.id).get();
      for (final settingDoc in settings.docs) {
        final setting = settingDoc.data();
        if (setting.user_id == userId) {
          await spacePlacesSettingsRef(spaceId, place.id).doc(userId).delete();
        } else {
          final updatedSetting = setting.copyWith(
            arrival_alert_for:
                setting.arrival_alert_for.where((id) => id != userId).toList(),
            leave_alert_for:
                setting.leave_alert_for.where((id) => id != userId).toList(),
          );
          await updatePlaceSetting(
              spaceId, place.id, setting.user_id, updatedSetting);
        }
      }
      await updatePlace(place.copyWith(space_member_ids: spaceMemberIds));
    }
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
