// import 'dart:async';
//
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// const _androidChannel = AndroidNotificationChannel(
//   'notification_channel_your_space_regional',
//   'YourSpace Notification',
//   importance: Importance.max,
// );
//
// class NotificationService {
//   final FlutterLocalNotificationsPlugin _notificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//
//   NotificationService() {
//     _notificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(_androidChannel);
//   }
//
//   final StreamController<String?> onNotificationClick =
//       StreamController<String>();
//
//   /// Initialize Notification Service
//   Future<void> initializeService() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings("app_icon");
//
//     const InitializationSettings settings = InitializationSettings(
//       android: initializationSettingsAndroid,
//     );
//
//     await _notificationsPlugin.initialize(
//       settings,
//       onDidReceiveNotificationResponse: (NotificationResponse response) {
//         print("XXX call on did response onclick 1:$response");
//       },
//       onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
//     );
//   }
//
//   /// Handle Notification Response (Foreground or Background)
//   void _handleNotificationResponse(NotificationResponse response) {
//     final payload = response.payload ?? "";
//     print('Notification Clicked: ${response.actionId}');
//     if (payload.isNotEmpty) {
//       onNotificationClick.add(payload);
//     }
//   }
//
//   /// Show Notification with Actions
//   Future<void> showNotification({
//     required int id,
//     required String title,
//     required String body,
//     String? payload = "",
//   }) async {
//     _notificationsPlugin.show(
//       DateTime.now().microsecondsSinceEpoch ~/ 1000000,
//       title,
//       body,
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           _androidChannel.id,
//           _androidChannel.name,
//           importance: Importance.max,
//           priority: Priority.high,
//           actions:[AndroidNotificationAction('id', 'Action Name')],
//         ),
//       ),
//       payload: 'sample_payload',
//     );
//   }
// }
//
// @pragma('vm:entry-point')
// void notificationTapBackground(NotificationResponse notificationResponse) {
//   // ignore: avoid_print
//   print('XXX notification(${notificationResponse.id}) action tapped: '
//       '${notificationResponse.actionId} with'
//       ' payload: ${notificationResponse.payload}');
//   if (notificationResponse.input?.isNotEmpty ?? false) {
//     // ignore: avoid_print
//     print(
//         'XXX notification action tapped with input: ${notificationResponse.input}');
//   }
// }
