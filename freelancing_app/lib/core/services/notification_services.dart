import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:freelancing_platform/core/classes/route_handler.dart';
import 'package:freelancing_platform/core/classes/user_session.dart';
import 'package:freelancing_platform/core/constants/app_constant_data.dart';
import 'package:freelancing_platform/data/services/user_notification_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

class NotificationServices {
  NotificationServices();
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static const AndroidNotificationChannel _androidChannel =
      AndroidNotificationChannel(
    'jeeb_high_importance',
    'High Importance Notifications',
    description: 'Used for important app notifications.',
    importance: Importance.high,
  );
  Future<void> initialize(
      {required void Function(String token) onToken}) async {
    if (AppConstantData.notificationsEnable == false) {
      return;
    }
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await _requestPermission();
    await _initializeLocalNotifications();
    await _configureForegroundMessages();
    await _configureNotificationClickHandling();
    await _loadInitialToken(onToken);
    _listenToTokenRefresh(onToken);
  }

  Future<void> _requestPermission() async {
    await _messaging.requestPermission(
        alert: true,
        badge: true, //لها علاقه بالUI
        sound: true,
        provisional: false);
  }

  //تهيئه الاشعارات بالforeground
  Future<void> _initializeLocalNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();

    const initSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);
    _localNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        _handLocalNotificationClick(details.payload);
      },
    );
    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);
  }

  Future<void> _configureForegroundMessages() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: false,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.onMessage.listen((message) async {
      await _showForegroundNotification(message);
    });
  }

  Future<void> _showForegroundNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) {
      // print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! nullll");
      return;
    }
    // print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! notttt nullll");

    final payload = jsonEncode(message.data);
    // Get.snackbar(
    //     notification.title ?? 'no title', notification.body ?? 'no body');
    await _localNotificationsPlugin.show(
      message.hashCode,
      notification.title ?? '',
      notification.body ?? '',
      NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: payload,
    );
  }

  Future<void> _configureNotificationClickHandling() async {
    FirebaseMessaging.onMessageOpenedApp.listen(_handelRemoteMesageClick);
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handelRemoteMesageClick(initialMessage);
    }
  }

  void _handelRemoteMesageClick(RemoteMessage message) {
    _navigateFromData(message.data);
  }

  void _navigateFromData(Map<String, dynamic> data) async {
    final String? notificationId = data["notificationId"];

    if (notificationId != null && UserSession.uid != null) {
      unawaited(_updateIsRead(notificationId));
    }

    RouteHandler.notificationRouteHandler(data);
    // // Future.delayed(Duration(milliseconds: 200), () {
    //   RouteHandler.notificationRouteHandler(data);
    // // });
  }

  Future<void> _updateIsRead(String notificationId) async {
    if (UserSession.uid == null) return;

    final res = await UserNotificationService().updateIsReade(
      uId: UserSession.uid!,
      notificationId: notificationId,
    );
    debugPrint("READ UPDATE RESULT: ${res.type}");
  }

  void _handLocalNotificationClick(String? payload) {
    if (payload == null || payload.isEmpty) return;
    try {
      final decoded = jsonDecode(payload);
      if (decoded is Map<String, dynamic>) {
        _navigateFromData(decoded);
      } else if (decoded is Map) {
        _navigateFromData(decoded.cast<String, dynamic>());
      }
    } catch (_) {
      //ignore malformed payload silently
    }
  }

  Future<void> _loadInitialToken(void Function(String token) onToken) async {
    final token = await _messaging.getToken(); //
    if (token != null && token.isNotEmpty) {
      onToken(token);
    }
  }

  void _listenToTokenRefresh(void Function(String token) onToken) {
    _messaging.onTokenRefresh.listen((token) {
      if (token.isNotEmpty) {
        onToken(token);
      }
    }); //
  }

  Future<bool> areNotificationsAllowed() async {
    final settings = await _messaging.getNotificationSettings();
    final status = settings.authorizationStatus;
    return status == AuthorizationStatus.authorized ||
        status == AuthorizationStatus.provisional;
  }

  Future<void> deleteToken() async {
    _messaging.deleteToken();
  }
}
