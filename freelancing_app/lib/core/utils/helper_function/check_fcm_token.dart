// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:freelancing_platform/core/classes/user_session.dart';
import 'package:freelancing_platform/core/constants/app_keys.dart';
import 'package:freelancing_platform/core/services/local_storage_service.dart';
import 'package:freelancing_platform/core/utils/helper_function/check_login.dart';
import 'package:freelancing_platform/data/services/user_service.dart';

Future<void> checkFcmToken(String token) async {
  debugPrint("FCM Token : $token");
  final oldFcmToken =
      await LocalStorageService.getStringValue(AppKeys.fcmToken);
  if (token == oldFcmToken) return;

  await LocalStorageService.setStringValue(AppKeys.fcmToken, token);

  if (isLogin()) {
    await UserService().updateUserData2({"fcmToken": token}, UserSession.uid!);
  }
}
