import 'package:data/api/space/space_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:style/button/icon_primary_button.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/indicator/progress_indicator.dart';
import 'package:style/text/app_text_dart.dart';
import 'package:yourspace_flutter/domain/extenstions/context_extenstions.dart';
import 'package:yourspace_flutter/ui/app_route.dart';
import 'package:yourspace_flutter/ui/components/app_page.dart';
import 'package:yourspace_flutter/ui/components/error_snakebar.dart';
import 'package:yourspace_flutter/ui/components/profile_picture.dart';
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
  Widget build(BuildContext context) {
    notifier = ref.watch(settingViewStateProvider.notifier);
    final state = ref.watch(settingViewStateProvider);
    _observeLogOut();
    _observeError();

    return AppPage(
      title: context.l10n.settings_title,
      body: ResumeDetector(
          onResume: () {
            notifier.getUser();
            notifier.getUserSpace();
          }, child: _body(context, state)),
    );
  }

  Widget _body(BuildContext context, SettingViewState state) {
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
    final profileImageUrl = state.currentUser?.profile_image ?? '';
    final firstLetter = state.currentUser?.firstChar ?? '';

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
                ProfileImage(
                  profileImageUrl: profileImageUrl,
                  firstLetter: firstLetter,
                  style: AppTextStyle.header3
                      .copyWith(color: context.colorScheme.textPrimaryDark),
                ),
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
            onTap: () {
              AppRoute.contactSupport.push(context);
            }),
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
            onTap: () {
              notifier.signOut();
            }),
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
      radius: 8,
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

  void _observeLogOut() {
    ref.listen(settingViewStateProvider.select((state) => state.logOut), (previous, next) {
      if (next) {
        AppRoute.signInMethod.push(context);
      }
    });
  }

  void _observeError() {
    ref.listen(settingViewStateProvider.select((state) => state.error), (previous, next) {
      if (next != null) {
        showErrorSnackBar(context, next.toString());
      }
    });
  }
}
