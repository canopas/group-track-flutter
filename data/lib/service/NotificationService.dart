import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final StreamController<String?> onNotificationClick =
      StreamController<String>();

  /// Initialize Notification Service
  Future<void> initializeService() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("@drawable/app_icon");

    const InitializationSettings settings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _notificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (response){
        print('Notification Clicked: ${response.actionId}');
      },
      onDidReceiveBackgroundNotificationResponse: _handleNotificationResponse,
    );
  }

  /// Handle Notification Response (Foreground or Background)
  void _handleNotificationResponse(NotificationResponse response) {
    final payload = response.payload ?? "";
    print('Notification Clicked: ${response.actionId}');
    if (payload.isNotEmpty) {
      onNotificationClick.add(payload);
    }
  }

  Future<NotificationDetails> _notificationDetail() async {
    const androidNotificationDetails = AndroidNotificationDetails(
      'default_channel',
      'Default Notifications',
      channelDescription: 'General Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    return const NotificationDetails(android: androidNotificationDetails);
  }

  /// Show Notification with Actions
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload = "",
  }) async {
    final notificationDetails = await _notificationDetail();

    await _notificationsPlugin.show(id, title, body, notificationDetails,
        payload: payload);
  }
}
