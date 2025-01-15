import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/log/logger.dart';
import 'package:data/storage/app_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/auth/auth_models.dart';
import '../api/location/location.dart';
import '../api/network/client.dart';
import '../api/space/api_group_key_model.dart';
import '../utils/private_key_helper.dart';

final locationServiceProvider =
    Provider((ref) => LocationService(ref.read(firestoreProvider)));

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

  DocumentReference<ApiGroupKey> spaceGroupKeysDocRef(String spaceId) {
    return FirebaseFirestore.instance
        .collection('spaces')
        .doc(spaceId)
        .collection('group_keys')
        .doc('group_keys')
        .withConverter<ApiGroupKey>(
            fromFirestore: ApiGroupKey.fromFireStore,
            toFirestore: (key, options) => key.toJson());
  }

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

  Future<ApiLocation?> getCurrentLocation(String userId) async {
    var snapshot = await _locationRef(userId)
        .where("user_id", isEqualTo: userId)
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

      final data = getGroupCipherAndDistributionMessage(
        spaceId: spaceId,
        deviceId: memberKeyData.member_device_id,
        distribution: distribution,
        privateKeyBytes: user.identity_key_private!.bytes,
        salt: user.identity_key_salt!.bytes,
        passkey: passKey,
        bufferedSenderKeyStore: ,
      );
    });
  }
}
