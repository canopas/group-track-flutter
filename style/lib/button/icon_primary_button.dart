import 'package:flutter/material.dart';
import 'package:style/extenstions/context_extenstions.dart';

class IconPrimaryButton extends StatelessWidget {
  final Function() onTap;
  final bool progress;
  final bool enabled;
  final Widget icon;
  final double size;
  final double radius;
  final Color? bgColor;

  const IconPrimaryButton({
    super.key,
    required this.onTap,
    this.progress = true,
    this.enabled = true,
    required this.icon,
    this.bgColor,
    this.size = 40.0,
    this.radius = 30,
  });

  @override
  Widget build(BuildContext context) {
    final bg = bgColor ?? context.colorScheme.containerLow;

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
