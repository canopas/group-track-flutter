import 'package:data/api/space/space_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:style/button/icon_primary_button.dart';
import 'package:style/button/primary_button.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/indicator/progress_indicator.dart';
import 'package:style/text/app_text_dart.dart';
import 'package:yourspace_flutter/domain/extenstions/context_extenstions.dart';
import 'package:yourspace_flutter/ui/app_route.dart';

import '../../../../gen/assets.gen.dart';

class HomeTopBar extends StatefulWidget {
  final void Function(String) onSpaceItemTap;
  final List<SpaceInfo> spaces;
  final String title;
  final bool loading;

  const HomeTopBar({
    super.key,
    required this.spaces,
    required this.onSpaceItemTap,
    required this.title,
    this.loading = false,
  });

  @override
  State createState() => _HomeTopBarState();
}

class _HomeTopBarState extends State<HomeTopBar> with TickerProviderStateMixin {
  bool expand = false;
  late int selectedIndex = 0;

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
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
                  spaceName: widget.title,
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
            _dropDown(context),
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
                if (widget.loading) ...[
                  const AppProgressIndicator(size: AppProgressIndicatorSize.small),
                ] else ...[
                  Text(
                    spaceName,
                    style: AppTextStyle.subtitle2
                        .copyWith(color: context.colorScheme.textPrimary),
                  ),
                ],
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
            color ?? context.colorScheme.primary,
            BlendMode.srcATop,
          ),
        ),
      ),
    );
  }

  Widget _spaceList(BuildContext context, List<SpaceInfo> spaces, Function(String) onSpaceSelected) {
    if (widget.loading) {
      return const AppProgressIndicator(size: AppProgressIndicatorSize.small);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: spaces.asMap().entries.map((entry) {
        final index = entry.key;
        final space = entry.value;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
              onSpaceSelected(space.space.name);
            },
            child: _spaceListItem(context, space, index, widget.title == space.space.name),
          ),
        );
      }).toList(),
    );
  }


  Widget _spaceListItem(BuildContext context, SpaceInfo space, int index, bool isSelected) {
    final admin = space.members.firstWhere(
          (member) => member.user.id == space.space.admin_id,
    ).user;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
          widget.onSpaceItemTap(space.space.name);
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: context.colorScheme.containerLow,
          border: Border.all(
            color: isSelected ? context.colorScheme.primary : Colors.transparent,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            const SizedBox(width: 4),
            Radio<int>(
              value: index,
              groupValue: selectedIndex,
              onChanged: (val) {
                setState(() {
                  selectedIndex = index;
                  widget.onSpaceItemTap(space.space.name);
                });
              },
              activeColor: context.colorScheme.primary,
            ),
            const SizedBox(width: 4),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  space.space.name,
                  style: AppTextStyle.subtitle2.copyWith(
                    color: context.colorScheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      context.l10n.home_space_owner_text(admin.fullName),
                      style: AppTextStyle.caption.copyWith(
                        color: context.colorScheme.textDisabled,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: context.colorScheme.textDisabled,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      context.l10n.commonMembers(space.members.length),
                      style: AppTextStyle.caption.copyWith(
                        color: context.colorScheme.textDisabled,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _dropDown(BuildContext context) {
    return SizeTransition(
      sizeFactor: _animation,
      axis: Axis.vertical,
      child: Column(
        children: [
          const SizedBox(height: 12),
          _spaceList(context, widget.spaces, widget.onSpaceItemTap),
          const SizedBox(height: 12),
          Row(
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
        ],
      ),
    );
  }
}
