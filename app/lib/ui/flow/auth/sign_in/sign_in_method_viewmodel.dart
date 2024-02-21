import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'sign_in_method_viewmodel.freezed.dart';

final googleSignInProvider = Provider<GoogleSignIn>((ref) {
  return GoogleSignIn();
});

final signInMethodsStateProvider = StateNotifierProvider.autoDispose<
    SignInMethodsScreenViewNotifier, SignInMethodsScreenState>((ref) {
  return SignInMethodsScreenViewNotifier(ref.read(googleSignInProvider));
});

class SignInMethodsScreenViewNotifier
    extends StateNotifier<SignInMethodsScreenState> {
  final GoogleSignIn googleSignIn;

  SignInMethodsScreenViewNotifier(this.googleSignIn)
      : super(const SignInMethodsScreenState());

  Future<void> signInWithGoogle() async {
    try {
      state = state.copyWith(showGoogleLoading: true, error: null);
      final userCredential = await _getUserCredentialFromGoogle();
      if (userCredential != null) {
        final String userIdToken =
            await userCredential.user?.getIdToken() ?? '';
      }
    } catch (e, stack) {
      state = state.copyWith(showGoogleLoading: false, error: e);
    }
  }

  signInWithPhone() {}

  Future<UserCredential?> _getUserCredentialFromGoogle() async {
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
      return auth;
    }
    return null;
  }
}

@freezed
abstract class SignInMethodsScreenState with _$SignInMethodsScreenState {
  const factory SignInMethodsScreenState({
    @Default(false) bool showAppleLoading,
    @Default(false) bool showGoogleLoading,
    @Default(false) socialSignInCompleted,
    Object? error,
  }) = _SignInMethodsScreenState;
}
