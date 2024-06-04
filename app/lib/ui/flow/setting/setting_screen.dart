import 'package:cached_network_image/cached_network_image.dart';
import 'package:data/api/space/space_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:style/button/icon_primary_button.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/indicator/progress_indicator.dart';
import 'package:style/text/app_text_dart.dart';
import 'package:yourspace_flutter/domain/extenstions/context_extenstions.dart';
import 'package:yourspace_flutter/domain/extenstions/widget_extensions.dart';
import 'package:yourspace_flutter/ui/app_route.dart';
import 'package:yourspace_flutter/ui/components/app_page.dart';
import 'package:yourspace_flutter/ui/components/resume_detector.dart';
import 'package:yourspace_flutter/ui/flow/setting/setting_view_model.dart';

import '../../../gen/assets.gen.dart';

class SettingScreen extends ConsumerStatefulWidget {
  const SettingScreen({super.key});

  @override
  ConsumerState createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<SettingScreen> {
  late SettingViewNotifier notifier;

  @override
  void initState() {
    super.initState();
    runPostFrame(() {
      notifier = ref.watch(settingViewStateProvider.notifier);
      notifier.getUserSpace();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: context.l10n.settings_title,
      body: ResumeDetector(
          onResume: () {
            notifier.getUser();
            notifier.getUserSpace();
          }, child: _body(context)),
    );
  }

  Widget _body(BuildContext context) {
    final state = ref.watch(settingViewStateProvider);
    if (state.loading) {
      return const Center(child: AppProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          _profileView(context, state),
          const SizedBox(height: 24),
          _yourSpaceList(context, state),
          const SizedBox(height: 24),
          _otherOptionList(context),
        ],
      ),
    );
  }

  Widget _profileView(BuildContext context, SettingViewState state) {
    return GestureDetector(
      onTap: () {
        AppRoute.profile.push(context);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.settings_profile_title,
            style: AppTextStyle.subtitle1
                .copyWith(color: context.colorScheme.textDisabled),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: context.colorScheme.containerLowOnSurface,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _profileImageView(context, state),
                const SizedBox(width: 16),
                Text(
                  state.currentUser?.fullName ?? '',
                  style: AppTextStyle.subtitle2
                      .copyWith(color: context.colorScheme.textPrimary),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _yourSpaceList(BuildContext context, SettingViewState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.settings_your_space_title,
          style: AppTextStyle.subtitle1
              .copyWith(color: context.colorScheme.textDisabled),
        ),
        const SizedBox(height: 24),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: state.spaces.asMap().entries.map((entry) {
            final space = entry.value;
            final isLastItem = entry.key == state.spaces.length - 1;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: GestureDetector(
                onTap: () {
                  AppRoute.editSpace(space.id).push(context);
                },
                child: Column(
                  children: [
                    _spaceListItem(context, space),
                    if (!isLastItem) ...[
                      const SizedBox(height: 16),
                      Container(
                        height: 1,
                        decoration: BoxDecoration(
                          color: context.colorScheme.outline,
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            );
          }).toList(),
        )
      ],
    );
  }

  Widget _spaceListItem(BuildContext context, ApiSpace space) {
    return Row(
      children: [
        Container(
          height: 36,
          width: 36,
          decoration: BoxDecoration(
            color: context.colorScheme.containerLowOnSurface,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              space.name[0].toUpperCase(),
              style: AppTextStyle.subtitle1.copyWith(
                color: context.colorScheme.textPrimary
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            space.name,
            style: AppTextStyle.subtitle3.copyWith(
              color: context.colorScheme.textPrimary
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Icon(
          Icons.arrow_forward_ios,
          size: 12,
          color: context.colorScheme.textSecondary,
        ),
      ],
    );
  }

  Widget _otherOptionList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.settings_other_title,
          style: AppTextStyle.subtitle2
              .copyWith(color: context.colorScheme.textDisabled),
        ),
        const SizedBox(height: 16),
        _otherOptionItem(
            context: context,
            title: context.l10n.settings_other_option_contact_support_text,
            icon: Assets.images.icContactSupport,
            onTap: () {}),
        _otherOptionItem(
            context: context,
            title: context.l10n.settings_other_option_privacy_policy_text,
            icon: Assets.images.icPrivacyPolicy,
            onTap: () {}),
        _otherOptionItem(
            context: context,
            title: context.l10n.settings_other_option_about_us_text,
            icon: Assets.images.icAboutUs,
            onTap: () {}),
        _otherOptionItem(
            context: context,
            title: context.l10n.settings_other_option_sign_out_text,
            icon: Assets.images.icSignOut,
            onTap: () {}),
      ],
    );
  }

  Widget _otherOptionItem({
    required BuildContext context,
    required String title,
    required String icon,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          children: [
            _iconButton(context: context, icon: icon),
            const SizedBox(width: 16),
            Text(
              title,
              style: AppTextStyle.subtitle3
                  .copyWith(color: context.colorScheme.textPrimary),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 12,
              color: context.colorScheme.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconButton({
    required BuildContext context,
    required String icon,
  }) {
    return IconPrimaryButton(
      onTap: () {},
      size: 36,
      icon: SvgPicture.asset(
        height: 16,
        width: 14,
        icon,
        colorFilter: ColorFilter.mode(
          context.colorScheme.textPrimary,
          BlendMode.srcATop,
        ),
      ),
    );
  }

  Widget _profileImageView(BuildContext context, SettingViewState state) {
    final profileImageUrl = state.currentUser?.profile_image ?? '';
    final firstLetter = state.currentUser?.userNameFirstLetter ?? '';

    return SizedBox(
      width: 64,
      height: 64,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: profileImageUrl.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: profileImageUrl,
                placeholder: (context, url) => const AppProgressIndicator(size: AppProgressIndicatorSize.small),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
              )
            : Container(
                color: context.colorScheme.containerInverseHigh,
                child: Center(
                  child: Text(firstLetter,
                      style: AppTextStyle.header1
                          .copyWith(color: context.colorScheme.textPrimary)),
                ),
              ),
      ),
    );
  }
}
