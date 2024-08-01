import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../indicator/progress_indicator.dart';

Widget actionButton({
  required BuildContext context,
  required void Function() onPressed,
  required Widget icon,
  bool progress = false,
  bool enabled = true,
  EdgeInsets padding = EdgeInsets.zero,
}) {
  final tappable = !progress && enabled;

  if (Platform.isIOS) {
    return CupertinoButton(
      onPressed: tappable ? onPressed : null,
      padding: padding,
      child: progress
          ? const AppProgressIndicator(size: AppProgressIndicatorSize.small)
          : icon,
    );
  } else {
    return IconButton(
      onPressed: tappable ? onPressed : null,
      icon: progress
          ? const AppProgressIndicator(size: AppProgressIndicatorSize.small)
          : icon,
      padding: padding,
    );
  }
}
