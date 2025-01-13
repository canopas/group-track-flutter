import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/api/network/client.dart';
import 'package:data/api/space/api_group_key_model.dart';
import 'package:data/api/space/space_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../utils/buffered_sender_keystore.dart';
import '../../utils/distribution_key_generator.dart';
import '../auth/api_user_service.dart';

final apiSpaceServiceProvider = StateProvider((ref) => ApiSpaceService(
      ref.read(firestoreProvider),
      ref.read(apiUserServiceProvider),
      ref.read(bufferedSenderKeystoreProvider),
    ));

class ApiSpaceService {
  final FirebaseFirestore _db;
  final ApiUserService userService;
  final BufferedSenderKeystore bufferedSenderKeystore;

  ApiSpaceService(
    this._db,
    this.userService,
    this.bufferedSenderKeystore,
  );

  CollectionReference get _spaceRef =>
      _db.collection("spaces").withConverter<ApiSpace>(
          fromFirestore: ApiSpace.fromFireStore,
          toFirestore: (space, options) => space.toJson());

  CollectionReference spaceMemberRef(String spaceId) {
    return FirebaseFirestore.instance
        .collection('spaces')
        .doc(spaceId)
        .collection('space_members');
  }

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

  Future<String> createSpace(
    String name,
    String adminId,
    Blob? identityKeyPublic,
  ) async {
    final doc = _spaceRef.doc();
    final space = ApiSpace(
        id: doc.id,
        admin_id: adminId,
        name: name,
        created_at: DateTime.now().millisecondsSinceEpoch);
    await doc.set(space);

    final emptyGroupKeys =
        ApiGroupKey(doc_updated_at: DateTime.now().millisecondsSinceEpoch);

    await spaceGroupKeysDocRef(doc.id).set(emptyGroupKeys);
    await joinSpace(doc.id, adminId, identityKeyPublic);
    return doc.id;
  }

  Future<ApiSpace?> getSpace(String spaceId) async {
    final docSnapshot = await _spaceRef.doc(spaceId).get();
    if (docSnapshot.exists) {
      return docSnapshot.data() as ApiSpace;
    }
    return null;
  }

  Future<void> joinSpace(String spaceId, String userId, Blob? identityKeyPublic,
      {int role = SPACE_MEMBER_ROLE_MEMBER}) async {

    final member = ApiSpaceMember(
      space_id: spaceId,
      user_id: userId,
      role: role,
      identity_key_public: identityKeyPublic,
      location_enabled: true,
      id: const Uuid().v4(),
      created_at: DateTime.now().millisecondsSinceEpoch,
    );

    await spaceMemberRef(spaceId).doc(userId).set(member.toJson());
    await userService.addSpaceId(userId, spaceId);

    await _distributeSenderKeyToSpaceMembers(spaceId, userId);
  }

  Future<List<ApiSpaceMember>> getMembersBySpaceId(String spaceId) async {
    final collectionRef = FirebaseFirestore.instance
        .collection('spaces')
        .doc(spaceId)
        .collection('space_members');

    final querySnapshot = await collectionRef.get();
    return querySnapshot.docs.map((doc) {
      return ApiSpaceMember.fromJson(doc.data());
    }).toList();
  }

  Stream<List<ApiSpaceMember>> getStreamSpaceMemberBySpaceId(String spaceId) {
    return spaceMemberRef(spaceId).snapshots().map((querySnapshot) =>
        querySnapshot.docs
            .map((doc) =>
                ApiSpaceMember.fromJson(doc.data() as Map<String, dynamic>))
            .toList());
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

  Stream<List<ApiSpaceMember>> streamSpaceMemberByUserId(String userId) {
    return _spaceRef.firestore
        .collectionGroup('space_members')
        .where('user_id', isEqualTo: userId)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => ApiSpaceMember.fromJson(doc.data()))
          .toList();
    });
  }

  Future<void> enableLocation(
      String spaceId, String userId, bool enable) async {
    final querySnapshot =
        await spaceMemberRef(spaceId).where("user_id", isEqualTo: userId).get();

    if (querySnapshot.docs.isNotEmpty) {
      final doc = querySnapshot.docs.first;
      await doc.reference.update({"location_enabled": enable});
    }
  }

  Future<bool> isMember(String spaceId, String userId) async {
    final querySnapshot =
        await spaceMemberRef(spaceId).where("user_id", isEqualTo: userId).get();
    return querySnapshot.docs.isNotEmpty;
  }

  Future<void> deleteMembers(String spaceId) async {
    final querySnapshot = await spaceMemberRef(spaceId).get();
    for (final doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> deleteSpace(String spaceId) async {
    await deleteMembers(spaceId);
    await _spaceRef.doc(spaceId).delete();
  }

  Future<void> removeUserFromSpace(String spaceId, String userId) async {
    final querySnapshot =
        await spaceMemberRef(spaceId).where("user_id", isEqualTo: userId).get();

    for (final doc in querySnapshot.docs) {
      await doc.reference.delete();
    }

    final docRef = spaceGroupKeysDocRef(spaceId);
    await docRef.update({
      "doc_updated_at": DateTime.now().millisecondsSinceEpoch,
      "member_keys.$userId": FieldValue.delete()
    });
  }

  Future<void> updateSpace(ApiSpace space) async {
    await _spaceRef.doc(space.id).set(space);
  }

  Future<void> _distributeSenderKeyToSpaceMembers(
      String spaceId, String userId) async {
    final spaceMembers = await getMembersBySpaceId(spaceId);
    final membersKeyData = await generateMemberKeyData(spaceId,
        senderUserId: userId,
        spaceMembers: spaceMembers,
        bufferedSenderKeyStore: bufferedSenderKeystore);

    await _updateGroupKeys(spaceId, userId, membersKeyData);
  }

  Future<void> _updateGroupKeys(
      String spaceId, String userId, ApiMemberKeyData membersKeyData) async {
    await _db.runTransaction((transaction) async {
      final groupKeysDocRef = spaceGroupKeysDocRef(spaceId);
      final snapshot = await transaction.get(groupKeysDocRef);

      final updatedAt = DateTime.now().millisecondsSinceEpoch;
      final data = snapshot.data() ?? ApiGroupKey(doc_updated_at: updatedAt);

      final oldMemberKeyData =
          data.member_keys[userId] ?? const ApiMemberKeyData();

      final newMemberKeyData = oldMemberKeyData.copyWith(
        member_device_id: membersKeyData.member_device_id,
        data_updated_at: updatedAt,
        distributions: membersKeyData.distributions,
      );

      final updates = {
        'member_keys.$userId': newMemberKeyData.toJson(),
        'doc_updated_at': DateTime.now().millisecondsSinceEpoch,
      };

      transaction.update(groupKeysDocRef, updates);
    });
  }
}
