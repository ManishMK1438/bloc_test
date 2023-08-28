import 'dart:convert';

import 'package:bloc_test/main.dart';
import 'package:bloc_test/screens/notifications_screen/notifications_screen.dart';
import 'package:bloc_test/utils/strings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  debugPrint("Title : ${message.notification?.title}");
  debugPrint("Body : ${message.notification?.body}");
  debugPrint("Payload : ${message.data}");
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final _androidChannel = const AndroidNotificationChannel(
      'high_importance_channel', 'High Importance Notifications',
      description: "Channel used for important notifications",
      importance: Importance.high);
  final _localNotification = FlutterLocalNotificationsPlugin();
  void handleMessage(RemoteMessage? message) {
    //if (message == null) return;

    navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (ctx) => const NotificationScreen(),
        settings: RouteSettings(arguments: message)));
  }

  Future initPushNotifications() async {
    final notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
            _androidChannel.id, _androidChannel.name,
            channelDescription: _androidChannel.description,
            icon: AppImages.appIcon));
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen((handleMessage));
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((event) {
      final notification = event.notification;
      if (notification == null) return;

      _localNotification.show(notification.hashCode, notification.title,
          notification.body, notificationDetails,
          payload: jsonEncode(event.toMap()));
    });
  }

  Future initLocalNotification() async {
    const ios = DarwinInitializationSettings();
    const android = AndroidInitializationSettings(AppImages.appIcon);
    const settings = InitializationSettings(android: android, iOS: ios);
    await _localNotification.initialize(settings,
        onDidReceiveNotificationResponse: (payload) {
      final message = RemoteMessage.fromMap(jsonDecode(payload.payload!));
      handleMessage(message);
    });

    final platform = _localNotification.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    debugPrint(fcmToken);
    initPushNotifications();
    initLocalNotification();
  }
}
