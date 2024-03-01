import 'package:flutter/cupertino.dart';
import 'package:style/animation/on_tap_scale.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/indicator/progress_indicator.dart';
import 'package:style/text/app_text_dart.dart';

class SignInMethodButton extends StatelessWidget {
  final Function()? onTap;
  final String title;
  final bool isLoading;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const SignInMethodButton({
    super.key,
    this.onTap,
    this.backgroundColor,
    this.foregroundColor,
    required this.title,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return OnTapScale(
      onTap: onTap,
      enabled: onTap != null && !isLoading,
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 48),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: backgroundColor ?? context.colorScheme.primary,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Visibility(
          visible: isLoading,
          replacement: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon ?? const SizedBox(),
              Visibility(
                visible: icon != null,
                child: const SizedBox(width: 8),
              ),
              Text(
                title,
                style: AppTextStyle.button.copyWith(
                  color: foregroundColor ?? context.colorScheme.onPrimary,
                ),
              ),
            ],
          ),
          child: AppProgressIndicator(
            color: foregroundColor,
            size: AppProgressIndicatorSize.small,
          ),
        ),
      ),
    );
  }
}
