import 'package:data/api/auth/auth_models.dart';
import 'package:data/log/logger.dart';
import 'package:data/service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

part 'sign_in_method_viewmodel.freezed.dart';

final googleSignInProvider = Provider<GoogleSignIn>((ref) {
  return GoogleSignIn();
});

final signInMethodsStateProvider = StateNotifierProvider.autoDispose<
    SignInMethodsScreenViewNotifier, SignInMethodsScreenState>((ref) {
  return SignInMethodsScreenViewNotifier(ref.read(googleSignInProvider),
      ref.read(authServiceProvider), FirebaseAuth.instance);
});

class SignInMethodsScreenViewNotifier
    extends StateNotifier<SignInMethodsScreenState> {
  final GoogleSignIn googleSignIn;
  final AuthService authService;
  final FirebaseAuth firebaseAuth;

  SignInMethodsScreenViewNotifier(
      this.googleSignIn, this.authService, this.firebaseAuth)
      : super(const SignInMethodsScreenState());

  Future<void> signInWithGoogle() async {
    try {
      state = state.copyWith(showGoogleLoading: true, error: null);
      final (userCredential, account) = await _getUserCredentialFromGoogle();
      if (userCredential != null) {
        final String userIdToken =
            await userCredential.user?.getIdToken() ?? '';
        final isNewUser = await authService.verifiedLogin(
            uid: userCredential.user?.uid ?? '',
            firebaseToken: userIdToken,
            email: account!.email,
            firstName:
                userCredential.additionalUserInfo?.profile?['given_name'],
            lastName:
                userCredential.additionalUserInfo?.profile?['family_name'],
            profileImg: account.photoUrl,
            authType: LOGIN_TYPE_GOOGLE);

        state = state.copyWith(
            showGoogleLoading: false,
            socialSignInCompleted: true,
            isNewUser: isNewUser);
      } else {
        state = state.copyWith(showGoogleLoading: false);
      }
    } catch (error, stack) {
      logger.e(
        'SignInMethodsScreenViewNotifier: error while sign in with google',
        error: error,
        stackTrace: stack,
      );
      state = state.copyWith(showGoogleLoading: false, error: error);
    }
  }

  Future<(UserCredential?, GoogleSignInAccount?)>
      _getUserCredentialFromGoogle() async {
    final signInAccount = await googleSignIn.signIn();
    if (signInAccount != null) {
      final signInAuthentication = await signInAccount.authentication;
      final auth = await FirebaseAuth.instance.signInWithCredential(
        GoogleAuthProvider.credential(
          accessToken: signInAuthentication.accessToken,
          idToken: signInAuthentication.idToken,
        ),
      );

      await googleSignIn.signOut();
      return (auth, signInAccount);
    }
    return (null, null);
  }

  Future<void> signInWithApple() async {
    try {
      state = state.copyWith(showAppleLoading: true, error: null);
      final (userCredential, firstName, lastName) =
          await _getUserCredentialFromApple();

      final String userIdToken = await userCredential.user?.getIdToken() ?? '';

      final isNewUser = await authService.verifiedLogin(
        uid: userCredential.user?.uid ?? '',
        firebaseToken: userIdToken,
        firstName: firstName,
        lastName: lastName,
        authType: 3,
      );
      state = state.copyWith(
          showAppleLoading: false,
          socialSignInCompleted: true,
          isNewUser: isNewUser);
    } catch (error, stack) {
      state =
          state.copyWith(showAppleLoading: false, socialSignInCompleted: false);
      logger.e(
        'SignInMethodScreenViewNotifier: error while sign in with apple',
        error: error,
        stackTrace: stack,
      );
    }
  }

  Future<(UserCredential, String?, String?)>
      _getUserCredentialFromApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ]);
      final user = await firebaseAuth.signInWithCredential(
        OAuthProvider('apple.com').credential(
          idToken: credential.identityToken,
          accessToken: credential.authorizationCode,
        ),
      );
      return (user, credential.givenName, credential.familyName);
    } catch (error) {
      logger.e('Error during Apple sign-in', error: error);
      rethrow;
    }
  }
}

@freezed
abstract class SignInMethodsScreenState with _$SignInMethodsScreenState {
  const factory SignInMethodsScreenState({
    @Default(false) bool showAppleLoading,
    @Default(false) bool showGoogleLoading,
    @Default(false) socialSignInCompleted,
    @Default(false) bool isNewUser,
    Object? error,
  }) = _SignInMethodsScreenState;
}
