import 'package:firebase_auth/firebase_auth.dart';
import 'package:freelancing_platform/core/classes/user_session.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/core/utils/helper_function/handle_firebase_check.dart';
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

    //لازم احذف الsharedPrefrences المحفوظه للمستخدم بعد ما سجل دخوله
    // LocalStorageService.removeValue(AppKeys.uid);
    // LocalStorageService.removeValue(AppKeys.role);
    // LocalStorageService.setConstantUid();
    // LocalStorageService.setConstantRole();
    UserSession.clear();

    //تسجيل خروج اذا مسجل بالايميل
    await FirebaseAuth.instance.signOut();
    signOutIsLoading = false;
    update();
    //توجيه لصفحة البداية
    Get.snackbar("success", "تم تسجيل الخروج بنجاح");
    Get.offAllNamed(AppRoutes.welcome);
  }
}
