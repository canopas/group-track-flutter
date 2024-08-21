import 'package:cloud_firestore/cloud_firestore.dart';

import '../api/auth/auth_models.dart';

class BatteryService {
  final FirebaseFirestore _db;

  const BatteryService(this._db);

  CollectionReference get _userRef =>
      _db.collection("users").withConverter<ApiUser>(
          fromFirestore: ApiUser.fromFireStore,
          toFirestore: (user, options) => user.toJson());

  Future<void> updateBatteryPct(String userId, int batteryPct) async {
    await _userRef.doc(userId).update({
      "battery_pct": batteryPct,
      "updated_at": DateTime.now().millisecondsSinceEpoch,
    });
  }
}
