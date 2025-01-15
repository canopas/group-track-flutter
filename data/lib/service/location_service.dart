import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/log/logger.dart';
import 'package:data/utils/buffered_sender_keystore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/auth/auth_models.dart';
import '../api/location/location.dart';
import '../api/network/client.dart';
import '../api/space/api_group_key_model.dart';
import '../api/space/api_space_service.dart';
import '../utils/private_key_helper.dart';

final locationServiceProvider = Provider((ref) => LocationService(
    ref.read(firestoreProvider), ref.read(bufferedSenderKeystoreProvider)));

class LocationService {
  final FirebaseFirestore _db;
  final BufferedSenderKeystore _bufferedSenderKeystore;

  LocationService(this._db, this._bufferedSenderKeystore);

  CollectionReference _locationRef(String spaceID, String userId) => _db
      .collection(FIRESTORE_SPACE_PATH)
      .doc(spaceID)
      .collection(FIRESTORE_SPACE_MEMBER_PATH)
      .doc(userId)
      .collection(FIRESTORE_SPACE_MEMBER_LOCATION_PATH)
      .withConverter<ApiLocation>(
          fromFirestore: ApiLocation.fromFireStore,
          toFirestore: (location, _) => location.toJson());

  DocumentReference<ApiGroupKey> spaceGroupKeysDocRef(String spaceId) {
    return _db
        .collection(FIRESTORE_SPACE_PATH)
        .doc(spaceId)
        .collection(FIRESTORE_SPACE_GROUP_KEYS_PATH)
        .doc(FIRESTORE_SPACE_GROUP_KEYS_PATH)
        .withConverter<ApiGroupKey>(
            fromFirestore: ApiGroupKey.fromFireStore,
            toFirestore: (key, options) => key.toJson());
  }

  Stream<List<ApiLocation>?> getCurrentLocationStream(
      String spaceId, String userId) {
    return _locationRef(spaceId, userId)
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

  Future<ApiLocation?> getCurrentLocation(String spaceId, String userId) async {
    var snapshot = await _locationRef(spaceId, userId)
        .orderBy('created_at', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.map((doc) => doc.data() as ApiLocation).first;
    }
    return null;
  }

  Future<ApiGroupKey?> _getGroupKey(String spaceId) async {
    final doc = await spaceGroupKeysDocRef(spaceId).get();
    return doc.data();
  }

  Future<void> saveCurrentLocation(
    ApiUser user,
    LocationData locationData,
    String passKey,
  ) async {
    if (user.identity_key_private == null ||
        (user.identity_key_private?.bytes.isEmpty ?? true)) return;

    user.space_ids?.forEach((spaceId) async {
      final groupKey = await _getGroupKey(spaceId);
      if (groupKey == null) {
        logger.e('LocationService: Group key not found for space $spaceId');
        return;
      }

      final memberKeyData = groupKey.member_keys[user.id];
      if (memberKeyData == null) {
        logger.e(
            'LocationService: Member key not found for user ${user.id} in space $spaceId');
        return;
      }

      final distributions = memberKeyData.distributions
          .where((d) => d.recipient_id == user.id)
          .toList()
        ..sort((a, b) => b.created_at.compareTo(a.created_at));

      final distribution = distributions.firstOrNull;
      if (distribution == null) {
        logger.e(
            'LocationService: Distribution not found for user ${user.id} in space $spaceId');
        return;
      }

      final groupCipher = await getGroupCipher(
        spaceId: spaceId,
        deviceId: memberKeyData.member_device_id,
        distribution: distribution,
        privateKeyBytes: user.identity_key_private!.bytes,
        salt: user.identity_key_salt!.bytes,
        passkey: passKey,
        bufferedSenderKeyStore: _bufferedSenderKeystore,
      );

      if (groupCipher == null) {
        logger.e('LocationService: Error while getting group cipher');
        return;
      }

      final encryptedLatitude = await groupCipher.encrypt(
          Uint8List.fromList(utf8.encode(locationData.latitude.toString())));
      final encryptedLongitude = await groupCipher.encrypt(
          Uint8List.fromList(utf8.encode(locationData.longitude.toString())));

      final docRef = _locationRef(spaceId, user.id).doc();

      final location = EncryptedApiLocation(
        id: docRef.id,
        user_id: user.id,
        latitude: Blob(encryptedLatitude),
        longitude: Blob(encryptedLongitude),
        created_at: locationData.timestamp.millisecondsSinceEpoch,
      );

      await docRef.set(location);
    });
  }
}
