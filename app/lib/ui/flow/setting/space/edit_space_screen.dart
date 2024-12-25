import 'package:data/api/auth/auth_models.dart';
import 'package:data/api/space/space_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:style/animation/on_tap_scale.dart';
import 'package:style/button/action_button.dart';
import 'package:style/button/bottom_sticky_overlay.dart';
import 'package:style/button/icon_primary_button.dart';
import 'package:style/button/primary_button.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/indicator/progress_indicator.dart';
import 'package:style/text/app_text_dart.dart';
import 'package:style/text/app_text_field.dart';
import 'package:yourspace_flutter/domain/extenstions/context_extenstions.dart';
import 'package:yourspace_flutter/domain/extenstions/widget_extensions.dart';
import 'package:yourspace_flutter/gen/assets.gen.dart';
import 'package:yourspace_flutter/ui/app_route.dart';
import 'package:yourspace_flutter/ui/components/app_page.dart';
import 'package:yourspace_flutter/ui/components/error_snakebar.dart';
import 'package:yourspace_flutter/ui/components/profile_picture.dart';
import 'package:yourspace_flutter/ui/components/resume_detector.dart';
import 'package:yourspace_flutter/ui/flow/setting/space/edit_space_view_model.dart';

import '../../../components/alert.dart';
import '../../../components/no_internet_screen.dart';

class EditSpaceScreen extends ConsumerStatefulWidget {
  final String spaceId;

  const EditSpaceScreen({super.key, required this.spaceId});

  @override
  ConsumerState createState() => _EditSpaceScreenState();
}

class _EditSpaceScreenState extends ConsumerState<EditSpaceScreen> {
  late EditSpaceViewNotifier notifier;

