import 'package:flutter/material.dart';
import 'package:style/extenstions/context_extenstions.dart';

import '../animation/on_tap_scale.dart';
import '../text/app_text_dart.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final EdgeInsets edgeInsets;
  final bool expanded;
  final Function()? onPressed;

  const SecondaryButton(this.text, {
    super.key,
    this.onPressed,
    this.edgeInsets =
    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    return OnTapScale(
      onTap: () {
        onPressed?.call();
      },
      child: Container(
        width: expanded ? double.infinity : null,
        constraints: BoxConstraints(
          minHeight: expanded ? 48 : 36,
          minWidth: 88,
        ),
        padding: edgeInsets,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: context.colorScheme.primary),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: AppTextStyle.button.copyWith(
                color: context.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
