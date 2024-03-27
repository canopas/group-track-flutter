import 'package:flutter/material.dart';
import 'package:style/extenstions/context_extenstions.dart';

class ControlButton extends StatelessWidget {
  final Function() onTop;
  final bool progress;
  final bool enabled;
  final IconData icon;

  const ControlButton(
      {super.key,
      required this.onTop,
      this.progress = true,
      this.enabled = true,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      onPressed: onTop,
      backgroundColor: context.colorScheme.surface,
      foregroundColor: context.colorScheme.primary,
      child: Icon(icon),
    );
  }
}
