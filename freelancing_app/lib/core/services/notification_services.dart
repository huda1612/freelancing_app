import 'package:firebase_messaging/firebase_messaging.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

class NotificationServices {
  NotificationServices();
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initialize(
      {required void Function(String token) onToken}) async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await _requestPermission();
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
}
