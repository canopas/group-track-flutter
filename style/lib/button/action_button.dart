import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../indicator/progress_indicator.dart';

Widget actionButton(
    BuildContext context, {
      required void Function() onPressed,
      required Widget icon,
      bool progress = false,
      EdgeInsets padding = EdgeInsets.zero,
    }) {
  if (Platform.isIOS) {
    return CupertinoButton(
      onPressed: onPressed,
      padding: padding,
      child: progress
          ? const AppProgressIndicator(size: AppProgressIndicatorSize.small)
          : icon,
    );
  } else {
    return IconButton(
      onPressed: onPressed,
      icon: progress
          ? const AppProgressIndicator(size: AppProgressIndicatorSize.small)
          : icon,
      padding: padding,
    );
  }
}
