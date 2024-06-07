import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:style/animation/on_tap_scale.dart';
import 'package:style/extenstions/column_builder.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/text/app_text_dart.dart';

Future<T?> showActionBottomSheet<T>({
  required BuildContext context,
  required List<BottomSheetAction> items,
  bool useRootNavigator = true,
}) async {
  HapticFeedback.mediumImpact();

  return await showModalBottomSheet<T>(
    backgroundColor: context.colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(16),
      ),
    ),
    useRootNavigator: useRootNavigator,
    context: context,
    builder: (context) => Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16),
        ),
        color: context.colorScheme.surface,
      ),
      padding: EdgeInsets.only(
        bottom: context.mediaQueryPadding.bottom,
      ),
      child: ColumnBuilder.separated(
        separatorBuilder: (index) => Divider(
          height: 0,
          thickness: 1,
          color: context.colorScheme.outline,
        ),
        itemBuilder: (index) => items[index],
        itemCount: items.length,
        mainAxisSize: MainAxisSize.min,
      ),
    ),
  );
}

class BottomSheetAction extends StatelessWidget {
  final Widget? icon;
  final String title;
  final Widget? child;
  final void Function()? onTap;

  const BottomSheetAction({
    super.key,
    this.icon,
    required this.title,
    this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OnTapScale(
      enabled: child == null,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        child: Row(
          children: [
            icon ?? const SizedBox(),
            Visibility(
              visible: icon != null,
              child: const SizedBox(width: 20),
            ),
            Text(
              title,
              style: AppTextStyle.subtitle2
                  .copyWith(color: context.colorScheme.textPrimary),
            ),
            const Spacer(),
            Visibility(
              visible: child != null,
              child: child ?? const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
