import 'dart:io';

import 'package:data/api/support/api_support_service.dart';
import 'package:data/log/logger.dart';
import 'package:flutter/material.dart';
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
        );

  final List<File> attachmentsToUpload = [];
  final Map<File, String?> uploadedAttachments = {};

  void onTitleChanged(String title) {
    state = state.copyWith(title: TextEditingController(text: title));
  }

  void onDescriptionChanged(String description) {
    state =
        state.copyWith(description: TextEditingController(text: description));
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
        "ContactSupportViewStateNotifier: Error while pick image!",
        error: error,
        stackTrace: stackTrace,
      );
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
          'ContactSupportViewNotifier: error while upload attachments',
           error: error,
          stackTrace: stack,
        );
        _uploadedAttachment(file, null);
        state = state.copyWith(error: error);
      }
    }
  }

  void _uploadingAttachment(File file) {
    final uploading = state.attachmentUploading.toList();
    uploading.add(file);
    state = state.copyWith(attachmentUploading: uploading);
  }

  void _uploadedAttachment(File file, String? uri) {
    final uploading = state.attachmentUploading.toList();
    uploading.remove(file);
    uploadedAttachments[file] = uri;
    state = state.copyWith(attachmentUploading: uploading);
  }

  void onAttachmentRemoved(int index) {
    state = state.copyWith(attachments: state.attachments.toList()..removeAt(index));
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
        'ContactSupportViewNotifier: error while submit response',
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
    Object? error,
    required TextEditingController title,
    required TextEditingController description,
    @Default([]) List<File> attachments,
    @Default([]) List<File> attachmentUploading,
  }) = _ContactSupportViewState;
}
