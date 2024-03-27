import 'package:flutter/material.dart';
import 'package:style/animation/on_tap_scale.dart';
import 'package:style/button/control_button.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/text/app_text_dart.dart';

class HomeTopBar extends StatelessWidget {
  const HomeTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Row(
        children: [
          ControlButton(
            onTop: () => {},
            icon: Icons.settings,
          ),
          const SizedBox(
            width: 6,
          ),
          _spaceSelection(
              context: context,
              onTap: () => {},
              spaceName: "Office Squard",
              isExpanded: true),
          const SizedBox(
            width: 6,
          ),
          ControlButton(onTop: () => {}, icon: Icons.message_rounded),
          ControlButton(onTop: () => {}, icon: Icons.location_on_rounded)
        ],
      ),
    );
  }

  Widget _spaceSelection(
      {required BuildContext context,
      required Map Function() onTap,
      required String spaceName,
      required bool isExpanded}) {
    return Flexible(
      child: OnTapScale(
        onTap: () => {},
        child: Card(
          surfaceTintColor: context.colorScheme.surface,
          elevation: 6,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              children: [
                Text(
                  spaceName,
                  style: AppTextStyle.subtitle2
                      .copyWith(color: context.colorScheme.textPrimary),
                ),
                const Spacer(),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: context.colorScheme.primary,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
