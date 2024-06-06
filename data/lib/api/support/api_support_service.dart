import 'dart:io';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data/api/auth/auth_models.dart';

import '../../service/device_service.dart';
import '../../storage/app_preferences.dart';

final apiSupportServiceProvider = Provider<ApiSupportService>((ref) => ApiSupportService(
  ref.read(currentUserPod),
  ref.read(deviceServiceProvider),
));

class ApiSupportService {
  final ApiUser? _currentUser;
  final DeviceService _device;

  ApiSupportService(this._currentUser, this._device);

  Future<String?> uploadImage(File file) async {
    final user = _currentUser;
    if (user == null) return null;

    final storageRef = FirebaseStorage.instance;
    final fileName = "IMG_${DateTime.now().millisecondsSinceEpoch}.jpg";
    final imageRef =
        storageRef.ref().child("contact_support/${user.id}/$fileName");

    final uploadTask = imageRef.putFile(file);
    await uploadTask.whenComplete(() => null);
    final downloadUrl = await imageRef.getDownloadURL();
    return downloadUrl;
  }

  Future<void> submitSupportRequest(String title, String description, List<String> attachments) async {
    final report = {
      "title": title,
      "description": description,
      "device_name": _device.deviceName,
      "app_version": _device.appVersion,
      "device_os": Platform.operatingSystemVersion,
      "user_id": _currentUser?.id,
      "attachments": attachments,
    };

    final callable = FirebaseFunctions.instance.httpsCallable('sendSupportRequest');
    await callable.call(report);
  }
}
