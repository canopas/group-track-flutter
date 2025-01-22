// ignore_for_file: constant_identifier_names

import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:data/api/auth/api_user_service.dart';
import 'package:data/api/auth/auth_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';
import '../utils/private_key_helper.dart';
import '../log/logger.dart';
import '../storage/app_preferences.dart';

const NETWORK_STATUS_CHECK_INTERVAL = 5 * 60 * 1000;

final authServiceProvider = Provider((ref) {
  final provider = AuthService(
      ref.read(currentUserPod),
      ref.read(apiUserServiceProvider),
      ref.read(currentUserJsonPod.notifier),
      ref.read(currentUserSessionJsonPod.notifier),
      ref.read(userPassKeyPod.notifier));

  ref.listen(currentUserPod, (prev, user) {
    provider._onUpdateUser(prevUser: prev, currentUser: user);
  });

  return provider;
});

class AuthService {
  ApiUser? _currentUser;
  final ApiUserService userService;
  final StateController<String?> userJsonNotifier;
  final StateController<String?> userSessionJsonNotifier;
  final StateController<String?> userPassKeyNotifier;

  AuthService(this._currentUser, this.userService, this.userJsonNotifier,
      this.userSessionJsonNotifier, this.userPassKeyNotifier);

  ApiUser? get currentUser => _currentUser;

  Future<bool> verifiedLogin(
      {required String uid,
      String? firebaseToken,
      String? phone,
      String? email,
      String? firstName,
      String? lastName,
      String? profileImg,
      int authType = LOGIN_TYPE_GOOGLE}) async {
    final data = await userService.saveUser(
      uid: uid,
      firebaseToken: firebaseToken,
      phone: phone,
      email: email,
      firstName: firstName,
      lastName: lastName,
      profileImage: profileImg,
      authType: authType,
    );
    _currentUser = data['user'] as ApiUser;
    userJsonNotifier.state = _currentUser!.toJsonString();
    userSessionJsonNotifier.state =
        (data['session'] as ApiSession).toJsonString();

    final isNewUser = data['isNewUser'] as bool;
    if (isNewUser) await generateAndSaveUserKeys("1111");
    return isNewUser;
  }

  Future<void> updateUserName(
      {required String firstName, String? lastName}) async {
    final user =
        currentUser?.copyWith(first_name: firstName, last_name: lastName);
    if (user == null) {
      throw Exception("No user logged in");
    }

    await userService.updateUserName(user.id,
        firstName: firstName, lastName: lastName);

    userJsonNotifier.state = user.toJsonString();
  }

  void saveUser(ApiUser? user) {
    userJsonNotifier.state = user?.toJsonString();
  }

  void _onUpdateUser({ApiUser? prevUser, ApiUser? currentUser}) {
    _currentUser = currentUser;
  }

  Future<void> updateCurrentUser(ApiUser user) async {
    await userService.updateUser(user);
    saveUserState(user);
  }

  void saveUserState(ApiUser user) {
    userJsonNotifier.state = user.toJsonString();
  }

  Future<ApiUser?> getUser(String userId) {
    return userService.getUser(userId);
  }

  Stream<ApiUser?> getUserStream({required String currentUserId}) {
    return userService.getUserStream(currentUserId);
  }

  Future<void> deleteAccount({required String currentUserId}) async {
    userService.clearPreference();
    await userService.deleteUser(currentUserId);
  }

  Future<void> requestUserStatUpdates(
      String userId, void Function(ApiUser?) onStatusChecked,
      {int? lastUpdatedTime}) async {
    final data = {"userId": userId};

    final currentTime = DateTime.now().millisecondsSinceEpoch;
    if (lastUpdatedTime != null &&
        currentTime - lastUpdatedTime < NETWORK_STATUS_CHECK_INTERVAL) {
      logger.d(
          "User status update requested too soon. Skipping call for $userId.");
      return;
    }

    final callable = FirebaseFunctions.instanceFor(region: 'asia-south1')
        .httpsCallable('networkStatusCheck');
    await callable.call(data).whenComplete(() async {
      final user = await getUser(userId);
      onStatusChecked(user);
    });
  }

  Future<void> generateAndSaveUserKeys(String passKey) async {
    final user = currentUser;
    if (user == null) {
      throw Exception("No user logged in");
    }

    final updatedUser = await _generateAndSaveUserKeys(user, passKey);
    userJsonNotifier.state = updatedUser.toJsonString();
  }

  Future<ApiUser> _generateAndSaveUserKeys(ApiUser user, String passKey) async {
    final identityKeyPair = generateIdentityKeyPair();
    final salt = Uint8List.fromList(List.generate(16, (_) => Random.secure().nextInt(256)));
    print("XXX _generateAndSaveUserKeys encryptedPrivateKey ${identityKeyPair.getPrivateKey().serialize().length}");
    final encryptedPrivateKey = await encryptPrivateKey(
      identityKeyPair.getPrivateKey().serialize(),
      passKey,
      salt,
    );

    final publicKey =
       identityKeyPair.getPublicKey().publicKey.serialize();
    final privateKey = encryptedPrivateKey;
    final saltBlob = salt;

    // Store passkey in preferences
    userPassKeyNotifier.state = passKey;
    await userService.updateKeys(
      user.id,
      publicKey,
      privateKey,
      saltBlob,
    );

    return user.copyWith(
      updated_at: DateTime.now().millisecondsSinceEpoch,
      identity_key_public: publicKey,
      identity_key_private: privateKey,
      identity_key_salt: saltBlob,
    );
  }
}
