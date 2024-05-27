import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/api/network/client.dart';
import 'package:data/api/space/api_space_invitation_service/space_invitation_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiSpaceInvitationServiceProvider = StateProvider(
    (ref) => ApiSpaceInvitationService(ref.read(firestoreProvider)));

class ApiSpaceInvitationService {
  final FirebaseFirestore _db;

  ApiSpaceInvitationService(this._db);

  CollectionReference get _spaceRef => _db.collection("space_invitations");

  Future<String> createInvitation(String spaceId) async {
    String invitationCode = generateInvitationCode();
    DocumentReference docRef = _spaceRef.doc();
    ApiSpaceInvitation invitation = ApiSpaceInvitation(
      id: docRef.id,
      space_id: spaceId,
      code: invitationCode,
    );

    await docRef.set(invitation);
    print(invitationCode);
    return invitationCode;
  }

  String generateInvitationCode() {
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    final code =  List.generate(
        6, (index) => characters[random.nextInt(characters.length)]).join();
    print(code);
    return code;
  }
}
