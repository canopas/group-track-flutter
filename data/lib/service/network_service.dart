import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import '../api/auth/auth_models.dart';
import '../log/logger.dart';

class NetworkService {
  final FirebaseFirestore _db;

  const NetworkService(this._db);

  CollectionReference get _userRef =>
      _db.collection("users").withConverter<ApiUser>(
          fromFirestore: ApiUser.fromFireStore,
          toFirestore: (user, options) => user.toJson());

  void updateUserNetworkState(String id) async {
    if (id.isNotEmpty) {
      final userState = await checkUserState();

      await _userRef.doc(id).update({
        "state": userState,
        "updated_at": DateTime.now().millisecondsSinceEpoch,
      });
    } else {
      logger.e("NetworkService: Error while update user network state");
    }
  }

  Future<int> checkUserState() async {
    var result = await Connectivity().checkConnectivity();
    final isConnected = result.first == ConnectivityResult.mobile ||
        result.first == ConnectivityResult.wifi;
    final isLocationEnabled = await isLocationAlwaysEnabled();

    if (isConnected && isLocationEnabled) {
      return USER_STATE_ONLINE;
    } else if (!isLocationEnabled) {
      return USER_STATE_LOCATION_PERMISSION_DENIED;
    } else {
      return USER_STATE_NO_NETWORK_OR_PHONE_OFF;
    }
  }

  Future<bool> isLocationAlwaysEnabled() async {
    final isLocationEnable = await Permission.location.isGranted;
    final isBackgroundEnable = await Permission.locationAlways.isGranted;
    return (isLocationEnable && isBackgroundEnable);
  }
}
