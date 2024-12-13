import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:style/animation/on_tap_scale.dart';
import 'package:style/extenstions/column_builder.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/text/app_text_dart.dart';
import 'package:yourspace_flutter/domain/extenstions/context_extenstions.dart';

Future<T?> showActionBottomSheet<T>({
  required BuildContext context,
  required List<BottomSheetAction> items,
  bool useRootNavigator = true,
  bool showHorizontal = false,
  int? selectedIndex,
}) async {
  ValueNotifier<int?> selectedIndexNotifier =
      ValueNotifier<int?>(selectedIndex);
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

Widget _buildHorizontalLayout(BuildContext context,
    List<BottomSheetAction> items, ValueNotifier<int?> selectedIndexNotifier) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 16, bottom: 16),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(context.l10n.home_map_style_bottom_sheet_title_text,
              style: AppTextStyle.subtitle1
                  .copyWith(color: context.colorScheme.textPrimary)),
          IconButton(
            icon: Icon(Icons.close, color: context.colorScheme.textSecondary),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ]),
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
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: selectedIndex == index
                                ? context.colorScheme.warning
                                : Colors.transparent,
                            width: 2,
                          ),
                          image: item.icon != null
                              ? DecorationImage(
                                  image: (item.icon as Image).image,
                                  // Extract ImageProvider
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
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
      const SizedBox(height: 16)
    ],
  );
}

Widget _buildVerticalLayout(
    BuildContext context, List<BottomSheetAction> items) {
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
