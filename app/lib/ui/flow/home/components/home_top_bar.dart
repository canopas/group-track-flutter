import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:style/button/icon_primary_button.dart';
import 'package:style/button/primary_button.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/text/app_text_dart.dart';
import 'package:yourspace_flutter/domain/extenstions/context_extenstions.dart';
import 'package:yourspace_flutter/ui/app_route.dart';

import '../../../../gen/assets.gen.dart';

class HomeTopBar extends StatefulWidget {
  const HomeTopBar({super.key});

  @override
  State<HomeTopBar> createState() => _HomeTopBarState();
}

class _HomeTopBarState extends State<HomeTopBar> with TickerProviderStateMixin {
  bool expand = false;

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void performAnimation() {
    if (expand) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }


  @override
  Widget build(BuildContext context) {
    return _body(context);
  }

  Widget _body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _topBar(context),
    );
  }

  Widget _topBar(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        color: expand ? context.colorScheme.surface : null,
        child: Column(
          children: [
            Row(
              children: [
                _iconButton(
                    context: context,
                    icon: Assets.images.icSetting,
                    visibility: !expand),
                const SizedBox(width: 8),
                _spaceSelection(
                  context: context,
                  spaceName: "Office Squard",
                ),
                const SizedBox(width: 8),
                _iconButton(
                    context: context,
                    icon: Assets.images.icMessage,
                    visibility: !expand),
                SizedBox(width: expand ? 0 : 8),
                _iconButton(
                    context: context,
                    icon: Assets.images.icLocation,
                    visibility: !expand),
                _iconButton(
                    context: context,
                    icon: Assets.images.icAddMember,
                    visibility: expand,
                    color: context.colorScheme.textPrimary),
              ],
            ),
            const SizedBox(height: 24),
            _createJoinButton(context),
          ],
        ),
      ),
    );
  }

  Widget _spaceSelection({
    required BuildContext context,
    required String spaceName,
  }) {
    return Flexible(
      child: GestureDetector(
        onTap: () {
          setState(() {
            expand = !expand;
            performAnimation();
          });
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: context.colorScheme.outline,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
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
                  expand
                      ? Icons.keyboard_arrow_down_rounded
                      : Icons.keyboard_arrow_up_rounded,
                  color: context.colorScheme.textPrimary,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _iconButton({
    required BuildContext context,
    required String icon,
    Color? color,
    required bool visibility,
  }) {
    return Visibility(
      visible: visibility,
      child: IconPrimaryButton(
        onTap: () => {},
        icon: SvgPicture.asset(
          height: 16,
          width: 14,
          icon,
          colorFilter: ColorFilter.mode(
            color ?? context.colorScheme.textPrimary,
            BlendMode.srcATop,
          ),
        ),
      ),
    );
  }

  Widget _createJoinButton(BuildContext context) {
    return SizeTransition(
      sizeFactor: _animation,
      axis: Axis.vertical,
      child: Row(
        children: [
          Expanded(
            child: PrimaryButton(context.l10n.home_create_space_title, onPressed: () {
              AppRoute.createSpace.push(context);
            }),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: PrimaryButton(context.l10n.home_join_space_title, onPressed: () {
              // AppRoute.joinSpace.push(context);
            }),
          ),
        ],
      ),
    );
  }
}
