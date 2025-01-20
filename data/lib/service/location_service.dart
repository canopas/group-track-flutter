import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/log/logger.dart';
import 'package:data/storage/app_preferences.dart';
import 'package:data/utils/buffered_sender_keystore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/auth/auth_models.dart';
import '../api/location/location.dart';
import '../api/network/client.dart';
import '../api/space/api_group_key_model.dart';
import '../api/space/api_space_service.dart';
import '../utils/private_key_helper.dart';

final locationServiceProvider = Provider((ref) {
  final service = LocationService(
      ref.read(currentUserPod),
      ref.read(userPassKeyPod),
      ref.read(firestoreProvider),
      ref.read(bufferedSenderKeystoreProvider));

  ref.listen(currentUserPod, (prev, user) {
    service.currentUser = user;
  });
  return service;
});

class LocationService {
  ApiUser? currentUser;
  final String? userPasskey;
  final FirebaseFirestore _db;
  final BufferedSenderKeystore _bufferedSenderKeystore;

  LocationService(this.currentUser, this.userPasskey, this._db,
      this._bufferedSenderKeystore);

  CollectionReference<EncryptedApiLocation> _locationRef(
          String spaceID, String userId) =>
      _db
          .collection(FIRESTORE_SPACE_PATH)
          .doc(spaceID)
          .collection(FIRESTORE_SPACE_MEMBER_PATH)
          .doc(userId)
          .collection(FIRESTORE_SPACE_MEMBER_LOCATION_PATH)
          .withConverter<EncryptedApiLocation>(
              fromFirestore: EncryptedApiLocation.fromFireStore,
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

  Stream<List<ApiLocation?>> getCurrentLocationStream(
      String spaceId, String userId) {
    return _locationRef(spaceId, userId)
        .orderBy('created_at', descending: true)
        .limit(1)
        .snapshots()
        .asyncMap<List<ApiLocation?>>((snapshot) async {
      if (snapshot.docs.isNotEmpty) {
        return await Future.wait(snapshot.docs.map((doc) async {
          return toApiLocation(doc.data(), spaceId);
        }));
      }
      return List.empty();
    });
  }

  Future<ApiLocation?> getCurrentLocation(String spaceId, String userId) async {
    var snapshot = await _locationRef(spaceId, userId)
        .orderBy('created_at', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.map((doc) async {
        return await toApiLocation(doc.data(), spaceId);
      }).first;
    }
    return null;
  }

  Future<ApiLocation?> toApiLocation(
      EncryptedApiLocation location, String spaceId) async {
    try {
      final user = currentUser;
      final passKey = userPasskey;
      if (user == null || passKey == null) {
        logger.d('LocationService: User not found');
        return null;
      }

      if (user.identity_key_private == null ||
          (user.identity_key_private?.isEmpty ?? true)) return null;

      final groupKey = await _getGroupKey(spaceId);
      if (groupKey == null) {
        logger.d('LocationService: Group key not found for space $spaceId');
        return null;
      }

      final memberKeyData = groupKey.member_keys[user.id];
      if (memberKeyData == null) {
        logger.d(
            'LocationService: Member key not found for user ${user.id} in space $spaceId');
        return null;
      }

      final distributions = memberKeyData.distributions
          .where((d) => d.recipient_id == user.id)
          .toList()
        ..sort((a, b) => b.created_at.compareTo(a.created_at));

      final distribution = distributions.firstOrNull;
      if (distribution == null) {
        logger.d(
            'LocationService: Distribution not found for user ${user.id} in space $spaceId');
        return null;
      }

      final groupCipher = await getGroupCipher(
        spaceId: spaceId,
        deviceId: memberKeyData.member_device_id,
        distribution: distribution,
        privateKeyBytes: user.identity_key_private!,
        salt: user.identity_key_salt!,
        passkey: passKey,
        bufferedSenderKeyStore: _bufferedSenderKeystore,
      );

      if (groupCipher == null) {
        logger.d('LocationService: Error while getting group cipher');
        return null;
      }

      final decryptedLatitude = await groupCipher.decrypt(location.latitude);
      final decryptedLongitude = await groupCipher.decrypt(location.longitude);

      final latitude = double.tryParse(utf8.decode(decryptedLatitude));
      final longitude = double.tryParse(utf8.decode(decryptedLongitude));

      if (latitude == null || longitude == null) {
        return null;
      }

      return ApiLocation(
        id: location.id,
        user_id: location.user_id,
        latitude: latitude,
        longitude: longitude,
        created_at: location.created_at,
      );
    } catch (e, s) {
      logger.e('Error while decrypting location', error: e, stackTrace: s);
    }

    return null;
  }

  Future<ApiGroupKey?> _getGroupKey(String spaceId) async {
    final doc = await spaceGroupKeysDocRef(spaceId).get();
    return doc.data();
  }

  Future<void> saveCurrentLocation(
    LocationData locationData,
  ) async {
    final user = currentUser;
    final passKey = "1111";
    if (user == null || passKey == null) {
      logger.d('LocationService: User not found');
      return;
    }

    print("XXX updateUserLocation ${locationData.latitude}:${locationData.longitude}");

    if (user.identity_key_private == null ||
        (user.identity_key_private?.isEmpty ?? true)) return;

    user.space_ids?.forEach((spaceId) async {
      final groupKey = await _getGroupKey(spaceId);
      if (groupKey == null) {
        logger.d('LocationService: Group key not found for space $spaceId');
        return;
      }

      final memberKeyData = groupKey.member_keys[user.id];
      if (memberKeyData == null) {
        logger.d(
            'LocationService: Member key not found for user ${user.id} in space $spaceId');
        return;
      }

      final distributions = memberKeyData.distributions
          .where((d) => d.recipient_id == user.id)
          .toList()
        ..sort((a, b) => b.created_at.compareTo(a.created_at));

      final distribution = distributions.firstOrNull;
      if (distribution == null) {
        logger.d(
            'LocationService: Distribution not found for user ${user.id} in space $spaceId');
        return;
      }

      final groupCipher = await getGroupCipher(
        spaceId: spaceId,
        deviceId: memberKeyData.member_device_id,
        distribution: distribution,
        privateKeyBytes: user.identity_key_private!,
        salt: user.identity_key_salt!,
        passkey: passKey,
        bufferedSenderKeyStore: _bufferedSenderKeystore,
      );

      if (groupCipher == null) {
        logger.d('LocationService: Error while getting group cipher');
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
        latitude: encryptedLatitude,
        longitude: encryptedLongitude,
        created_at: locationData.timestamp.millisecondsSinceEpoch,
      );

      await docRef.set(location);
    });
  }
}
