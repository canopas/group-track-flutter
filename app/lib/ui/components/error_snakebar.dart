import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showErrorSnackBar(BuildContext context, Object error) {
  HapticFeedback.mediumImpact();
  showSnackBar(context, error.toString(), length: SnackBarLength.long);
}

void showSnackBar(
  BuildContext context,
  String text, {
  SnackBarLength length = SnackBarLength.short,
}) {
  if (Platform.isIOS) {
    Fluttertoast.showToast(
      msg: text,
      timeInSecForIosWeb: length.seconds,
      gravity: ToastGravity.BOTTOM,
    );
  } else {
    final snackBar = SnackBar(
      content: Text(text),
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: length.seconds),
    );
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

enum SnackBarLength {
  short(1),
  long(2);

  final int seconds;

  const SnackBarLength(this.seconds);
}

