import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../storage/app_preferences.dart';

final deviceServiceProvider =
    Provider((ref) => DeviceService(deviceId: ref.read(deviceIdPod)));

class DeviceService {
  final String deviceId;

  DeviceService({required this.deviceId});

  Future<String> get timezone {
    return FlutterTimezone.getLocalTimezone();
  }

  Future<String> get deviceName async {
    final deviceInfo = await DeviceInfoPlugin().deviceInfo;
    if (Platform.isAndroid) {
      return deviceInfo.data["product"];
    } else {
      return deviceInfo.data["name"];
    }
  }

  Future<int> get appVersion async {
    final packageInfo = await PackageInfo.fromPlatform();
    return int.tryParse(packageInfo.buildNumber) ?? 0;
  }

  Future<String> get version async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  Future<String> get packageName async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.packageName;
  }
}
