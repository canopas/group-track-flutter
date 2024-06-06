import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void showErrorSnackBar(BuildContext context, Object error) {
  HapticFeedback.mediumImpact();
  showSnackBar(context, error.toString(), length: SnackBarLength.long);
}

void showSnackBar(
  BuildContext context,
  String text, {
  SnackBarLength length = SnackBarLength.short,
}) {
  final snackBar = SnackBar(
    content: Text(text),
    behavior: SnackBarBehavior.floating,
    duration: Duration(seconds: length.seconds),
  );
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

enum SnackBarLength {
  short(1),
  long(2);

  final int seconds;

  const SnackBarLength(this.seconds);
}

