import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/core/utils/helper_function/handle_firebase_check.dart';
import 'package:freelancing_platform/data/services/auth_service.dart';
import 'package:get/get.dart';

class VerificationEmailController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  StatusClasses state = StatusClasses.idle;
  final canResend = true.obs;
  final resendSeconds = 0.obs;
  Timer? _timer;

  //لالغاء تفعيل الزر بعد ارسال الايميل لمنع تكرار الضغط عالزر كتير
  void startCooldown({int seconds = 30}) {
    _timer?.cancel(); // مهم جداً

    canResend.value = false;
    resendSeconds.value = seconds;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendSeconds.value == 0) {
        timer.cancel();
        canResend.value = true;
      } else {
        resendSeconds.value--;
      }
    });
  }

  Future<void> sendVerificationEmail() async {
    state = StatusClasses.isloading;
    update();
    User? user = _authService.currentUser;
    if (user != null && !user.emailVerified) {
      if (!await handleFirebaseCheck()) {
        state = StatusClasses.unknown;
        update();
        return;
      }
      try {
        await _authService.resendVerificationEmail();
        Get.snackbar(
          "تم الإرسال",
          "تم إرسال رابط التفعيل مرة أخرى",
        );
        state = StatusClasses.success;
        startCooldown();
        update();
        return;
      } catch (e) {
        // print("!!!!!!!!!!!!!" + e.toString());
        Get.snackbar("خطأ", "يرجى الانتظار قليلا قبل اعادة المحاولة مجددا");
        state = StatusClasses.idle;
        update();
        return;
      }
    } else if (user == null) {
      Get.snackbar("خطأ", "لا يوجد مستخدم ، الرجاء تسجيل الدخول اولا");
      state = StatusClasses.idle;
      update();
      Get.offAllNamed(AppRoutes.login);
      return;
    } else if (user.emailVerified) {
      Get.snackbar("تنبيه !",
          "لقد تم التحقق من حسابك بالفعل يرجى الضغط على زر تم التفعيل");
      state = StatusClasses.idle;
      update();
      return;
    }
  }

  Future<void> checkIfVerified() async {
    state = StatusClasses.isloading;
    update();
    if (!await handleFirebaseCheck()) return;
    User? user = _authService.currentUser;
    if (user == null) {
      Get.snackbar("خطأ", "لا يوجد مستخدم مسجل يرجى تسجيل الدخول");
      state = StatusClasses.idle;
      update();
      Get.offAllNamed(AppRoutes.login);
      return;
    }
    await FirebaseAuth.instance.currentUser!.reload();
    if (!user.emailVerified) {
      state = StatusClasses.idle;
      update();
      Get.snackbar("لم يتم التفعيل بعد", "يرجى اعادة المحاولة");
      return;
    } else {
      state = StatusClasses.idle;
      update();
      Get.snackbar("تم تفعيل حسابك", "ابدأ بملئ بياناتك الشخصية");
      // Get.offAllNamed(AppRoutes.personalInfo);
      return;
    }
  }
}
