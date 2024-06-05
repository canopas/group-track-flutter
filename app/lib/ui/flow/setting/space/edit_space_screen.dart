import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:data/api/auth/auth_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:style/button/action_button.dart';
import 'package:style/button/bottom_sticky_overlay.dart';
import 'package:style/button/primary_button.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/indicator/progress_indicator.dart';
import 'package:style/text/app_text_dart.dart';
import 'package:style/text/app_text_field.dart';
import 'package:yourspace_flutter/domain/extenstions/context_extenstions.dart';
import 'package:yourspace_flutter/domain/extenstions/widget_extensions.dart';
import 'package:yourspace_flutter/ui/components/app_page.dart';
import 'package:yourspace_flutter/ui/flow/setting/space/edit_space_view_model.dart';

import '../../../components/alert.dart';

class EditSpaceScreen extends ConsumerStatefulWidget {
  final String spaceId;

  const EditSpaceScreen({super.key, required this.spaceId});

  @override
  ConsumerState createState() => _EditSpaceScreenState();
}

class _EditSpaceScreenState extends ConsumerState<EditSpaceScreen> {
  late EditSpaceViewNotifier notifier;
  final Map<String, Color> _userColors = {};

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
    notifier = ref.watch(editSpaceViewStateProvider.notifier);
    final state = ref.watch(editSpaceViewStateProvider);
    _observePop();

    return AppPage(
      title: state.space?.space.name,
      actions: [
        if (state.isAdmin) ...[
          actionButton(
            context,
            icon: state.saving
                ? const AppProgressIndicator(
                    size: AppProgressIndicatorSize.small)
                : Icon(
                    Icons.check,
                    size: 24,
                    color: state.allowSave
                        ? context.colorScheme.primary
                        : context.colorScheme.textDisabled,
                  ),
            onPressed: () {
              if (state.allowSave) {
                notifier.updateSpace();
              }
            },
          ),
        ]
      ],
      body: _body(context, state),
    );
  }

  Widget _body(BuildContext context, EditSpaceViewState state) {
    if (state.loading) {
      return const Center(child: AppProgressIndicator());
    }

    return Stack(
      children: [
        ListView(
          children: [
            const SizedBox(height: 16),
            _spaceNameField(context, state),
            const SizedBox(height: 16),
            _yourLocation(context, state),
            const SizedBox(height: 16),
            _divider(context),
            const SizedBox(height: 16),
            _memberLocation(context, state),
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
            _locationSharingItem(context, state.currentUserInfo!,
                isCurrentUser: state.currentUserInfo?.user.id ==
                    state.currentUserInfo!.user.id,
            locationEnabled: state.locationEnabled,
            ),
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
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: _locationSharingItem(context, member),
                );
              }).toList(),
            ),
          ]
        ],
      ),
    );
  }

  Widget _locationSharingItem(BuildContext context, ApiUserInfo member,
      {bool isCurrentUser = false, bool locationEnabled = false}) {
    return Row(
      children: [
        _profileImageView(context, member),
        const SizedBox(width: 16),
        Text(
          member.user.fullName,
          style: AppTextStyle.subtitle2
              .copyWith(color: context.colorScheme.textPrimary),
        ),
        const Spacer(),
        Switch(
          value:
              isCurrentUser ? locationEnabled : member.isLocationEnabled,
          onChanged: isCurrentUser
              ? (bool value) {
                  notifier.toggleLocationSharing(value);
                  notifier.updateSpace();
                }
              : null,
          activeColor: context.colorScheme.textPrimaryDark,
          activeTrackColor: context.colorScheme.primary,
          inactiveTrackColor: context.colorScheme.containerLowOnSurface,
        ),
      ],
    );
  }

  Widget _profileImageView(BuildContext context, ApiUserInfo member) {
    final profileImageUrl = member.user.profile_image ?? '';
    final firstLetter = member.user.userNameFirstLetter;

    Color getRandomColor() {
      Random random = Random();
      return Color.fromARGB(
        255,
        random.nextInt(128),
        random.nextInt(128),
        random.nextInt(128),
      );
    }

    Color getUserColor(String userId) {
      if (!_userColors.containsKey(userId)) {
        _userColors[userId] = getRandomColor();
      }
      return _userColors[userId]!;
    }

    return SizedBox(
      width: 40,
      height: 40,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: profileImageUrl.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: profileImageUrl,
                placeholder: (context, url) => const AppProgressIndicator(
                    size: AppProgressIndicatorSize.small),
                fit: BoxFit.cover,
              )
            : Container(
                color: getUserColor(member.user.id),
                child: Center(
                  child: Text(firstLetter,
                      style: AppTextStyle.header3
                          .copyWith(color: context.colorScheme.textPrimary)),
                ),
              ),
      ),
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
        state.isAdmin
            ? context.l10n.edit_space_delete_space_title
            : context.l10n.edit_space_leave_space_title,
        expanded: false,
        edgeInsets: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        showIcon: state.isAdmin ? true : false,
        foreground: context.colorScheme.alert,
        background: context.colorScheme.containerLow,
        onPressed: () {
          showConfirmation(
            context,
            confirmBtnText: state.isAdmin
                ? context.l10n.common_delete
                : context.l10n.edit_space_leave_space_title,
            title: state.isAdmin
                ? context.l10n.common_delete
                : context.l10n.edit_space_leave_alert_title,
            message: state.isAdmin
                ? context.l10n.edit_space_delete_space_alert_message(
                    state.space!.space.name)
                : context.l10n.edit_space_leave_space_alert_message(
                    state.space!.space.name),
            onConfirm: () => notifier.deleteSpace(),
          );
        },
      ),
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
}
