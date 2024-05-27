import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/api/network/client.dart';
import 'package:data/api/space/api_space_service/space_models.dart';
import 'package:data/storage/app_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/auth_models.dart';

final apiSpaceServiceProvider = StateProvider((ref) => ApiSpaceService(
      ref.read(firestoreProvider),
      ref.read(currentUserPod),
    ));

class ApiSpaceService {
  final FirebaseFirestore _db;
  final ApiUser? _currentUser;

  ApiSpaceService(this._db, this._currentUser);

  CollectionReference get _spaceRef =>
      _db.collection("spaces").withConverter<ApiSpace>(
          fromFirestore: ApiSpace.fromFireStore,
          toFirestore: (space, options) => space.toJson());

  Future<String> createSpace(String name) async {
    final doc = _spaceRef.doc();
    final adminId = _currentUser?.id ?? "";
    final space = ApiSpace(id: doc.id, admin_id: adminId, name: name);
    await doc.set(space);
    joinSpace(adminId, doc.id);
    return doc.id;
  }

  Future<ApiSpace?> getSpace(String spaceId) async {
    final docSnapshot = await _spaceRef.doc(spaceId).get();
    if (docSnapshot.exists) {
      return docSnapshot.data() as ApiSpace;
    }

    return null;
  }

  Future<void> joinSpace(String memberId, String spaceId) async {}
}
