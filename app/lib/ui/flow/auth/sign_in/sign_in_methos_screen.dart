import 'package:data/storage/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:yourspace_flutter/domain/extenstions/context_extenstions.dart';
import 'package:yourspace_flutter/ui/components/app_logo.dart';
import 'package:yourspace_flutter/ui/components/app_page.dart';
import 'package:yourspace_flutter/ui/flow/auth/sign_in/sign_in_method_viewmodel.dart';

import '../../../../gen/assets.gen.dart';
import '../../../app_route.dart';
import 'component/sign_in_method_button.dart';

class SignInMethodScreen extends ConsumerStatefulWidget {
  const SignInMethodScreen({super.key});

  @override
  ConsumerState<SignInMethodScreen> createState() => _SignInMethodScreenState();
}

class _SignInMethodScreenState extends ConsumerState<SignInMethodScreen> {
  late SignInMethodsScreenViewNotifier notifier;

  @override
  void initState() {
    notifier = ref.read(signInMethodsStateProvider.notifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bgDecoration = BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          context.colorScheme.primary.withOpacity(0),
          context.colorScheme.primary.withOpacity(0.02),
          context.colorScheme.primary.withOpacity(0.12),
          context.colorScheme.primary.withOpacity(0.02),
          context.colorScheme.primary.withOpacity(0),
        ],
      ),
    );

    return AppPage(
        title: '',
        body: Container(
          decoration: bgDecoration,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
            child: Column(
              children: [
                const AppLogo(),
                const Spacer(),
                _googleSignInButton(),
                _phoneSignInButton(),
                const Spacer(),
              ],
            ),
          ),
        ));
  }

  Widget _googleSignInButton() => Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: SignInMethodButton(
        onTap: () => notifier.signInWithGoogle(),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        icon: SvgPicture.asset(
          Assets.images.icGoogleLogo,
          height: 20,
        ),
        title: context.l10n.sign_in_options_continue_with_google_btn_title,
        isLoading: ref.watch(signInMethodsStateProvider
            .select((value) => value.showGoogleLoading)),
      ));

  Widget _phoneSignInButton() => Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: SignInMethodButton(
        onTap: () async {
          final isGoogleLoading = ref.read(signInMethodsStateProvider
              .select((value) => value.showGoogleLoading));
          if (isGoogleLoading) return;
          final bool? success = await AppRoute.signInWithPhone.push(context);
          if (success == true && context.mounted) onSignInSuccess();
        },
        title: context.l10n.sign_in_options_continue_with_phone_btn_title,
        //  isLoading: ref.watch(signInMethodsStateProvider.select((value) => value.aho)),
      ));

  void onSignInSuccess() async {
    final user = ref.read(currentUserPod);
    if (user?.first_name == null || user!.first_name!.isEmpty) {
      await AppRoute.pickName.push(context);
    }
    if (mounted) context.pop(true);
  }
}
