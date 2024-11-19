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
  bool showHorizontal = false,
  int? selectedIndex,
}) async {
  ValueNotifier<int?> selectedIndexNotifier = ValueNotifier<int?>(selectedIndex);
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
    builder: (context) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(16),
          ),
          color: context.colorScheme.surface,
        ),
        padding: EdgeInsets.only(
          bottom: context.mediaQueryPadding.bottom,
          top: 16,
        ),
        child: showHorizontal
            ? _buildHorizontalLayout(context, items, selectedIndexNotifier)
            : _buildVerticalLayout(context, items),
      );
    },
  );
}

Widget _buildHorizontalLayout(BuildContext context, List<BottomSheetAction> items, ValueNotifier<int?> selectedIndexNotifier) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Align(
        alignment: Alignment.topRight,
        child: IconButton(
          icon: Icon(Icons.close, color: context.colorScheme.textSecondary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;

          return Flexible(
            child: GestureDetector(
              onTap: () {
                selectedIndexNotifier.value = index; // Update selectedIndex
                item.onTap?.call();
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ValueListenableBuilder<int?>(
                    valueListenable: selectedIndexNotifier,
                    builder: (context, selectedIndex, _) {
                      return Container(
                          height: 100,
                          width: 100,// Adjust the height as needed
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: selectedIndex == index
                                  ? context.colorScheme.warning
                                  : Colors.transparent,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                              child: item.icon!));
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    item.title,
                    style: AppTextStyle.body2,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    ],
  );
}

Widget _buildVerticalLayout(BuildContext context, List<BottomSheetAction> items) {
  return ColumnBuilder.separated(
    separatorBuilder: (index) => Divider(
      height: 0,
      thickness: 1,
      color: context.colorScheme.positive,
    ),
    itemBuilder: (index) => items[index],
    itemCount: items.length,
    mainAxisSize: MainAxisSize.min,
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