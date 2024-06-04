import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:style/animation/on_tap_scale.dart';
import 'package:style/button/primary_button.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/text/app_text_dart.dart';
import 'package:yourspace_flutter/domain/extenstions/context_extenstions.dart';
import 'package:yourspace_flutter/domain/extenstions/widget_extensions.dart';
import 'package:yourspace_flutter/ui/components/app_page.dart';
import 'package:yourspace_flutter/ui/components/error_snakebar.dart';
import 'package:yourspace_flutter/ui/flow/auth/sign_in/phone/verification/phone_verification_view_model.dart';

import '../../../../../components/app_logo.dart';

class PhoneVerificationScreen extends ConsumerStatefulWidget {
  final String phoneNumber;
  final String verificationId;

  const PhoneVerificationScreen(this.phoneNumber, this.verificationId,
      {super.key});

  @override
  ConsumerState<PhoneVerificationScreen> createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState
    extends ConsumerState<PhoneVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  late PhoneVerificationViewNotifier notifier;

  @override
  void initState() {
    notifier = ref.read(phoneVerificationStateProvider.notifier);
    runPostFrame(() => notifier.updatePhoneAndVerificationId(
        verificationId: widget.verificationId, phone: widget.phoneNumber));
    super.initState();
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(phoneVerificationStateProvider);

    final duration = ref.watch(
      phoneVerificationStateProvider
          .select((value) => value.activeResendDuration),
    );

    _navBackAfterVerification();
    _observeError();

    return AppPage(
        title: '',
        body: Builder(
            builder: (context) => ListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 60),
                  children: [
                    const AppLogo(),
                    const SizedBox(height: 80),
                    Text(
                      context.l10n.otp_verification_verification_code_title,
                      style: AppTextStyle.header1.copyWith(
                        color: context.colorScheme.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        context.l10n.otp_verification_description,
                        style: AppTextStyle.subtitle2
                            .copyWith(color: context.colorScheme.textDisabled),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _otpField(),
                    PrimaryButton(
                      context.l10n.common_verify,
                      progress: state.verifying,
                      onPressed: notifier.verifyOtp,
                    ),
                    const SizedBox(height: 8),
                    _phoneVerificationResendCodeView(
                        phoneNumber: widget.phoneNumber, duration: duration),
                  ],
                )));
  }

  Widget _phoneVerificationResendCodeView(
      {required String phoneNumber, required Duration duration}) {
    final activeResendCodeBtn = duration.inSeconds < 1;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OnTapScale(
          enabled: activeResendCodeBtn,
          onTap: () async {
            await notifier.resendOtp(phone: phoneNumber);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              context.l10n.otp_verification_resend_code_title,
              style: AppTextStyle.body2.copyWith(
                color: activeResendCodeBtn
                    ? context.colorScheme.primary
                    : Color.alphaBlend(
                        context.colorScheme.primary.withOpacity(0.5),
                        context.colorScheme.surface,
                      ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 2),
        Visibility(
          visible: !activeResendCodeBtn,
          child: Text(
            '00:${duration.inSeconds.toString().padLeft(2, '0')}',
            style: AppTextStyle.body2.copyWith(
              color: context.colorScheme.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _otpField() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: SizedBox(
            width: 200,
            child: CupertinoTextField(
              controller: _otpController,
              onChanged: notifier.updateOTP,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              style: AppTextStyle.header1.copyWith(
                letterSpacing: 8,
                fontSize: 34,
                color: context.colorScheme.textPrimary,
              ),
              maxLength: 6,
              textAlign: TextAlign.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: context.colorScheme.containerNormal,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  void _navBackAfterVerification() {
    ref.listen(
        phoneVerificationStateProvider
            .select((value) => value.verificationSucceed), (previous, next) {
      if (next) {
        context.pop([true, ref.read(phoneVerificationStateProvider).isNewUser]);
      }
    });
  }

  void _observeError() {
    ref.listen(phoneVerificationStateProvider.select((state) => state.error), (previous, next) {
      if (next != null) {
        showErrorSnackBar(context, next.toString());
      }
    });
  }
}
