import 'dart:async';
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
      {required auth.AutoRefreshingAuthClient client, //اضافي
      required String fcmToken,
      required String title,
      required String body,
      Map<String, dynamic>? data}) async {
    if (fcmToken.trim().isEmpty) {
      debugPrint("!!!! fcm token is empty");
      return StatusClasses.customError("fcm token is empty");
    }
    // final serviceAccount = jsonDecode(servicesData) as Map<String, dynamic>;
    // final credentials = auth.ServiceAccountCredentials.fromJson(serviceAccount);
    // final client = await auth.clientViaServiceAccount(credentials, [
    //   'https://www.googleapis.com/auth/firebase.messaging',
    // ]);
    try {
      // print(
      //   jsonEncode({
      //     'message': {
      //       'token': fcmToken.trim(),
      //       'notification': {'title': title, 'body': body},
      //       'data': data,
      //       'android': {
      //         'priority': 'high',
      //         'notification': {'sound': 'default'},
      //       },
      //     },
      //   }),
      // );
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
    }
    // finally {
    //   client.close();
    // }
  }

  static Future<auth.AutoRefreshingAuthClient> _getClient() async {
    final serviceAccount = jsonDecode(servicesData) as Map<String, dynamic>;
    final credentials = auth.ServiceAccountCredentials.fromJson(serviceAccount);
    final client = await auth.clientViaServiceAccount(credentials, [
      'https://www.googleapis.com/auth/firebase.messaging',
    ]);

    return client;
  }

  static Future<void> sendNotificationToUser(
      {required String uId,
      required String title,
      required String body,
      Map<String, dynamic>? data}) async {
    ///1- fetch user fcm token from firestore
    final response = await UserService().fetchUserData2(uId);
    await response.fold((error) async {
      debugPrint("${error.type} / ${error.message}");
      return;
    }, (user) async {
      final notificationId =
          UserNotificationService().generateNotificationId(uId);
      final updatedData = {
        ...?data,
        "notificationId": notificationId,
      };

      final tokens = user.fcmTokens ?? [];

      /// 2. Send notification to all FCMs

      final client = await _getClient();
      //لحتى ما يتم انشاء كلاينت لكل توكن بعمل واحد بس و برسل لكل الاجهزة بعدين بقفل
      try {
        await Future.wait(tokens.map((token) {
          return sendNotificationToSelectedToken(
            client: client,
            fcmToken: token,
            title: title,
            body: body,
            data: updatedData,
          );
        }));
      } finally {
        client.close();
      }
      // for (final token in tokens) {
      //   await sendNotificationToSelectedToken(
      //     fcmToken: token,
      //     title: title,
      //     body: body,
      //     data: updatedData,
      //   );
      // }

      ///3- store the notification in the uesr's notification collection in firestore
      // final notificationAddRes = await
      unawaited(UserNotificationService()
          .addUserNotification(
              uId: uId,
              notificationId: notificationId,
              notification: NotificationModel(
                  title: title, body: body, data: updatedData))
          .then((res) {
        if (res != StatusClasses.success) {
          debugPrint("notification store failed:  ${res.type} ${res.message}");
        }
      }));

      // if (notificationAddRes != StatusClasses.success) {
      //   debugPrint(
      //       "storing notification error : ${notificationAddRes.type} ${notificationAddRes.message}");

      //   return;
      // }
    });
  }
}
