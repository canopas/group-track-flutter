import 'dart:io';

import 'package:data/network/error.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:yourspace_flutter/domain/extenstions/api_error_extension.dart';

void showErrorSnackBar(BuildContext context, Object error) {
  HapticFeedback.mediumImpact();
  final message = ApiError.fromError(error).l10nMessage(context);
  showSnackBar(context, message, length: SnackBarLength.long);
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

