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
import 'package:yourspace_flutter/ui/components/error_snakebar.dart';
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
  late SignInWithPhoneViewNotifier notifier;

  @override
  Widget build(BuildContext context) {
    notifier = ref.watch(signInWithPhoneStateProvider.notifier);

    _otpNap(context: context);
    _observeError();

    return AppPage(
      title: '',
      body: Builder(
        builder: (context) => _body(context),
      ),
    );
  }

  Widget _body(BuildContext context) {
    final state = ref.watch(signInWithPhoneStateProvider);
    final loading = ref
        .watch(signInWithPhoneStateProvider.select((value) => value.verifying));
    final enable = ref.watch(
      signInWithPhoneStateProvider.select((value) => value.enableNext),
    );

    return ListView(
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
          loading: loading,
          enable: enable,
          state: state,
        ),
        PrimaryButton(
          enabled: enable && !loading,
          progress: loading,
          context.l10n.common_next,
          onPressed: () => notifier.verifyPhone(),
        ),
      ],
    );
  }

  Widget _phoneInputField({
    required BuildContext context,
    required bool enable,
    required bool loading,
    required SignInWithPhoneState state,
  }) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: CupertinoTextField(
          controller: state.phoneController,
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

  void _observeError() {
    ref.listen(signInWithPhoneStateProvider.select((state) => state.error),
        (previous, next) {
      if (next != null) {
        showErrorSnackBar(context, next.toString());
      }
    });
  }

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
}
