import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:yourspace_flutter/domain/extenstions/context_extenstions.dart';


Future<void> showConfirmation(
    BuildContext context, {
      String? title,
      String? message,
      String? confirmBtnText,
      required VoidCallback onConfirm,
      bool isDestructiveAction = true,
      String? cancelButtonText,
      VoidCallback? onCancel,
      bool? popBack = true,
    }) {
  HapticFeedback.mediumImpact();
  return showAdaptiveDialog(
    context: context,
    builder: (context) {
      return AlertDialog.adaptive(
        surfaceTintColor: context.colorScheme.containerNormalOnSurface,
        title: (title != null) ? Text(title) : null,
        content: Text(message ?? context.l10n.alert_confirm_default_title),
        actions: [
          adaptiveAction(
            context: context,
            onPressed: () async {
              context.pop();
              onCancel?.call();
            },
            child: Text(cancelButtonText ?? context.l10n.common_cancel),
          ),
          adaptiveAction(
            context: context,
            isDestructiveAction: isDestructiveAction,
            onPressed: () async {
              if (popBack ?? true) {
                context.pop();
              }
              onConfirm();
            },
            child: Text(
              confirmBtnText ?? context.l10n.common_yes,
            ),
          ),
        ],
      );
    },
  );
}

Future<void> showOkayConfirmation(
    BuildContext context, {
      String? title,
      String? message,
      bool isDestructiveAction = true,
      bool barrierDismissible = true,
      VoidCallback? onOkay,
    }) {
  HapticFeedback.mediumImpact();
  return showAdaptiveDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) {
      return AlertDialog.adaptive(
        surfaceTintColor: context.colorScheme.containerNormalOnSurface,
        title: (title != null) ? Text(title) : null,
        content: (message != null) ? Text(message) : null,
        actions: [
          adaptiveAction(
            context: context,
            onPressed: () async {
              context.pop();
              onOkay?.call();
            },
            child: Text(context.l10n.common_okay),
          ),
        ],
      );
    },
  );
}

Widget adaptiveAction({
  required BuildContext context,
  required VoidCallback onPressed,
  required Widget child,
  bool isDestructiveAction = false,
}) {
  final ThemeData theme = Theme.of(context);
  switch (theme.platform) {
    case TargetPlatform.android:
    case TargetPlatform.fuchsia:
    case TargetPlatform.linux:
    case TargetPlatform.windows:
      return TextButton(
        onPressed: onPressed,
        child: DefaultTextStyle(
          style: TextStyle(
            inherit: true,
            color: isDestructiveAction
                ? context.colorScheme.alert
                : context.colorScheme.textSecondary,
          ),
          child: child,
        ),
      );
    case TargetPlatform.iOS:
    case TargetPlatform.macOS:
      return CupertinoDialogAction(
        onPressed: onPressed,
        isDestructiveAction: isDestructiveAction,
        textStyle: isDestructiveAction
            ? null
            : TextStyle(
          color: isDestructiveAction
              ? context.colorScheme.textPrimary
              : context.colorScheme.textSecondary,
        ),
        child: child,
      );
  }
}

