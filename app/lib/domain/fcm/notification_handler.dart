import 'dart:isolate';
import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:data/log/logger.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:yourspace_flutter/ui/app.dart';

import 'package:yourspace_flutter/ui/app_route.dart';

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
  static ReceivedAction? initialAction;

  static Future<void> initializeLocalNotifications() async {
    await AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
              channelKey: 'alerts',
              channelName: 'Alerts',
              channelDescription: 'Notification tests as alerts',
              importance: NotificationImportance.High,
              defaultPrivacy: NotificationPrivacy.Private,)
        ],
        debug: true);
    initialAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: false);
  }

  static ReceivePort? receivePort;
  static Future<void> initializeIsolateReceivePort() async {
    receivePort = ReceivePort('Notification action port in main isolate')
      ..listen(
              (silentData) => _onNotificationTapHandler(silentData));

    // This initialization only happens on main isolate
    IsolateNameServer.registerPortWithName(
        receivePort!.sendPort, 'notification_action_port');
  }

  static Future<void> startListeningNotificationEvents() async {
    AwesomeNotifications()
        .setListeners(onActionReceivedMethod: onActionReceivedMethod);
  }

  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    if (receivedAction.actionType == ActionType.SilentAction ||
        receivedAction.actionType == ActionType.SilentBackgroundAction) {
      // For background actions, you must hold the execution until the end
      logger.d(
          'Message sent via notification input: "${receivedAction.buttonKeyInput}"');
    } else {
      // this process is only necessary when you need to redirect the user
      // to a new page or use a valid context, since parallel isolates do not
      // have valid context, so you need redirect the execution to main isolate
      if (receivePort == null) {
        logger.d(
            'onActionReceivedMethod was called inside a parallel dart isolate.');
        SendPort? sendPort =
        IsolateNameServer.lookupPortByName('notification_action_port');

        if (sendPort != null) {
          logger.d('Redirecting the execution to main isolate process.');
          sendPort.send(receivedAction);
          return;
        }
      }

      return onActionReceivedImplementationMethod(receivedAction);
    }
  }

  static Future<void> onActionReceivedImplementationMethod(
      ReceivedAction receivedAction) async {
    AwesomeNotifications()
        .setListeners(onActionReceivedMethod: onActionReceivedMethod);
  }

  static Future<void> createNewNotification(RemoteMessage event) async {
    final notification = event.notification;
    final title = notification?.title;
    final body = notification?.body;
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: -1, // -1 is replaced by a random number
            channelKey: 'alerts',
            title: title,
            body: body,
          payload: {'jsonEncode(data)' : '1243567'},
           ),
        actionButtons: [
          NotificationActionButton(
              key: 'REPLY',
              label: 'Reply Message',
              requireInputText: true,
              actionType: ActionType.SilentAction),
        ]);
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

/// Notification action handler
@pragma("vm:entry-point")
Future<void> _onNotificationTapHandler(ReceivedAction action) async {
  final data = action.payload ?? {};
  final context = App.navigatorKey.currentContext;

  if (context == null) {
    logger.e("Context is null. Cannot handle notification tap.");
    return;
  }

  logger.d("Notification action received: ${action.buttonKeyPressed}");

  if (action.buttonKeyPressed == 'REPLY') {
    String replyMessage = action.buttonKeyInput;
    logger.d("Reply received: $replyMessage");
  }

  FCMNotificationHandler().onNotificationTap(context, data);
}
