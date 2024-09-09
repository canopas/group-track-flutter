import 'dart:convert';
import 'dart:io';

import 'package:data/api/auth/api_user_service.dart';
import 'package:data/log/logger.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yourspace_flutter/ui/app_route.dart';

const YOUR_SPACE_CHANNEL_MESSAGE = "your_space_notification_channel_messages";
const YOUR_SPACE_CHANNEL_PLACES = "your_space_notification_channel_places";
const YOUR_SPACE_CHANNEL_GEOFENCE = "your_space_notification_channel_geofence";

const _androidChannel = AndroidNotificationChannel(
  'notification_channel_your_space_regional',
  'YourSpace Notification',
  importance: Importance.max,
);

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

final notificationHandlerProvider = StateProvider.autoDispose(
    (ref) => NotificationHandler(ref.read(apiUserServiceProvider)));

class NotificationHandler {
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final ApiUserService userService;

  NotificationHandler(this.userService) {
    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);
  }

  Future<void> init(BuildContext context) async {
    _initFcm(context);
    if (context.mounted) await _initLocalNotifications(context);
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
        showLocalNotification(event);
      });
    }
  }

  Future<void> _initLocalNotifications(BuildContext context) async {
    _flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('app_logo'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
      onDidReceiveNotificationResponse: (response) {
        if (response.payload != null && context.mounted) {
          _onNotificationTap(context, jsonDecode(response.payload!));
        }
      },
    );
  }

  void showLocalNotification(RemoteMessage event) {
    final notification = event.notification;
    final data = event.data;
    final title = notification?.title;
    final body = notification?.body;

    if (title != null && body != null) {
      _flutterLocalNotificationsPlugin.show(
        DateTime.now().microsecondsSinceEpoch ~/ 1000000,
        title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            importance: Importance.low,
          ),
        ),
        payload: jsonEncode(data),
      );
    }
  }
}

extension on NotificationHandler {
  void _onNotificationTap(
      BuildContext context, Map<String, dynamic> data) async {
    logger.d("Notification handler - _onNotificationTap with data $data");

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
      case NotificationNetworkStatusConst.NOTIFICATION_TYPE_NETWORK_STATUS:
        break;
    }
  }

  void _handlePlaceAdded(BuildContext context, Map<String, dynamic> data) {
    if (!context.mounted) return;
    final String? spaceId = data[NotificationPlaceConst.KEY_SPACE_ID];
    if (spaceId != null) {
      AppRoute.placesList(spaceId).push(context);
    } else {
      logger.e("Space ID is null for place added notification");
    }
  }

  void _handleGeoFenceNotificationTap(BuildContext context) {
    if (!context.mounted) return;
    AppRoute.home.go(context);
  }

  void _handleChatMessage(BuildContext context, Map<String, dynamic> data) {
    final String? threadId = data[NotificationChatConst.KEY_THREAD_ID];
    if (threadId != null) {
      AppRoute.chat(threadId: threadId).push(context);
    } else {
      logger.e("Thread ID is null for chat notification");
    }
  }
}
