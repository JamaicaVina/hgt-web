import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static const key =
      'AAAA6N3Rca0:APA91bErZojYo46w6QlIp6RpZGEeJt60a14Dy4_T8LGRqCEXAQcY-TpE1GOK3nBs17kaDE4_BMP7Iu0SF7k5ohBjiYSQ2Hw2f5VPNG1SnDfeT695nN4TsHNYZsv7DUO4Zj3erMjdhNV3';

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void _initLocalNotification() {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const initializationSettings =
        InitializationSettings(android: androidSettings);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void firebaseNotification(context) {
    _initLocalNotification();

    FirebaseMessaging.onMessageOpenedApp
        .listen((RemoteMessage message) async {});

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await _showLocalNotification(message);
    });
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final styleInformation = BigTextStyleInformation(
      message.notification!.body.toString(),
      htmlFormatBigText: true,
      contentTitle: message.notification!.title,
      htmlFormatTitle: true,
    );
    final androidDetails = AndroidNotificationDetails(
        'com.example.mhss', 'OROCARE PSYCH SERV',
        styleInformation: styleInformation, importance: Importance.high);
    final notificationDetails = NotificationDetails(
      android: androidDetails,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      message.notification!.title,
      message.notification!.body,
      notificationDetails,
      payload: message.data['body'],
    );
  }

  Future<void> requestPermission() async {
    final message = FirebaseMessaging.instance;
    final settings = await message.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    settings.authorizationStatus == AuthorizationStatus.authorized
        ? debugPrint('User Granted Permission')
        : settings.authorizationStatus == AuthorizationStatus.provisional
            ? debugPrint('User Granted Provisional Status')
            : debugPrint('User Denied Permission');
  }
}
