import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:style/animation/on_tap_scale.dart';
import 'package:style/button/action_button.dart';
import 'package:style/button/bottom_sticky_overlay.dart';
import 'package:style/button/primary_button.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/indicator/progress_indicator.dart';
import 'package:style/text/app_text_dart.dart';
import 'package:style/text/app_text_field.dart';
import 'package:yourspace_flutter/domain/extenstions/context_extenstions.dart';
import 'package:yourspace_flutter/ui/flow/setting/contact_support/contact_support_view_model.dart';

import '../../../components/app_page.dart';

class ContactSupportScreen extends ConsumerStatefulWidget {
  const ContactSupportScreen({super.key});

  @override
  ConsumerState<ContactSupportScreen> createState() =>
      _ContactSupportScreenState();
}

class _ContactSupportScreenState extends ConsumerState<ContactSupportScreen> {
  late ContactSupportViewNotifier notifier;

  @override
  Widget build(BuildContext context) {
    notifier = ref.watch(contactSupportViewStateProvider.notifier);
    final state = ref.watch(contactSupportViewStateProvider);
    _observePop();

    return AppPage(
      title: context.l10n.contact_support_title,
      body: _body(context, state),
    );
  }

  Widget _body(BuildContext context, ContactSupportViewState state) {
    return Builder(
      builder: (context) => Stack(
        children: [
          ListView(
            padding: MediaQuery.of(context).padding +
                const EdgeInsets.all(16) +
                BottomStickyOverlay.padding,
            children: [
              AppTextField(
                controller: state.title,
                label: context.l10n.contact_support_title_field,
              ),
              const SizedBox(height: 40),
              AppTextField(
                label: context.l10n.contact_support_description_title,
                borderType: AppTextFieldBorderType.outline,
                controller: state.description,
                maxLines: 8,
              ),
              const SizedBox(height: 40),
              _attachmentButton(
                context: context,
                onAttachmentTap: () => notifier.pickAttachments(),
              ),
              const SizedBox(height: 16),
              _attachmentList(context, state),
            ],
          ),
          _submitButton(context, state),
        ],
      ),
    );
  }

  Widget _attachmentList(BuildContext context, ContactSupportViewState state) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 12),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.attachments.length,
      itemBuilder: (context, index) {
        final file = state.attachments[index];
        final isLoading = state.attachmentUploading.contains(file);
        return _attachmentItem(
          context: context,
          path: file.path,
          name: file.path.split('/').last,
          loading: isLoading,
          onCancelTap: () {
            notifier.onAttachmentRemoved(index);
          },
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 8),
    );
  }

  Widget _attachmentItem(
      {required BuildContext context,
      required String path,
      required String name,
      required bool loading,
      required void Function() onCancelTap}) {
    return Row(
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: context.colorScheme.containerNormal,
            borderRadius: BorderRadius.circular(12),
          ),
          child: _imageFileView(
            iconColor: context.colorScheme.textDisabled,
            path: path,
          ),
        ),
        const SizedBox(width: 16),
        Flexible(
          child: Text(
            name,
            style: AppTextStyle.body2.copyWith(
              color: context.colorScheme.textSecondary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (loading)
          const Padding(
            padding: EdgeInsets.only(left: 16),
            child: AppProgressIndicator(size: AppProgressIndicatorSize.small),
          ),
        actionButton(
          context,
          onPressed: () => onCancelTap(),
          icon: Icon(
            Icons.cancel_rounded,
            color: context.colorScheme.textDisabled,
            size: 28,
          ),
        ),
      ],
    );
  }

  Widget _imageFileView({
    required Color iconColor,
    required String path,
  }) {
    return Hero(
      tag: path,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: FileImage(File(path)),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _attachmentButton({
    required BuildContext context,
    required VoidCallback onAttachmentTap,
  }) {
    return OnTapScale(
      onTap: onAttachmentTap,
      child: Row(
        children: [
          Icon(
            CupertinoIcons.paperclip,
            color: context.colorScheme.textPrimary,
          ),
          Text(
            context.l10n.contact_support_attachment,
            style: AppTextStyle.body2.copyWith(
              color: context.colorScheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _submitButton(BuildContext context, ContactSupportViewState state) {
    return BottomStickyOverlay(
      child: PrimaryButton(
        enabled: !state.submitting && state.enableSubmit,
        progress: state.submitting,
        context.l10n.contact_support_submit_title,
        onPressed: () {
          notifier.submitSupportRequest();
        },
      ),
    );
  }

  void _observePop() {
    ref.listen(
        contactSupportViewStateProvider.select((state) => state.requestSent),
        (previous, next) {
      if (next) {
        context.pop();
      }
    });
  }
}
