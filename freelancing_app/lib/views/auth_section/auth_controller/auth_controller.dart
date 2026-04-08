import 'package:firebase_auth/firebase_auth.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/data/services/auth_service.dart';
import 'package:freelancing_platform/core/utils/helper_function/validators.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final email = ''.obs;
  final password = ''.obs;
  final confirmPassword = ''.obs;
  var userRole = 'client'.obs;
  var firstName = ''.obs;
  var lastName = ''.obs;
  final isLoginLoading = false.obs;
  final isRegisterLoading = false.obs;

  Future<void> sendVerificationEmail() async {
    User? user = _authService.currentUser;
    if (user != null && !user.emailVerified) {
      await _authService.resendVerificationEmail();
    }
  }

  void resetPassword() async {
    final emailError = Validators.email(email.value);
    //التحقق من ادخال الايميل
    if (emailError != null) {
      Get.snackbar("خطأ", emailError);
      return;
    }

    try {
      await _authService.resetPassword(email.value);
      // يظهر رسالة للمستخدم
      Get.defaultDialog(
        title: "تم الإرسال",
        middleText: "تم إرسال رابط لإعادة تعيين كلمة السر إلى بريدك الإلكتروني",
        textConfirm: "حسناً",
        onConfirm: () => Get.back(),
      );
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found') {
        message = "هذا المستخدم غير موجود";
      } else {
        message = e.message ?? "حدث خطأ غير معروف";
      }
      Get.snackbar("خطأ", message);
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ غير معروف");
    }
  }

  void login() async {
    final emailError = Validators.email(email.value);
    final passError = Validators.password(password.value);

    if (emailError != null || passError != null) {
      Get.snackbar("خطأ", emailError ?? passError!);
      return;
    }
    try {
      isLoginLoading.value = true;
      await _authService.login(email: email.value, password: password.value);
      Get.snackbar("نجاح", "تم تسجيل الدخول");
      if (!_authService.currentUser!.emailVerified) {
        Get.toNamed(AppRoutes.verifyEmail);
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = "هذا الحساب غير مسجّل";
          break;
        case 'wrong-password':
          message = "كلمة المرور غير صحيحة";
          break;
        case 'invalid-email':
          message = "البريد الإلكتروني غير صالح";
          break;
        case 'user-disabled':
          message = "تم تعطيل هذا الحساب";
          break;
        default:
          message = "فشل تسجيل الدخول، تأكد من البيانات";
      }
      Get.snackbar("خطأ", message);
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ غير معروف $e");
    } finally {
      isLoginLoading.value = false;
    }
  }

  void register() async {
    final emailError = Validators.email(email.value);
    final passError = Validators.password(password.value);
    final confirmError =
        Validators.confirmPassword(confirmPassword.value, password.value);
    final fnameError = Validators.firstName(firstName.value);
    final lnameError = Validators.lastName(lastName.value);

    if (emailError != null ||
        passError != null ||
        confirmError != null ||
        fnameError != null ||
        lnameError != null) {
      Get.snackbar("خطأ",
          fnameError ?? lnameError ?? emailError ?? passError ?? confirmError!);
      return;
    }

    try {
      isRegisterLoading.value = true;
      await _authService.registerUser(
        firstName: firstName.value,
        lastName: lastName.value,
        email: email.value,
        password: password.value,
        role: userRole.value,
      );
      Get.snackbar("نجاح", "تم إنشاء الحساب");
      Get.toNamed(AppRoutes.verifyEmail);
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'email-already-in-use') {
        message = "البريد الإلكتروني مستخدم مسبقًا";
      } else if (e.code == 'weak-password') {
        message = "كلمة المرور ضعيفة جدًا";
      } else if (e.code == 'invalid-email') {
        message = "البريد الإلكتروني غير صحيح";
      } else {
        message = e.message ?? "حدث خطأ غير معروف";
      }
      Get.snackbar("خطأ", message);
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ غير معروف : $e");
    } finally {
      isRegisterLoading.value = false;
    }
  }
}
