import 'package:firebase_auth/firebase_auth.dart';
import 'package:freelancing_platform/core/classes/user_session.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/core/utils/helper_function/handle_firebase_check.dart';
import 'package:freelancing_platform/core/widgets/custom_snackbar.dart';
import 'package:freelancing_platform/data/services/fcm_token_array_service.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignOutController extends GetxController {
  bool signOutIsLoading = false;

  Future<void> signOut() async {
    signOutIsLoading = true;
    update();
    //بتحقق من الاتصال بالنت ووجود المستخدم اصلا
    if (!await handleFirebaseCheck()) {
      signOutIsLoading = false;
      update();
      return;
    }

    //تسجيل الخروج بغوغل لو كان داخل فيه
    GoogleSignIn googleSignIn = GoogleSignIn();
    googleSignIn.signOut();

    final uId = UserSession.uid;
    // print("!!!!!!!!!!$uId");
    //لازم احذف الsharedPrefrences المحفوظه للمستخدم بعد ما سجل دخوله
    UserSession.clear();

    //تسجيل خروج اذا مسجل بالايميل
    await FirebaseAuth.instance.signOut();
    signOutIsLoading = false;
    update();
    //توجيه لصفحة البداية
    customSnackbar(message: "تم تسجيل الخروج بنجاح");
    Get.offAllNamed(AppRoutes.welcome);
    if (uId != null) {
      final token = await LocalStorageService.getStringValue(AppKeys.fcmToken);

      if (token != null && token.isNotEmpty) {
        await FcmTokenArrayService().removeToken(uid: uId, token: token);
        // await FirebaseFirestore.instance
        //     .collection(CollectionsNames.users)
        //     .doc(uId)
        //     .update({
        //   "fcmTokens": FieldValue.arrayRemove([token])
        // });
      }
      // UserService().updateUserData2({"fcmToken": null}, uId);
    }
    // LocalStorageService.removeValue(AppKeys.fcmToken);
  }
}
