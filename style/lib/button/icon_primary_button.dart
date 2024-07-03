import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../theme/theme.dart';

class IconPrimaryButton extends StatelessWidget {
  final Function() onTap;
  final bool progress;
  final bool enabled;
  final Widget icon;
  final Color? iconColor;
  final double size;
  final double radius;
  final Color? bgColor;

  const IconPrimaryButton({
    super.key,
    required this.onTap,
    this.progress = true,
    this.enabled = true,
    required this.icon,
    this.iconColor,
    this.backgroundColor,
    this.size = 40.0,
    this.radius = 30,
  });

  @override
  Widget build(BuildContext context) {
    final AppColorScheme colorScheme = appColorSchemeOf(context);
    final bg = backgroundColor ?? colorScheme.containerLow;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(radius),
        ),
        padding: const EdgeInsets.all(8),
        child: icon,
      ),
    );
  }
}
