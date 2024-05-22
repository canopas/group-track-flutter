import 'package:data/api/auth/api_user_service.dart';
import 'package:data/api/auth/auth_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../storage/app_preferences.dart';

final authServiceProvider = Provider((ref) => AuthService(
    ref.read(currentUserPod),
    ref.read(apiUserServiceProvider),
    ref.read(currentUserJsonPod.notifier),
    ref.read(currentUserSessionJsonPod.notifier)));

class AuthService {
  final ApiUser? _currentUser;
  final ApiUserService _userService;
  final StateController<String?> userJsonNotifier;
  final StateController<String?> userSessionJsonNotifier;

  AuthService(this._currentUser, this._userService, this.userJsonNotifier,
      this.userSessionJsonNotifier);

  ApiUser? get currentUser => _currentUser;

  Future<bool> verifiedLogin(
      {String? uid,
      String? firebaseToken,
      String? phone,
      String? email,
      String? firstName,
      String? lastName,
      String? profileImg,
      int authType = LOGIN_TYPE_PHONE}) async {
    final data = await _userService.saveUser(
        uid: uid,
        firebaseToken: firebaseToken,
        phone: phone,
        email: email,
        firstName: firstName,
        lastName: lastName,
        profileImage: profileImg,
        authType: authType);
    userJsonNotifier.state = (data['user'] as ApiUser).toJsonString();
    userSessionJsonNotifier.state =
        (data['session'] as ApiSession).toJsonString();

    return data['isNewUser'] as bool;
  }

  Future<void> updateCurrentUser(ApiUser user) async {
    await _userService.updateUser(user);
    userJsonNotifier.state = user.toJsonString();
  }
}
