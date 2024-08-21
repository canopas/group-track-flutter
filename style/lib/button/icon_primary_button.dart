import 'package:flutter/material.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/indicator/progress_indicator.dart';

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
    this.progress = false,
    this.enabled = true,
    required this.icon,
    this.bgColor,
    this.size = 40.0,
    this.radius = 30,
  });

  @override
  Widget build(BuildContext context) {
    final bg = bgColor ?? context.colorScheme.containerLow;
    final tappable = !progress && enabled;

    return GestureDetector(
      onTap: tappable?onTap : null,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(radius),
        ),
        padding: const EdgeInsets.all(8),
        child: progress
            ? const AppProgressIndicator(
                size: AppProgressIndicatorSize.small,
              )
            : icon,
      ),
    );
  }
}
