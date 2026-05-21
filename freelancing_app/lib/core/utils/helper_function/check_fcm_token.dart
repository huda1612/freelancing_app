import 'package:flutter/foundation.dart';
import 'package:freelancing_platform/core/classes/user_session.dart';
import 'package:freelancing_platform/core/constants/app_keys.dart';
import 'package:freelancing_platform/core/services/local_storage_service.dart';
import 'package:freelancing_platform/core/utils/helper_function/check_login.dart';
import 'package:freelancing_platform/data/services/fcm_token_array_service.dart';

Future<void> checkFcmToken(String token) async {
  debugPrint("FCM Token : $token");
  final oldFcmToken =
      await LocalStorageService.getStringValue(AppKeys.fcmToken);
  // debugPrint("!!!old fcm !$oldFcmToken");
  if (token == oldFcmToken) return;

  await LocalStorageService.setStringValue(AppKeys.fcmToken, token);

  if (isLogin()) {
    final uid = UserSession.uid!;
    if (oldFcmToken != null && oldFcmToken.isNotEmpty) {
      await FcmTokenArrayService()
          .replaceToken(newToken: token, oldToken: oldFcmToken, uid: uid);
    } else {
      await FcmTokenArrayService().addToken(uid: uid, token: token);
    }
  }
  // if (isLogin()) {
  //   final uid = UserSession.uid!;
  //   if (oldFcmToken == null || oldFcmToken.isEmpty) {
  //     await FcmTokenArrayService().addToken(uid: uid, token: token);
  //   } else {
  //     await FcmTokenArrayService()
  //         .replaceToken(newToken: token, oldToken: oldFcmToken, uid: uid);
  //   }
  //   // final userDoc = FirebaseFirestore.instance.collection(CollectionsNames.users).doc(uid);

  //   // await userDoc.set({
  //   //   "fcmTokens": FieldValue.arrayUnion([token])
  //   // }, SetOptions(merge: true));
  //   // await UserService().updateUserData2({"fcmToken": token}, UserSession.uid!);
  // }
}
