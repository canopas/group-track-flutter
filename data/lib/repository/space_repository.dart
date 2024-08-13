import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/api/space/space_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/network/client.dart';

final spaceRepositoryProvider = Provider((ref) => SpaceRepository(
    ref.read(firestoreProvider)
));

class SpaceRepository {
  final FirebaseFirestore _db;

  SpaceRepository(this._db);

  CollectionReference get _spaceRef =>
      _db.collection("spaces").withConverter<ApiSpace>(
          fromFirestore: ApiSpace.fromFireStore,
          toFirestore: (space, options) => space.toJson());

  Future<List<ApiSpaceMember>> _getSpaceMemberByUserId(String userId) async {
    final querySnapshot = await _spaceRef.firestore
        .collectionGroup('space_members')
        .where("user_id", isEqualTo: userId)
        .get();

    return querySnapshot.docs
        .map((doc) => ApiSpaceMember.fromJson(doc.data()))
        .toList();
  }

  Future<ApiSpace?> _getSpace(String spaceId) async {
    final docSnapshot = await _spaceRef.doc(spaceId).get();
    if (docSnapshot.exists) {
      return docSnapshot.data() as ApiSpace;
    }
    return null;
  }

  Future<List<ApiSpace?>> getUserSpaces(String userId) async {
    final spaceMembers = await _getSpaceMemberByUserId(userId);
    final spaces = await Future.wait(spaceMembers.map((spaceMember) async {
      final spaceId = spaceMember.space_id;
      final space = await _getSpace(spaceId);
      return space;
    }).toList());
    return spaces;
  }
}
