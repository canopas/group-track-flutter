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

  Future<ApiUser?> getUser(String? userId) async {
    if (userId == null) return null;
    var snapshot = await _userRef.doc(userId).get();
    if (snapshot.exists) {
      return snapshot.data() as ApiUser;
    }
    return null;
  }

  void updateUserNetworkState(Map<String, dynamic> data, String id) async {
    if (id.isNotEmpty) {
      _updateUserState(id, USER_STATE_ONLINE);
      final user = await getUser(id);
      print('user updates state === ${user?.state} - user name - ${user?.first_name}');
    } else {
      logger.e("Unable to update user network state");
    }
  }
}