  @override
  void initState() {
    super.initState();
    runPostFrame(() {
      notifier = ref.watch(editSpaceViewStateProvider.notifier);
      notifier.getSpaceDetails(widget.spaceId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editSpaceViewStateProvider);
    _observePop();
    _observeError();

    return AppPage(
      title: state.space?.space.name,
      actions: [
        actionButton(
          context: context,
          icon: state.saving
              ? const AppProgressIndicator(size: AppProgressIndicatorSize.small)
              : Icon(
                  Icons.check,
                  size: 24,
                  color: state.allowSave
                      ? context.colorScheme.primary
                      : context.colorScheme.textDisabled,
                ),
          onPressed: () {
            _checkUserInternet(() {
              if (state.allowSave) {
                notifier.updateSpace();
              }
            });
          },
        ),
        if (state.isAdmin) ...[
          actionButton(
              context: context,
              icon: Icon(
                Icons.person_2_outlined,
                size: 24,
                color: context.colorScheme.textPrimary,
              ),
              onPressed: () {
                AppRoute.changeAdmin(state.space!).push(context);
              }),
        ]
      ],
      body: SafeArea(
          child: ResumeDetector(
              onResume: () => notifier.getUpdatedSpaceDetails(),
              child: _body(context, state))),
    );
  }

  Widget _body(BuildContext context, EditSpaceViewState state) {
    if (state.isNetworkOff) {
      return NoInternetScreen(onPressed: () {
        notifier.getSpaceDetails(widget.spaceId);
      });
    }

    if (state.loading) {
      return const Center(child: AppProgressIndicator());
    }

    return Stack(
      children: [
        ListView(
          children: [
            const SizedBox(height: 16),
            _spaceNameField(context, state),
            const SizedBox(height: 10),
            if (state.isAdmin && state.invitationCode != null) ...[
              _invitationCode(
                  context, state.invitationCode!, state.refreshingInviteCode),
            ],
            _yourLocation(context, state),
            const SizedBox(height: 10),
            _divider(context),
            _memberLocation(context, state),
            const SizedBox(height: 64)
          ],
        ),
        _deleteSpaceButton(context, state),
      ],
    );
  }

  Widget _spaceNameField(BuildContext context, EditSpaceViewState state) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: AppTextField(
            label: context.l10n.edit_space_name_title,
            onChanged: (value) => notifier.onChange(value),
            controller: state.spaceName,
            enabled: state.isAdmin,
          ),
        ),
        const SizedBox(height: 8),
        _divider(context),
      ],
    );
  }

  Widget _yourLocation(BuildContext context, EditSpaceViewState state) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.edit_space_your_location_sharing_title,
            style: AppTextStyle.subtitle1
                .copyWith(color: context.colorScheme.textDisabled),
          ),
          const SizedBox(height: 24),
          if (state.currentUserInfo != null) ...[
            _locationSharingItem(
                context, state.currentUserInfo!, state.locationEnabled,
                isCurrentUser: true, adminId: state.space!.space.admin_id),
          ],
        ],
      ),
    );
  }

  Widget _memberLocation(BuildContext context, EditSpaceViewState state) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.edit_space_member_location_sharing_title,
            style: AppTextStyle.subtitle1
                .copyWith(color: context.colorScheme.textDisabled),
          ),
          const SizedBox(height: 8),
          if (state.userInfo.isEmpty) ...[
            const SizedBox(height: 16),
            Center(
              child: Text(
                context.l10n.edit_space_no_member_in_space_text(
                    state.space?.space.name ?? ''),
                style: AppTextStyle.subtitle3.copyWith(
                  color: context.colorScheme.textSecondary,
                ),
              ),
            ),
          ] else ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: state.userInfo.asMap().entries.map((entry) {
                final member = entry.value;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: _locationSharingItem(
                      context, member, member.isLocationEnabled,
                      isAdmin: state.isAdmin,
                      adminId: state.space!.space.admin_id),
                );
              }).toList(),
            ),
          ]
        ],
      ),
    );
  }

  Widget _locationSharingItem(
      BuildContext context, ApiUserInfo member, bool isLocationEnabled,
      {bool isAdmin = false,
      bool isCurrentUser = false,
      required String adminId}) {
    final profileImageUrl = member.user.profile_image ?? '';
    final firstLetter = member.user.firstChar;
    return Row(
      children: [
        ProfileImage(
          profileImageUrl: profileImageUrl,
          firstLetter: firstLetter,
          size: 40,
          backgroundColor: context.colorScheme.primary,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Row(
            children: [
              Text(
                member.user.fullName,
                style: AppTextStyle.subtitle2
                    .copyWith(color: context.colorScheme.textPrimary),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                width: member.user.id == adminId ? 8 : 0,
              ),
              Text(
                member.user.id == adminId
                    ? context.l10n.edit_space_admin_text
                    : '',
                style: AppTextStyle.body1
                    .copyWith(color: context.colorScheme.textSecondary),
              )
            ],
          ),
        ),
        const SizedBox(width: 8),
        Switch(
          value: isLocationEnabled,
          onChanged: (bool value) {
            if (isCurrentUser) {
              notifier.toggleLocationSharing(value);
            }
          },
          activeTrackColor: context.colorScheme.primary,
          inactiveTrackColor: context.colorScheme.outline,
          inactiveThumbColor: context.colorScheme.textPrimaryDark,
          activeColor: context.colorScheme.containerLowOnSurface,
          trackOutlineColor:
              WidgetStatePropertyAll(context.colorScheme.outline),
          trackOutlineWidth: const WidgetStatePropertyAll(0.5),
        ),
        if (isAdmin && !isCurrentUser) ...[
          const SizedBox(width: 8),
          OnTapScale(
            onTap: () => _showConfirmationToRemoveUserFromGroup(onTap: () {
              notifier.leaveSpace(userId: member.user.id);
              notifier.isAdminRemovingMember(true);
            }),
            child: Icon(Icons.remove_circle_outline_rounded,
                color: context.colorScheme.alert),
          ),
        ]
      ],
    );
  }

  Widget _divider(BuildContext context) {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        color: context.colorScheme.outline,
      ),
    );
  }

  Widget _deleteSpaceButton(BuildContext context, EditSpaceViewState state) {
    return BottomStickyOverlay(
      child: PrimaryButton(
        state.space?.members.length == 1
            ? context.l10n.edit_space_delete_space_title
            : context.l10n.edit_space_leave_space_title,
        expanded: false,
        progress: state.deleting,
        edgeInsets: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        showIcon: state.isAdmin ? true : false,
        foreground: context.colorScheme.alert,
        background: context.colorScheme.containerLowOnSurface,
        onPressed: () {
          if (state.isAdmin && state.space!.members.length >= 2) {
            _showPopupToChangeAdmin(state);
          } else {
            showConfirmation(context,
                confirmBtnText: state.space?.members.length == 1
                    ? context.l10n.common_delete
                    : context
                        .l10n.edit_space_leave_space_alert_confirm_button_text,
                title: state.space?.members.length == 1
                    ? context.l10n.edit_space_delete_space_title
                    : context.l10n.edit_space_leave_space_title,
                message: state.space?.members.length == 1
                    ? context.l10n.edit_space_delete_space_alert_message
                    : context.l10n.edit_space_leave_space_alert_message,
                onConfirm: () {
              _checkUserInternet(() => state.space?.members.length == 1
                  ? notifier.deleteSpace()
                  : notifier.leaveSpace());
            });
          }
        },
      ),
    );
  }

  Widget _invitationCode(BuildContext context,
      ApiSpaceInvitation invitationCode, bool refreshingInviteCode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            context.l10n.edit_space_invitation_code_title,
            style: AppTextStyle.subtitle2
                .copyWith(color: context.colorScheme.textDisabled),
          ),
        ),
        const SizedBox(height: 8),
        _shareAndRegenerateCode(invitationCode, refreshingInviteCode),
        const SizedBox(height: 24),
        _divider(context),
      ],
    );
  }

  Widget _shareAndRegenerateCode(
      ApiSpaceInvitation invitationCode, bool refreshingInviteCode) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: SelectableText(
                  invitationCode.code,
                  style: AppTextStyle.header4
                      .copyWith(color: context.colorScheme.textPrimary),
                ),
              ),
              IconPrimaryButton(
                  bgColor: Colors.transparent,
                  onTap: () async {
                    Share.share(context.l10n
                        .invite_code_share_code_text(invitationCode.code));
                  },
                  icon: Icon(
                    Icons.share_rounded,
                    color: context.colorScheme.textPrimary,
                    size: 20,
                  )),
              const SizedBox(width: 4),
              IconPrimaryButton(
                  bgColor: Colors.transparent,
                  onTap: () async {
                    await notifier.regenerateInvitationCode();
                  },
                  progress: refreshingInviteCode,
                  icon: SvgPicture.asset(
                    Assets.images.icRegenerateInvitationCode,
                    colorFilter: ColorFilter.mode(
                      context.colorScheme.textPrimary,
                      BlendMode.srcATop,
                    ),
                  ))
            ],
          ),
        ],
      ),
    );
  }

  void _showConfirmationToRemoveUserFromGroup({required Function onTap}) {
    showConfirmation(
      context,
      confirmBtnText: context.l10n.common_remove,
      title: context.l10n.edit_space_remove_user_title,
      message: context.l10n.edit_space_remove_user_subtitle,
      popBack: false,
      onConfirm: () {
        _checkUserInternet(() => onTap());
      },
    );
  }

  void _showPopupToChangeAdmin(EditSpaceViewState state) {
    showConfirmation(
      context,
      confirmBtnText: context.l10n.edit_space_change_admin_text,
      title: context.l10n.edit_space_change_admin_title,
      message: context.l10n.edit_space_change_admin_subtitle,
      popBack: false,
      onConfirm: () {
        AppRoute.changeAdmin(state.space!).push(context);
        context.pop();
      },
    );
  }

  void _observePop() {
    ref.listen(editSpaceViewStateProvider.select((state) => state.deleted),
        (previous, next) {
      if (next) {
        context.pop();
      }
    });
  }

  void _observeError() {
    ref.listen(editSpaceViewStateProvider.select((state) => state.error),
        (previous, next) {
      if (next != null) {
        showErrorSnackBar(context, next.toString());
      }
    });
  }

  void _checkUserInternet(VoidCallback onCallback) async {
    final isNetworkOff = await checkInternetConnectivity();
    isNetworkOff ? _showSnackBar() : onCallback();
  }

  void _showSnackBar() {
    showErrorSnackBar(context, context.l10n.on_internet_error_sub_title);
  }
}
