import 'package:flutter/material.dart';
import 'package:style/extenstions/context_extenstions.dart';

class IconPrimaryButton extends StatelessWidget {
  final Function() onTap;
  final bool progress;
  final bool enabled;
  final Widget icon;
  final Color? iconColor;
  final double size;
  final double radius;

  const IconPrimaryButton({
    super.key,
    required this.onTap,
    this.progress = true,
    this.enabled = true,
    required this.icon,
    this.iconColor,
    this.size = 40.0,
    this.radius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: context.colorScheme.containerLowOnSurface,
          borderRadius: BorderRadius.circular(radius),
        ),
        padding: const EdgeInsets.all(8),
        child: icon,
      ),
    );
  }
}
