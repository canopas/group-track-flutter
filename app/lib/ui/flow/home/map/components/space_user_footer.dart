import 'package:data/api/space/space_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:style/animation/on_tap_scale.dart';
import 'package:style/button/icon_primary_button.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/indicator/progress_indicator.dart';
import 'package:style/text/app_text_dart.dart';
import 'package:yourspace_flutter/domain/extenstions/context_extenstions.dart';
import 'package:yourspace_flutter/ui/components/profile_picture.dart';

import '../../../../../gen/assets.gen.dart';
import '../map_view_model.dart';
import 'selected_member_detail_view.dart';

class SpaceUserFooter extends StatefulWidget {
  final SpaceInfo? selectedSpace;
  final List<MapUserInfo>? members;
  final MapUserInfo? selectedUser;
  final bool isEnabled;
  final bool fetchingInviteCode;
  final bool isCurrentUser;
  final LatLng currentUserLocation;
  final void Function() onAddMemberTap;
  final void Function(MapUserInfo) onMemberTap;
  final void Function() onRelocateTap;
  final void Function() onMapTypeTap;
  final void Function() onPlacesTap;
  final void Function() onDismiss;

  const SpaceUserFooter({
    super.key,
    this.selectedSpace,
    required this.members,
    this.selectedUser,
    required this.isEnabled,
    required this.fetchingInviteCode,
    required this.isCurrentUser,
    required this.currentUserLocation,
    required this.onAddMemberTap,
    required this.onMemberTap,
    required this.onRelocateTap,
    required this.onMapTypeTap,
    required this.onPlacesTap,
    required this.onDismiss,
  });

  @override
  State<SpaceUserFooter> createState() => _SpaceUserFooterState();
}

class _SpaceUserFooterState extends State<SpaceUserFooter> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 16),
      child: Column(
        children: [
          _mapControlBtn(context),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return SlideTransition(
                position: Tween(
                  begin: const Offset(0.0, 1.0),
                  end: const Offset(0.0, 0.0),
                ).animate(animation),
                child: ScaleTransition(scale: animation, child: child),
              );
            },
            child: widget.selectedUser != null
                ? SelectedMemberDetailView(
                    key: const ValueKey('detailView'),
                    groupCreatedDate: widget.selectedSpace?.space.created_at ?? 0,
                    userInfo: widget.selectedUser,
                    onDismiss: widget.onDismiss,
                    isCurrentUser: widget.isCurrentUser,
                    currentUserLocation: widget.currentUserLocation,
                  )
                : const SizedBox.shrink(
                    key: ValueKey('emptyBox'),
                  ),
          ),
          Visibility(
              visible: widget.isEnabled &&
                  widget.members != null &&
                  widget.members!.isNotEmpty,
              child: selectedSpaceMemberView(
                context: context,
                members: widget.members,
              )),
        ],
      ),
    );
  }

  Widget _mapControlBtn(BuildContext context) {
    return SizedBox(
      width: context.mediaQuerySize.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _iconButton(
            context: context,
            icon: Assets.images.icMapType,
            iconSize: 24,
            foreground: context.colorScheme.primary,
            background: context.colorScheme.surface,
            onTap: widget.onMapTypeTap,
          ),
          const SizedBox(height: 16),
          _iconButton(
            context: context,
            icon: Assets.images.icRelocateIcon,
            iconSize: 24,
            foreground: context.colorScheme.primary,
            background: context.colorScheme.surface,
            onTap: widget.onRelocateTap,
          ),
          const SizedBox(height: 16),
          if (widget.selectedSpace != null) ...[
            _iconButton(
              context: context,
              icon: Assets.images.icGeofenceIcon,
              iconSize: 24,
              foreground: context.colorScheme.textInversePrimary,
              background: context.colorScheme.primary,
              onTap: widget.onPlacesTap,
            ),
            const SizedBox(height: 16)
          ],
        ],
      ),
    );
  }

  Widget _iconButton({
    required BuildContext context,
    required String icon,
    required double iconSize,
    required Color foreground,
    required Color background,
    bool visibility = true,
    required Function() onTap,
  }) {
    return Visibility(
      visible: visibility,
      child: IconPrimaryButton(
        bgColor: background,
        onTap: () => onTap(),
        icon: SvgPicture.asset(
          icon,
          colorFilter: ColorFilter.mode(
            foreground,
            BlendMode.srcATop,
          ),
        ),
      ),
    );
  }

  Widget selectedSpaceMemberView({
    required BuildContext context,
    required List<MapUserInfo>? members,
  }) {
    if (members == null || members.isEmpty) return Container();
    return Container(
      padding: const EdgeInsets.only(top: 8,bottom: 8,right: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: context.colorScheme.surface,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          addMemberView(context),
          Flexible(
            child: SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: members.length,
                shrinkWrap: true,
                itemBuilder: (_, index) {
                  return spaceMemberItem(context, members[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget addMemberView(BuildContext context) {
    return OnTapScale(
      enabled: !widget.fetchingInviteCode,
      onTap: widget.onAddMemberTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 6),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  border:
                      Border.all(color: context.colorScheme.primary, width: 1),
                  borderRadius: BorderRadius.circular(30)),
              child: widget.fetchingInviteCode
                  ? const AppProgressIndicator(
                      size: AppProgressIndicatorSize.small,
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        Assets.images.icAddUserIcon,
                        colorFilter: ColorFilter.mode(
                          context.colorScheme.primary,
                          BlendMode.srcATop,
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 2),
            Text(
              context.l10n.common_add,
              maxLines: 1,
              style: AppTextStyle.caption
                  .copyWith(color: context.colorScheme.textPrimary),
            ),
          ],
        ),
      ),
    );
  }

  Widget spaceMemberItem(
    BuildContext context,
      MapUserInfo userInfo,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: OnTapScale(
        onTap: () {
          widget.onMemberTap(userInfo);
        },
        child: SizedBox(
          width: 40,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ProfileImage(
                profileImageUrl: userInfo.user.profile_image!,
                firstLetter: userInfo.user.firstChar,
                size: 40,
                backgroundColor: context.colorScheme.primary,
              ),
              const SizedBox(height: 2),
              Text(
                userInfo.user.first_name ?? '',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: AppTextStyle.caption
                    .copyWith(color: context.colorScheme.textPrimary),
              )
            ],
          ),
        ),
      ),
    );
  }
}
