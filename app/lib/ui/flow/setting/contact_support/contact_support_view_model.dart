import 'dart:io';

import 'package:data/api/support/api_support_service.dart';
import 'package:data/log/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';

part 'contact_support_view_model.freezed.dart';

final contactSupportViewStateProvider = StateNotifierProvider.autoDispose<
    ContactSupportViewNotifier, ContactSupportViewState>(
  (ref) => ContactSupportViewNotifier(
    ref.read(apiSupportServiceProvider),
    ImagePicker(),
  ),
);

class ContactSupportViewNotifier
    extends StateNotifier<ContactSupportViewState> {
  final ApiSupportService supportService;
  final ImagePicker picker;

  ContactSupportViewNotifier(this.supportService, this.picker)
      : super(
    ContactSupportViewState(
      title: TextEditingController(),
      description: TextEditingController(),
    ),
  ) {
    state.title.addListener(verifySubmitButton);
  }

  final List<File> attachmentsToUpload = [];
  final Map<File, String?> uploadedAttachments = {};

  void verifySubmitButton() {
    state = state.copyWith(
      enableSubmit: state.title.text.trim().isNotEmpty && state.attachmentUploading.isEmpty,
    );
  }

  void pickAttachments() async {
    try {
      final List<XFile> medias = await picker.pickMultipleMedia(
        imageQuality: 70,
      );

      final List<File> files = medias.map((media) => File(media.path)).toList();
      onAttachmentAdded(files);
    } catch (error, stackTrace) {
      logger.e(
        "ContactSupportViewNotifier: Error while picking image!",
        error: error,
        stackTrace: stackTrace,
      );
      state = state.copyWith(error: error);
    }
  }

  void onAttachmentAdded(List<File> files) {
    final attachments = state.attachments.toList();
    for (var file in files) {
      if (file.lengthSync() > 5 * 1024 * 1024) {
        state = state.copyWith(attachmentSizeLimitExceed: true);
        continue;
      }
      attachments.add(file);
      attachmentsToUpload.add(file);
    }
    state = state.copyWith(
        attachments: attachments, attachmentSizeLimitExceed: false);
    uploadPendingAttachments();
    verifySubmitButton();
  }

  void uploadPendingAttachments() async {
    final fileCopy = List<File>.from(attachmentsToUpload);
    attachmentsToUpload.clear();
    for (final file in fileCopy) {
      try {
        _uploadingAttachment(file);
        final uri = await supportService.uploadImage(file);
        _uploadedAttachment(file, uri);
      } catch (error, stack) {
        logger.e(
          'ContactSupportViewNotifier: error while uploading attachments',
          error: error,
          stackTrace: stack,
        );
        _uploadedAttachment(file, null);
        state = state.copyWith(error: error);
      }
    }
    verifySubmitButton();
  }

  void _uploadingAttachment(File file) {
    final uploading = state.attachmentUploading.toList();
    uploading.add(file);
    state = state.copyWith(attachmentUploading: uploading);
    verifySubmitButton();
  }

  void _uploadedAttachment(File file, String? uri) {
    final uploading = state.attachmentUploading.toList();
    uploading.remove(file);
    uploadedAttachments[file] = uri;
    state = state.copyWith(attachmentUploading: uploading);
    verifySubmitButton();
  }

  void onAttachmentRemoved(int index) {
    final attachments = state.attachments.toList();
    final removedFile = attachments.removeAt(index);
    uploadedAttachments.remove(removedFile);
    state = state.copyWith(attachments: attachments);
    verifySubmitButton();
  }

  void submitSupportRequest() async {
    try {
      state = state.copyWith(submitting: true, error: null, attachmentSizeLimitExceed: false);
      final attachments =
      uploadedAttachments.values.whereType<String>().toList();
      await supportService.submitSupportRequest(
        state.title.text,
        state.description.text,
        attachments,
      );
      state = state.copyWith(requestSent: true, submitting: false);
    } catch (error, stack) {
      logger.e(
        'ContactSupportViewNotifier: error while submitting response',
        error: error,
        stackTrace: stack,
      );
      state = state.copyWith(error: error, submitting: false);
    }
  }
}

@freezed
class ContactSupportViewState with _$ContactSupportViewState {
  const factory ContactSupportViewState({
    @Default(false) bool submitting,
    @Default(false) bool requestSent,
    @Default(false) bool attachmentSizeLimitExceed,
    @Default(false) bool enableSubmit,
    Object? error,
    required TextEditingController description,
    required TextEditingController title,
    @Default([]) List<File> attachments,
    @Default([]) List<File> attachmentUploading,
  }) = _ContactSupportViewState;
}
