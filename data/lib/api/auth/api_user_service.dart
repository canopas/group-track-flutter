import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/api/network/client.dart';
import 'package:data/service/device/device_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_models.dart';

final apiUserServiceProvider = StateProvider((ref) => ApiUserService(
    ref.read(firestoreProvider), ref.read(deviceServiceProvider)));

class ApiUserService {
  final FirebaseFirestore _db;
  final DeviceService _device;

  ApiUserService(this._db, this._device);

  CollectionReference get _userRef =>
      _db.collection("users").withConverter<ApiUser>(
          fromFirestore: ApiUser.fromFireStore,
          toFirestore: (user, options) => user.toJson());

  CollectionReference sessionRef(String userId) => _userRef
      .doc(userId)
      .collection("user_sessions")
      .withConverter<ApiSession>(
          fromFirestore: ApiSession.fromFireStore,
          toFirestore: (session, _) => session.toJson());

  Future<Map<String, dynamic>> saveUser({
    String? uid,
    String? firebaseToken,
    String? phone,
    String? email,
    String? firstName,
    String? lastName,
    String? profileImage,
    int authType = LOGIN_TYPE_PHONE,
  }) async {
    final bool isExists = await getUser(uid) != null;

    if (isExists) {
      final sessionDocRef = sessionRef(uid!).doc();
      final ApiSession session = ApiSession(
        id: sessionDocRef.id,
        user_id: uid,
        device_id: _device.deviceId,
        device_name: await _device.deviceName,
        session_active: true,
        app_version: await _device.appVersion,
        created_at: DateTime.now().millisecondsSinceEpoch,
      );
      await deactivateOldSessions(uid);
      await sessionDocRef.set(session);
      final user = await getUser(uid);
      return {'isNewUser': false, 'user': user, 'session': session};
    } else {
      final ApiUser user = ApiUser(
        id: uid!,
        email: email ?? '',
        phone: phone ?? '',
        auth_type: authType,
        first_name: firstName ?? '',
        last_name: '',
        provider_firebase_id_token: firebaseToken ?? '',
        profile_image: '',
        created_at: DateTime.now().millisecondsSinceEpoch,
      );

      await _userRef.doc(uid).set(user);
      final sessionDocRef = sessionRef(uid).doc();
      final ApiSession session = ApiSession(
        id: sessionDocRef.id,
        user_id: uid,
        device_id: _device.deviceId,
        device_name: await _device.deviceName,
        session_active: true,
        app_version: await _device.appVersion,
        created_at: DateTime.now().millisecondsSinceEpoch,
      );
      await sessionDocRef.set(session);
      //  await _locationService.saveLastKnownLocation(uid);
      return {'isNewUser': true, 'user': user, 'session': session};
    }
  }

  Future<ApiUser?> getUser(String? userId) async {
    if (userId == null) return null;
    var snapshot = await _userRef.doc(userId).get();
    if (snapshot.exists) {
      return snapshot.data() as ApiUser;
    }
    return null;
  }

  Future<void> deactivateOldSessions(String userId) async {
    final querySnapshot =
        await sessionRef(userId).where("session_active", isEqualTo: true).get();
    for (var doc in querySnapshot.docs) {
      await doc.reference.update({"session_active": false});
    }
  }

  Future<void> updateUser(ApiUser user) async {
    await _userRef.doc(user.id).set(user);
  }
}
