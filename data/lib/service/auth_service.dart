// ignore_for_file: constant_identifier_names

import 'package:cloud_functions/cloud_functions.dart';
import 'package:data/api/auth/api_user_service.dart';
import 'package:data/api/auth/auth_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../log/logger.dart';
import '../storage/app_preferences.dart';

const NETWORK_STATUS_CHECK_INTERVAL = 3 * 60 * 1000;

final authServiceProvider = Provider((ref) => AuthService(
    ref.read(currentUserPod),
    ref.read(apiUserServiceProvider),
    ref.read(currentUserJsonPod.notifier),
    ref.read(currentUserSessionJsonPod.notifier)));

class AuthService {
  final ApiUser? _currentUser;
  final ApiUserService userService;
  final StateController<String?> userJsonNotifier;
  final StateController<String?> userSessionJsonNotifier;

  AuthService(this._currentUser, this.userService, this.userJsonNotifier,
      this.userSessionJsonNotifier);

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
    userJsonNotifier.state = (data['user'] as ApiUser).toJsonString();
    userSessionJsonNotifier.state =
        (data['session'] as ApiSession).toJsonString();

    return data['isNewUser'] as bool;
  }

  Future<void> updateCurrentUser(ApiUser user) async {
    await userService.updateUser(user);
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
}
