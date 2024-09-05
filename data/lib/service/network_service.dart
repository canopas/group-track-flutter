import 'package:cloud_firestore/cloud_firestore.dart';

import '../api/auth/auth_models.dart';
import '../log/logger.dart';

class NetworkService {
  final FirebaseFirestore _db;

  const NetworkService(this._db);

  CollectionReference get _userRef =>
      _db.collection("users").withConverter<ApiUser>(
          fromFirestore: ApiUser.fromFireStore,
          toFirestore: (user, options) => user.toJson());

  Future<void> _updateUserState(String id, int state) async {
    await _userRef.doc(id).update({
      "state": state,
      "updated_at": DateTime.now().millisecondsSinceEpoch,
    });
  }

  void updateUserNetworkState(String id) async {
    if (id.isNotEmpty) {
      _updateUserState(id, USER_STATE_ONLINE);
    } else {
      logger.e("NetworkService: Error while update user network state");
    }
  }
}
