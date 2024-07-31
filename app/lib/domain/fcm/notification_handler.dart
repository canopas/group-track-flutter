import 'dart:convert';
import 'dart:io';

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
  '',
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
  static const KEY_SPACE_ID = "spaceId";
  static const KEY_PLACE_ID = "placeId";
  static const KEY_PLACE_NAME = "placeName";
  static const eventBy = "eventBy";
  static const KEY_EVENT_BY = "eventBy";
}

class NotificationUpdateStateConst {
  static const NOTIFICATION_TYPE_UPDATE_STATE = "updateState";
}

final notificationHandlerProvider =
StateProvider.autoDispose((ref) => NotificationHandler());

class NotificationHandler {
  final _flutterNotificationPlugin = FlutterLocalNotificationsPlugin();

  NotificationHandler() {
    _flutterNotificationPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);
  }

  void init(BuildContext context) {
    _requestPermissions();
    _initFcm(context);
    if (Platform.isAndroid) _initLocalNotifications(context);
  }

  Future<void> _initFcm(BuildContext context) async {
    // Handle initial message
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null && context.mounted) {
        _onNotificationTap(context, message.data);
      }
    });

    // Also handle any interaction when the app is in the background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data.isNotEmpty) {
        _onNotificationTap(context, message.data);
      }
    });

    if (Platform.isAndroid) {
      // handle foreground message for android as we need to show notification manually
      FirebaseMessaging.onMessage.listen((event) {
        showLocalNotification(event);
      });
    }
  }

  Future<void> _initLocalNotifications(BuildContext context) async {
    // handle local notification tap
    _flutterNotificationPlugin.initialize(
        const InitializationSettings(
          android: AndroidInitializationSettings('app_icon'),
        ), onDidReceiveNotificationResponse: (response) {
      if (response.payload != null) {
        _onNotificationTap(context, jsonDecode(response.payload!));
      }
    });

    // Handle initial message that might have launched the app
    _flutterNotificationPlugin
        .getNotificationAppLaunchDetails()
        .then((initial) {
      final payload = initial?.notificationResponse?.payload;
      if (initial?.didNotificationLaunchApp == true &&
          payload != null &&
          context.mounted) {
        _onNotificationTap(context, jsonDecode(payload));
      }
    });
  }

  void _requestPermissions() {
    FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void showLocalNotification(RemoteMessage message) async {
    final data = message.data;
    final title = data['title'];
    final body = data['body'];

    if (title != null && body != null) {
      _flutterNotificationPlugin.show(
          DateTime
              .now()
              .microsecondsSinceEpoch ~/ 1000000,
          title,
          body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _androidChannel.id,
              _androidChannel.name,
              icon: 'app_icon',
            ),
          ),
          payload: jsonEncode(data),
      );
    }
  }
}

extension on NotificationHandler {
  void _onNotificationTap(BuildContext context,
      Map<String, dynamic> data) async {
    logger.d("Notification handler - _onNotificationTap with data $data");

    final type = data[KEY_NOTIFICATION_TYPE];

    switch (type) {
      case NotificationChatConst.NOTIFICATION_TYPE_CHAT:
        break;
      case NotificationPlaceConst.NOTIFICATION_TYPE_NEW_PLACE_ADDED:
        _handlePlaceAdded(context, data);
        break;
      case NotificationGeofenceConst.NOTIFICATION_TYPE_GEOFENCE:
        break;
    }
  }

  void _handlePlaceAdded(BuildContext context, Map<String, dynamic> data) {
    final String? spaceId = data[NotificationPlaceConst.KEY_SPACE_ID];
    if (spaceId != null) {
      AppRoute.placesList(spaceId).push(context);
    } else {
      logger.e("Space ID is null for place added notification");
    }
  }
}
