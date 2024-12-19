import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:data/log/logger.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yourspace_flutter/main.dart';
import 'package:yourspace_flutter/ui/app_route.dart';

const NOTIFICATION_CHANNEL_KEY = "notification_channel_your_space_regional";
const NOTIFICATION_CHANNEL_NAME = "YourSpace Notification";

const NOTIFICATION_ID = 101;

const KEY_NOTIFICATION_TYPE = "type";

class NotificationChatConst {
  static const NOTIFICATION_TYPE_CHAT = "chat";
  static const KEY_PROFILE_URL = "senderProfileUrl";
  static const KEY_IS_GROUP = "isGroup";
  static const KEY_GROUP_NAME = "groupName";
  static const KEY_SENDER_ID = "senderId";
  static const KEY_THREAD_ID = "threadId";
}

class NotificationPlaceConst {
  static const NOTIFICATION_TYPE_NEW_PLACE_ADDED = "new_place_added";
  static const KEY_SPACE_ID = "spaceId";
}

class NotificationGeofenceConst {
  static const NOTIFICATION_TYPE_GEOFENCE = "geofence";
}

class NotificationNetworkStatusConst {
  static const NOTIFICATION_TYPE_NETWORK_STATUS = "network_status";
  static const KEY_USER_ID = "userId";
}

class NotificationUpdateStateConst {
  static const NOTIFICATION_TYPE_UPDATE_STATE = "updateState";
  static const KEY_USER_ID = "userId";
}

final awesomeNotificationHandlerProvider =
    StateProvider.autoDispose((ref) => AwesomeNotificationHandler());

class AwesomeNotificationHandler {
  final AwesomeNotifications awesomeNotifications = AwesomeNotifications();

  AwesomeNotificationHandler();

  Future<void> init(BuildContext context) async {
    _initFcm(context);
    _initLocalNotifications(context);
  }

  void _initFcm(BuildContext context) {
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null && context.mounted) {
        _onNotificationTap(context, message.data);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      if (context.mounted) {
        _onNotificationTap(context, event.data);
      }
    });

    if (Platform.isAndroid) {
      FirebaseMessaging.onMessage.listen((event) {
        _showFirebaseNotification(event);
      });
    }
  }

  void _initLocalNotifications(BuildContext context) {
    _configuration();
    awesomeNotifications.setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
    );
  }

  Future<void> _configuration() async {
    print("configuration check with this");
    await awesomeNotifications.initialize(
      'resource://drawable/app_icon',
      [
        NotificationChannel(
          channelKey: NOTIFICATION_CHANNEL_KEY,
          channelName: NOTIFICATION_CHANNEL_NAME,
          channelDescription: 'Notifications for YourSpace',
          defaultColor: const Color(0xFF1679AB),
          ledColor: const Color(0xFF1679AB),
          importance: NotificationImportance.Low,
        ),
      ],
      debug: true,
    );
  }

  void _showFirebaseNotification(RemoteMessage event) async {
    final notification = event.notification;
    final data = event.data;
    final title = notification?.title;
    final body = notification?.body;

    if (title != null && body != null) {
      await awesomeNotifications.createNotification(
        content: NotificationContent(
          id: DateTime.now().microsecondsSinceEpoch ~/ 1000000,
          channelKey: NOTIFICATION_CHANNEL_KEY,
          title: title,
          body: body,
          payload: data.map((key, value) => MapEntry(key, value?.toString())),
          notificationLayout: NotificationLayout.Default,
        ),
      );
    }
  }

  void showLocalNotification(
      int id, String title, String body, String payload) async {
    await awesomeNotifications.createNotification(
      content: NotificationContent(
        id: id,
        channelKey: NOTIFICATION_CHANNEL_KEY,
        title: title,
        body: body,
        payload: {'type': payload},
        notificationLayout: NotificationLayout.Default,
      ),
    );
  }

  void _onNotificationTap(BuildContext context, Map<String, dynamic> data) {
    print('Notification tapped with data: $data');

    final type = data[KEY_NOTIFICATION_TYPE];

    switch (type) {
      case NotificationChatConst.NOTIFICATION_TYPE_CHAT:
        _handleChatMessage(context, data);
        break;
      case NotificationPlaceConst.NOTIFICATION_TYPE_NEW_PLACE_ADDED:
        _handlePlaceAdded(context, data);
        break;
      case NotificationGeofenceConst.NOTIFICATION_TYPE_GEOFENCE:
        _handleGeoFenceNotificationTap(context);
        break;
      default:
        logger.e("Unhandled notification type: $type");
    }
  }

  void _handlePlaceAdded(BuildContext context, Map<String, dynamic> data) {
    final spaceId = data[NotificationPlaceConst.KEY_SPACE_ID];
    if (spaceId != null) {
      AppRoute.placesList(spaceId).push(context);
    } else {
      logger.e("Space ID is null for place notification");
    }
  }

  void _handleGeoFenceNotificationTap(BuildContext context) {
    AppRoute.home.go(context);
  }

  void _handleChatMessage(BuildContext context, Map<String, dynamic> data) {
    final threadId = data[NotificationChatConst.KEY_THREAD_ID];
    if (threadId != null) {
      AppRoute.chat(threadId: threadId).push(context);
    } else {
      logger.e("Thread ID is null for chat notification");
    }
  }
}

@pragma("vm:entry-point")
Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
// For background actions, you must hold the execution until the end
  print('Message sent via notification input: "${receivedAction}"');
  final payload = receivedAction.payload;
  print('XXX payload data: "${payload}"');
  print('XXX payload "${payload?.values}, ${payload?.entries}"');
  if (payload != null) {
    final type = payload[KEY_NOTIFICATION_TYPE];
    switch (type) {
      case NotificationChatConst.NOTIFICATION_TYPE_CHAT:
        final threadId = payload[NotificationChatConst.KEY_THREAD_ID];
        navigatorKey.currentState?.pushNamed(
          "/message", // Replace with your actual route
          arguments: {'threadId': threadId},
        );
        break;
      case NotificationPlaceConst.NOTIFICATION_TYPE_NEW_PLACE_ADDED:

        break;
      case NotificationGeofenceConst.NOTIFICATION_TYPE_GEOFENCE:

        break;
      default:
        logger.e("Unhandled notification type: $type");
    }
  }
}

