import 'package:firebase_auth/firebase_auth.dart';
import 'package:freelancing_platform/core/constants/app_keys.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/core/utils/helper_function/handle_firebase_check.dart';
import 'package:freelancing_platform/services/local_storage_service.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignOutController extends GetxController {
  Future<void> signOut() async {
    //بتحقق من الاتصال بالنت ووجود المستخدم اصلا
    if (!await handleFirebaseCheck()) return;

    //تسجيل الخروج بغوغل لو كان داخل فيه
    GoogleSignIn googleSignIn = GoogleSignIn();
    googleSignIn.signOut();

    //لازم احذف الsharedPrefrences المحفوظه للمستخدم بعد ما سجل دخوله
    LocalStorageService.removeValue(AppKeys.uid);
    LocalStorageService.removeValue(AppKeys.role);
    LocalStorageService.setConstantUid();
    LocalStorageService.setConstantRole();

    //تسجيل خروج اذا مسجل بالايميل
    await FirebaseAuth.instance.signOut();

    //توجيه لصفحة البداية
    Get.snackbar("success", "تم تسجيل الخروج بنجاح");
    Get.offAllNamed(AppRoutes.join);
  }
}
