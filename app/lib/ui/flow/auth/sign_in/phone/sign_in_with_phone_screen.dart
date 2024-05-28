import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:style/button/primary_button.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/text/app_text_dart.dart';
import 'package:yourspace_flutter/domain/extenstions/context_extenstions.dart';
import 'package:yourspace_flutter/ui/components/app_logo.dart';
import 'package:yourspace_flutter/ui/components/app_page.dart';
import 'package:yourspace_flutter/ui/flow/auth/sign_in/phone/sign_in_with_phone_view_model.dart';

import '../../../../app_route.dart';
import 'components/sign_in_with_phone_country_picker_field.dart';

class SignInWithPhoneScreen extends ConsumerStatefulWidget {
  const SignInWithPhoneScreen({super.key});

  @override
  ConsumerState<SignInWithPhoneScreen> createState() =>
      _SignInWithPhoneScreenState();
}

class _SignInWithPhoneScreenState extends ConsumerState<SignInWithPhoneScreen> {
  final TextEditingController _phoneController = TextEditingController();

  void _otpNap({required BuildContext context}) {
    ref.listen(
      signInWithPhoneStateProvider.select((value) => value.verificationId),
      (previous, current) async {
        if (current != null) {
          final state = ref.read(signInWithPhoneStateProvider);

          final List<bool> data = await AppRoute.otpVerification(
                phoneNumber: state.code.dialCode + state.phone,
                verificationId: current,
              ).push(context) ??
              List.empty();

          if (data.isNotEmpty && data.first == true && context.mounted) {
            context.pop(data);
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(signInWithPhoneStateProvider.notifier);
    final loading = ref
        .watch(signInWithPhoneStateProvider.select((value) => value.verifying));
    final enable = ref.watch(
      signInWithPhoneStateProvider.select((value) => value.enableNext),
    );

    _otpNap(context: context);

    return AppPage(
        title: '',
        body: Builder(
            builder: (context) => ListView(
                  padding: const EdgeInsets.symmetric(
                    vertical: 40,
                    horizontal: 16,
                  ),
                  children: [
                    const AppLogo(),
                    const SizedBox(height: 80),
                    Text(
                      context.l10n.sign_in_with_phone_enter_phone_number_title,
                      style: AppTextStyle.header1.copyWith(
                        color: context.colorScheme.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        context
                            .l10n.sign_in_with_phone_verification_description,
                        style: AppTextStyle.subtitle2
                            .copyWith(color: context.colorScheme.textDisabled),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    _phoneInputField(
                      context: context,
                      notifier: notifier,
                      loading: loading,
                      enable: enable,
                    ),
                    PrimaryButton(
                      enabled: enable && !loading,
                      progress: loading,
                      context.l10n.common_next,
                      onPressed: notifier.verifyPhone,
                    ),
                  ],
                )));
  }

  Widget _phoneInputField({
    required BuildContext context,
    required bool enable,
    required bool loading,
    required SignInWithPhoneViewNotifier notifier,
  }) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: CupertinoTextField(
          controller: _phoneController,
          onChanged: (phone) => notifier.onPhoneChange(phone),
          keyboardType: TextInputType.phone,
          onSubmitted: (value) {
            if (!loading && enable) notifier.verifyPhone();
          },
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
          ],
          style: AppTextStyle.subtitle1.copyWith(
            color: context.colorScheme.textPrimary,
          ),
          placeholderStyle: AppTextStyle.subtitle1.copyWith(
            color: context.colorScheme.textDisabled,
          ),
          placeholder: context.l10n.sign_in_with_phone_phone_number_hint,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: context.colorScheme.outline),
            borderRadius: BorderRadius.circular(16),
          ),
          prefix: const SignInWithPhoneCountryPicker(),
        ));
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
}
