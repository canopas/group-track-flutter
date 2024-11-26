import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:data/log/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:yourspace_flutter/ui/app_route.dart';

import '../../main.dart';

const YOUR_SPACE_CHANNEL_MESSAGE = "your_space_notification_channel_messages";
const YOUR_SPACE_CHANNEL_PLACES = "your_space_notification_channel_places";
const YOUR_SPACE_CHANNEL_GEOFENCE = "your_space_notification_channel_geofence";

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

class FCMNotificationHandler {
  // Private constructor
  FCMNotificationHandler._();

  // Singleton instance
  static final FCMNotificationHandler _instance = FCMNotificationHandler._();

  // Public factory constructor to access the singleton
  factory FCMNotificationHandler() => _instance;

  final AwesomeNotifications awesomeNotifications = AwesomeNotifications();

  Future<void> configuration() async {
    await awesomeNotifications.initialize(
      null,
      [
        NotificationChannel(
          channelKey: YOUR_SPACE_CHANNEL_MESSAGE,
          channelName: 'Message Notifications',
          channelDescription: 'Notifications for chat messages',
          importance: NotificationImportance.High,
          channelShowBadge: true,
        ),
        NotificationChannel(
          channelKey: YOUR_SPACE_CHANNEL_PLACES,
          channelName: 'Place Notifications',
          channelDescription: 'Notifications for places',
          importance: NotificationImportance.High,
          channelShowBadge: true,
        ),
        NotificationChannel(
          channelKey: YOUR_SPACE_CHANNEL_GEOFENCE,
          channelName: 'Geofence Notifications',
          channelDescription: 'Notifications for geofencing',
          importance: NotificationImportance.High,
          channelShowBadge: true,
        ),
      ],
      debug: true,
    );
    awesomeNotifications.setListeners(onActionReceivedMethod: _onNotificationTapHandler);
  }

  Future<void> createLocalInstantNotification({
    required String title,
    required String body,
    Map<String, String>? payload,
  }) async {
    await awesomeNotifications.createNotification(
      content: NotificationContent(
        id: -1,
        channelKey: 'your_space_notification_channel',
        title: title,
        body: body,
        payload: payload,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'REPLY',
          label: 'Reply to chat message',
          requireInputText: true,
          actionType: ActionType.SilentAction,
        )
      ]
    );
  }

  void handleIncomingFCMNotification(Map<String, dynamic> data) {
    final String? title = data['notification']['title'];
    final String? body = data['notification']['body'];
    final Map<String, String> payload = data.cast<String, String>();

    if (title != null && body != null) {
      createLocalInstantNotification(
        title: title,
        body: body,
        payload: payload,
      );
    }
  }

  Future<void> _onNotificationTapHandler(ReceivedAction action) async {
    final data = action.payload ?? {};
    final context = navigatorKey.currentContext;

    if (context == null) {
      logger.e("Context is null. Cannot handle notification tap.");
      return;
    }

    if (action.buttonKeyInput == 'REPLY') {
      String replyMessage = action.body ?? '';
      logger.d("Reply received: $replyMessage");
    }

    FCMNotificationHandler().onNotificationTap(context, data);
  }
  void onNotificationTap(
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
}

extension on FCMNotificationHandler {
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
