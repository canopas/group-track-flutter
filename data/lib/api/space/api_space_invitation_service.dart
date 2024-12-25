import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/api/space/space_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/client.dart';

final apiSpaceInvitationServiceProvider = StateProvider(
    (ref) => ApiSpaceInvitationService(ref.read(firestoreProvider)));

class ApiSpaceInvitationService {
  final FirebaseFirestore _db;

  ApiSpaceInvitationService(this._db);

  CollectionReference get _spaceRef =>
      _db.collection("space_invitations").withConverter<ApiSpaceInvitation>(
          fromFirestore: ApiSpaceInvitation.fromFireStore,
          toFirestore: (space, options) => space.toJson());

  Future<String> createInvitation(String spaceId) async {
    String invitationCode = generateInvitationCode();
    DocumentReference docRef = _spaceRef.doc();
    ApiSpaceInvitation invitation = ApiSpaceInvitation(
      id: docRef.id,
      space_id: spaceId,
      code: invitationCode,
      created_at: DateTime.now().millisecondsSinceEpoch,
    );

    await docRef.set(invitation);
    return invitationCode;
  }

  String generateInvitationCode() {
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    final code = List.generate(
        6, (index) => characters[random.nextInt(characters.length)]).join();
    return code;
  }

  Future<ApiSpaceInvitation?> getSpaceInviteCode(String spaceId) async {
    final querySnapshot =
        await _spaceRef.where("space_id", isEqualTo: spaceId).get();
    final docSnapshot = querySnapshot.docs.firstOrNull;
    if (docSnapshot!.exists) {
      return docSnapshot.data() as ApiSpaceInvitation;
    }
    return null;
  }

  Future<ApiSpaceInvitation?> regenerateInvitationCode(String spaceId) async {
    final invitation = await getSpaceInviteCode(spaceId);
    if (invitation != null) {
      final newCode = generateInvitationCode();
      final docRef = _spaceRef.doc(invitation.id);
      final updatedInvitation = invitation.copyWith(
          code: newCode, created_at: DateTime.now().millisecondsSinceEpoch);
      await docRef.update(updatedInvitation.toJson());
      return updatedInvitation;
    }
    return null;
  }

  Future<ApiSpaceInvitation?> getInvitation(String inviteCode) async {
    final querySnapshot = await _spaceRef
        .where("code", isEqualTo: inviteCode.toUpperCase())
        .get();
    final docSnapshot = querySnapshot.docs.firstOrNull;
    if (docSnapshot?.exists ?? false) {
      return docSnapshot?.data() as ApiSpaceInvitation;
    }
    return null;
  }

  Future<void> deleteInvitations(String spaceId) async {
    final querySnapshot =
        await _spaceRef.where("space_id", isEqualTo: spaceId).get();
    for (final doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
  }
}
