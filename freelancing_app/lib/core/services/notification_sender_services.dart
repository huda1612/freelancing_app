import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
// import 'package:freelancing_platform/core/widgets/custom_snackbar.dart';
import 'package:freelancing_platform/data/services/user_notification_service.dart';
import 'package:freelancing_platform/data/services/user_service.dart';
import 'package:freelancing_platform/models/user_collections/notification_model.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;

class NotificationSenderServices {
  static String projectId = 'freelance-app-78e07';
  static String servicesData = r'''
{
  
}
''';
  static Future<StatusClasses> sendNotificationToSelectedToken(
      {required String fcmToken,
      required String title,
      required String body,
      Map<String, dynamic>? data}) async {
    if (fcmToken.trim().isEmpty) {
      debugPrint("!!!! fcm token is empty");
      return StatusClasses.customError("fcm token is empty");
    }
    final serviceAccount = jsonDecode(servicesData) as Map<String, dynamic>;
    final credentials = auth.ServiceAccountCredentials.fromJson(serviceAccount);
    final client = await auth.clientViaServiceAccount(credentials, [
      'https://www.googleapis.com/auth/firebase.messaging',
    ]);
    try {
      print(
        jsonEncode({
          'message': {
            'token': fcmToken.trim(),
            'notification': {'title': title, 'body': body},
            'data': data,
            'android': {
              'priority': 'high',
              'notification': {'sound': 'default'},
            },
          },
        }),
      );
      final response = await client.post(
        Uri.parse(
          'https://fcm.googleapis.com/v1/projects/$projectId/messages:send',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'message': {
            'token': fcmToken.trim(),
            'notification': {'title': title, 'body': body},
            'data': data,
            'android': {
              'priority': 'high',
              'notification': {'sound': 'default'},
            },
          },
        }),
      );
      if (response.statusCode < 200 || response.statusCode >= 300) {
        debugPrint(
            "sending notification error : ${response.statusCode} ${response.body}");
        return StatusClasses.customError(
            "sending notification error : ${response.statusCode} ${response.body}");
      }
      return StatusClasses.success;
    } catch (e) {
      return StatusClasses.customError(e.toString());
    } finally {
      client.close();
    }
  }

  static Future<void> sendNotificationToUser(
      {required String uId,
      required String title,
      required String body,
      Map<String, dynamic>? data}) async {
    ///1- fetch user fcm token from firestore
    final response = await UserService().fetchUserData2(uId);
    response.fold((errorStatus) {
      debugPrint("${errorStatus.type} / ${errorStatus.message}");
      return;
    }, (user) async {
      // print(user.uid);
      // if (userFcmToken == null || userFcmToken.isEmpty) {
      //   print("!!!! no token");
      //   // return;
      // }
      //
      ///2- sending notification to user if there is a fcm token
      // final userFcmToken = user.fcmToken;
      final tokens = user.fcmTokens;
      for (final token in tokens ?? []) {
        await sendNotificationToSelectedToken(
          fcmToken: token,
          title: title,
          body: body,
          data: data,
        );
      }
      // if (userFcmToken != null && userFcmToken.isNotEmpty) {
      //   final sendingResponse = await sendNotificationToSelectedToken(
      //     fcmToken: userFcmToken,
      //     title: title,
      //     body: body,
      //     data: data,
      //   );
      //   if (sendingResponse != StatusClasses.success) {
      //     debugPrint(
      //         "sending notification error 1: ${sendingResponse.type} ${sendingResponse.message}");
      //   }
      // } else {
      //   debugPrint("!!!! no token");
      // }

      ///3- store the notification in the uesr's notification collection in firestore
      final notificationAddRes = await UserNotificationService()
          .addUserNotification(
              uId: uId,
              notification:
                  NotificationModel(title: title, body: body, data: data));
      if (notificationAddRes != StatusClasses.success) {
        debugPrint(
            "sending notification error2 : ${notificationAddRes.type} ${notificationAddRes.message}");

        return;
      }
    });
  }
}
