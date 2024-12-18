// import 'dart:convert';
//
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// const _androidChannel = AndroidNotificationChannel(
//   'notification_channel_your_space_regional',
//   'YourSpace Notification',
//   importance: Importance.max,
// );
//
// final localNotificationHandler =
//     StateProvider.autoDispose((ref) => LocalNotificationHandler());
//
// class LocalNotificationHandler {
//   final _localNotificationPlugin = FlutterLocalNotificationsPlugin();
//
//   LocalNotificationHandler() {
//     _localNotificationPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(_androidChannel);
//   }
//
//   Future<void> init({
//     required void Function(String?) onTap,
//     required void Function(NotificationResponse) onBackgroundTap,
//   }) async {
//     await _localNotificationPlugin.initialize(
//       const InitializationSettings(
//         android: AndroidInitializationSettings("app_notification_icon"),
//         iOS: DarwinInitializationSettings(
//           requestAlertPermission: false,
//           requestBadgePermission: false,
//           requestSoundPermission: false,
//         ),
//       ),
//       onDidReceiveNotificationResponse: (response) {
//         onTap(response.payload);
//       },
//       onDidReceiveBackgroundNotificationResponse: onBackgroundTap,
//     );
//   }
//
//   Future<void> showNotification({
//     required int id,
//     required String title,
//     required String body,
//     String? payload = "",
//     bool onGoing = true,
//   }) async {
//     _localNotificationPlugin.show(
//       id, //DateTime.now().microsecondsSinceEpoch ~/ 1000000,
//       title,
//       body,
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           _androidChannel.id,
//           _androidChannel.name,
//           importance: Importance.max,
//           priority: Priority.high,
//           ongoing: onGoing,
//         ),
//       ),
//       payload: payload,
//     );
//   }
// }
