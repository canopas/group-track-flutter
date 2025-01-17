import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/api/auth/auth_models.dart';
import 'package:data/log/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

import '../api/network/client.dart';
import '../api/space/api_group_key_model.dart';
import '../api/space/api_space_service.dart';
import '../storage/app_preferences.dart';

final bufferedSenderKeystoreProvider = Provider((ref) => BufferedSenderKeystore(
      ref.read(firestoreProvider),
      ref.read(senderKeyJsonPod.notifier),
      ref.read(currentUserJsonPod.notifier),
    ));

class BufferedSenderKeystore extends SenderKeyStore {
  final StateController<String?> senderKeyJsonState;
  final StateController<String?> userJsonState;
  final FirebaseFirestore _db;

  BufferedSenderKeystore(this._db, this.senderKeyJsonState, this.userJsonState);

  final Map<StoreKey, SenderKeyRecord> _inMemoryStore = {};

  CollectionReference<ApiSenderKeyRecord> senderKeyRef(
      String spaceId, String userId) {
    return _db
        .collection(FIRESTORE_SPACE_PATH)
        .doc(spaceId)
        .collection(FIRESTORE_SPACE_MEMBER_PATH)
        .doc(userId)
        .collection(FIRESTORE_SPACE_MEMBER_SENDER_KEY_RECORD)
        .withConverter<ApiSenderKeyRecord>(
            fromFirestore: ApiSenderKeyRecord.fromFireStore,
            toFirestore: (senderKey, options) => senderKey.toJson());
  }

  ApiUser? get currentUser => userJsonState.state != null
      ? ApiUser.fromJson(jsonDecode(userJsonState.state!))
      : null;

  @override
  Future<SenderKeyRecord> loadSenderKey(SenderKeyName senderKeyName) {
    final sender = senderKeyName.sender;
    final key = StoreKey(sender, senderKeyName.groupId, sender.getDeviceId());

    final cache = _inMemoryStore[key];

    final stateFromPref = senderKeyJsonState.state;
    final cacheSenderKey = stateFromPref == null
        ? null
        : ApiSenderKeyRecord.fromJson(jsonDecode(stateFromPref));

    final keyRecordFuture = cache != null
        ? Future.value(cache)
        : (cacheSenderKey != null
                ? Future.value(
                    SenderKeyRecord.fromSerialized(cacheSenderKey.record.bytes))
                : null) ??
            fetchSenderKeyFromServer(sender);

    keyRecordFuture.then((keyRecord) {
      _inMemoryStore[key] = keyRecord;
    });

    return keyRecordFuture;
  }

  @override
  Future<void> storeSenderKey(
      SenderKeyName senderKeyName, SenderKeyRecord record) {
    final sender = senderKeyName.sender;
    final key = StoreKey(sender, senderKeyName.groupId, sender.getDeviceId());
    if (_inMemoryStore.containsKey(key)) {
      return Future.value();
    }

    _inMemoryStore[key] = record;

    saveSenderKeyToServer(senderKeyName, record).then((value) {
      if (value != null) {
        senderKeyJsonState.state = jsonEncode(value.toJson());
      }
    });

    return Future.value();
  }

  Future<SenderKeyRecord> fetchSenderKeyFromServer(
      SignalProtocolAddress sender) {
    final newKeyRecord = SenderKeyRecord();
    final currentUser = this.currentUser;
    if (currentUser == null) {
      return Future.value(newKeyRecord);
    }

    return senderKeyRef(sender.getName(), currentUser.id)
        .where('device_id', isEqualTo: sender.getDeviceId())
        .get()
        .then((querySnapshot) {
      final doc = querySnapshot.docs.firstOrNull;
      if (doc == null) {
        return newKeyRecord;
      }

      final apiSenderKeyRecord = doc.data();
      try {
        return SenderKeyRecord.fromSerialized(apiSenderKeyRecord.record.bytes);
      } catch (e, s) {
        logger.e("Failed to deserialize sender key record",
            error: e, stackTrace: s);
        return newKeyRecord;
      }
    }).catchError((e, s) {
      logger.e("Failed to fetch sender key from server for sender: $sender",
          error: e, stackTrace: s);
      return newKeyRecord;
    });
  }

  Future<ApiSenderKeyRecord?> saveSenderKeyToServer(
      SenderKeyName senderKeyName, SenderKeyRecord record) async {
    try {
      final currentUser = this.currentUser;
      if (currentUser == null) {
        return null;
      }

      final distributionId = senderKeyName.groupId;
      final deviceId = senderKeyName.sender.getDeviceId();
      final uniqueDocId = "$deviceId-$distributionId";
      final spaceId = senderKeyName.sender.getName();
      final senderKeyRecord = ApiSenderKeyRecord(
          id: uniqueDocId,
          device_id: deviceId,
          address: spaceId,
          distribution_id: distributionId,
          record: Blob(record.serialize()),
          created_at: DateTime.now().millisecondsSinceEpoch);

      print("XXX store senderKeyRecord ${senderKeyName.sender.getName()}");

      await senderKeyRef(spaceId, currentUser.id)
          .doc(uniqueDocId)
          .set(senderKeyRecord);

      return senderKeyRecord;
    } catch (e, s) {
      logger.d("Failed to save sender key to server", error: e, stackTrace: s);
      return null;
    }
  }
}

class StoreKey {
  final SignalProtocolAddress address;
  final String groupId;
  final int senderDeviceId;

  StoreKey(this.address, this.groupId, this.senderDeviceId);
}
