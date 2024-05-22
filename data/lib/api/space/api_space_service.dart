import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/api/network/client.dart';
import 'package:data/api/space/space_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiSpaceServiceProvider =
    StateProvider((ref) => ApiSpaceService(ref.read(firestoreProvider)));

class ApiSpaceService {
  final FirebaseFirestore _db;

  ApiSpaceService(this._db);

  CollectionReference get _spaceRef =>
      _db.collection("spaces").withConverter<ApiSpace>(
          fromFirestore: ApiSpace.fromFireStore,
          toFirestore: (space, options) => space.toJson());

  Future<String> createSpace(String admin_id, String name) async {
    final doc = _spaceRef.doc();
    final space = ApiSpace(id: doc.id, admin_id: admin_id, name: name);
    await doc.set(space);
    joinSpace(admin_id, doc.id);
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
