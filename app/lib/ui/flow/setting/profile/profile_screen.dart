import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:style/animation/on_tap_scale.dart';
import 'package:style/button/bottom_sticky_overlay.dart';
import 'package:style/button/primary_button.dart';
import 'package:style/button/action_button.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/indicator/progress_indicator.dart';
import 'package:style/text/app_text_dart.dart';
import 'package:style/text/app_text_field.dart';
import 'package:yourspace_flutter/domain/extenstions/context_extenstions.dart';
import 'package:yourspace_flutter/ui/app_route.dart';
import 'package:yourspace_flutter/ui/components/app_page.dart';
import 'package:yourspace_flutter/ui/flow/setting/profile/profile_view_model.dart';

import '../../../../gen/assets.gen.dart';
import '../../../components/action_bottom_sheet.dart';
import '../../../components/alert.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late EditProfileViewNotifier notifier;
  final _picker = ImagePicker();

  void _observePop() {
    ref.listen(
        editProfileViewStateProvider.select((state) => state.saved), (previous,
        next) {
      if (next) {
        context.pop();
      }
    });
  }

  void _observeAccountDeleted() {
    ref.listen(
        editProfileViewStateProvider.select((state) => state.accountDeleted), (
        previous, next) {
      if (next) {
        AppRoute.signInMethod.push(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    notifier = ref.watch(editProfileViewStateProvider.notifier);
    final state = ref.watch(editProfileViewStateProvider);
    _observePop();
    _observeAccountDeleted();

    return AppPage(
      title: context.l10n.edit_profile_title,
      actions: [
        actionButton(
          context,
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
            if (state.allowSave) {
              notifier.save();
            }
          },
        ),
      ],
      body: _body(context, state),
    );
  }

  Widget _body(BuildContext context, EditProfileViewState state) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              _profileImage(context, ref, state.profileUrl),
              const SizedBox(height: 40),
              _textFields(context, context.l10n.edit_profile_first_name_title, state.firstName),
              const SizedBox(height: 16),
              _textFields(context, context.l10n.edit_profile_last_name_title, state.lastName),
              const SizedBox(height: 16),
              _textFields(
                  context, context.l10n.edit_profile_email_title, state.email, enabled: state.enableEmail),
              const SizedBox(height: 16),
              _textFields(
                  context, context.l10n.edit_profile_phone_title, state.phone, enabled: state.enablePhone),
            ],
          ),
        ),
        _deleteAccountButton(context),
      ],
    );
  }

  Widget _profileImage(BuildContext context, WidgetRef ref,
      String? profileImage) {
    final state = ref.watch(editProfileViewStateProvider);
    return Center(
      child: OnTapScale(
        onTap: () {
          _openImagePicker(context, state);
        },
        child: SizedBox(
          width: 128,
          height: 128,
          child: Stack(
            children: [
              Container(
                width: 128,
                height: 128,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: context.colorScheme.primary,
                  borderRadius: BorderRadius.circular(64),
                ),
                child: (state.profileUrl!.isEmpty)
                    ? Center(child: Text(
                    notifier.user?.userNameFirstLetter ?? '',
                    style: TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.textPrimaryDark,
                    )
                ))
                    : CachedNetworkImage(
                  imageUrl: state.profileUrl ?? '',
                  fit: BoxFit.cover,
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  width: 36,
                  height: 36,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: context.colorScheme.surface,
                    borderRadius: BorderRadius.circular(36),
                    border: Border.all(
                      color: context.colorScheme.textPrimary,
                      width: 0.8,
                    ),
                  ),
                  child: SvgPicture.asset(
                    Assets.images.icEditProfile,
                    colorFilter: ColorFilter.mode(
                      context.colorScheme.textSecondary,
                      BlendMode.srcATop,
                    ),
                  ),
                ),
              ),
              if (state.uploadingImage)
                const Center(
                  child: AppProgressIndicator(
                    size: AppProgressIndicatorSize.small,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _openImagePicker(BuildContext context, EditProfileViewState state) {
    showActionBottomSheet(
      context: context,
      items: [
        BottomSheetAction(
          title: context.l10n.edit_profile_gallery_option_text,
          icon: Icon(
            CupertinoIcons.photo,
            color: context.colorScheme.textPrimary,
            size: 20,
          ),
          onTap: () async {
            context.pop();
            final image = await _picker.pickImage(
              source: ImageSource.gallery,
              requestFullMetadata: false,
            );
            if (context.mounted && image != null) {
              _openCropImage(context, image);
            }
          },
        ),
        BottomSheetAction(
          title: context.l10n.edit_profile_camera_option_text,
          icon: Icon(
            CupertinoIcons.camera,
            color: context.colorScheme.textPrimary,
            size: 20,
          ),
          onTap: () async {
            context.pop();
            final image = await _picker.pickImage(
              source: ImageSource.camera,
              requestFullMetadata: false,
            );
            if (context.mounted && image != null) {
              _openCropImage(context, image);
            }
          },
        ),
        if (state.profileUrl!.isNotEmpty)
          BottomSheetAction(
            title: context.l10n.edit_profile_remove_photo_option_text,
            icon: SvgPicture.asset(
              Assets.images.icRemove,
              colorFilter: ColorFilter.mode(
                context.colorScheme.textPrimary,
                BlendMode.srcATop,
              ),
            ),
            onTap: () async {
              context.pop();
              notifier.onRemoveImage();
            },
          ),
      ],
    );
  }

  void _openCropImage(BuildContext context, XFile image) async {
    final croppedImage = await ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatioPresets: [CropAspectRatioPreset.square],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: context.l10n.edit_profile_cropper_text,
          toolbarColor: context.colorScheme.primary,
          toolbarWidgetColor: context.colorScheme.onPrimary,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: context.l10n.edit_profile_cropper_text,
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );

    if (croppedImage != null) notifier.uploadProfileImage(croppedImage.path);
  }

  Widget _textFields(BuildContext context, String title,
      TextEditingController controller, {bool enabled = true}) {
    return AppTextField(
      controller: controller,
      label: title,
      style: AppTextStyle.subtitle2.copyWith(
        color: context.colorScheme.textPrimary,
      ),
      enabled: enabled,
      onChanged: (text) => notifier.onChange(),
    );
  }

  Widget _deleteAccountButton(BuildContext context) {
    return BottomStickyOverlay(
      child: PrimaryButton(
        context.l10n.edit_profile_delete_account_title,
        expanded: false,
        edgeInsets:
        const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        showIcon: true,
        foreground: context.colorScheme.alert,
        background: context.colorScheme.containerLow,
        onPressed: () {
          showConfirmation(
            context,
            confirmBtnText: context.l10n.common_delete,
            title: context.l10n.edit_profile_alert_title,
            message: context.l10n.edit_profile_alert_description,
            onConfirm: () => notifier.deleteAccount(),
          );
        },
      ),
    );
  }
}
