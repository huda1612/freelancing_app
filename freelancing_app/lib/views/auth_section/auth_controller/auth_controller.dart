import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freelancing_platform/core/classes/firebase_crud.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/core/constants/collections_names.dart';
import 'package:freelancing_platform/core/utils/helper_function/handle_firebase_check.dart';
import 'package:freelancing_platform/data/services/auth_service.dart';
import 'package:freelancing_platform/core/utils/helper_function/validators.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final email = ''.obs;
  final password = ''.obs;
  final confirmPassword = ''.obs;
  var userRole = 'client'.obs;
  var firstName = ''.obs;
  var lastName = ''.obs;
  var agreed = false.obs;
  final isLoginLoading = false.obs;
  final isRegisterLoading = false.obs;
  final username = ''.obs;
  final usernameError = RxnString();
  Timer? _usernametimer;

  //لانشاء عداد لاعادة تعيين كلمة السر
  final sendEmailResetIsLoading = false.obs;
  final canResend = true.obs;
  final resendSeconds = 0.obs;
  Timer? _resendTimer;

  void _startCooldown({int seconds = 30}) {
    _resendTimer?.cancel(); // مهم جداً

    canResend.value = false;
    resendSeconds.value = seconds;

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendSeconds.value == 0) {
        timer.cancel();
        canResend.value = true;
      } else {
        resendSeconds.value--;
      }
    });
  }

//------------------------------------------------------------------------توابع التحقق من اسم المستخدم--------------------------------------------

  Future<String?> checkUsername(String value, bool afterRegister) async {
    if (!afterRegister) {
      //لان بتسجيل الدخول في تحقق من هالشي اصلا مافي داعي استخدمه هون بوقتها بس بعد التغيير للحقل بستخدمه
      if (Validators.username(value) != null) {
        return Validators.username(value);
      }
    }
    final doc = await _firestore
        .collection(CollectionsNames.usernames)
        .doc(value)
        .get();

    if (doc.exists) {
      return "اسم المستخدم هذا محجوز مسبقا";
    } else {
      return null;
    }
  }

  void onUsernameChanged(String value) async {
    username.value = value;
    usernameError.value = null; // reset أول شي
    _usernametimer?.cancel();

    _usernametimer = Timer(const Duration(milliseconds: 500), () async {
      usernameError.value =
          await checkUsername(value, false); // null = valid / string = error
    });
  }

  //------------------------------------------------------------------------تابع اعادة تعيين كلمة السر---------------------------------------------

  void resetPassword() async {
    sendEmailResetIsLoading.value = true;
    if (!await handleFirebaseCheck(loginRequired: false)) {
      sendEmailResetIsLoading.value = false;
      return;
    }

    final emailError = Validators.email(email.value);
    //التحقق من ادخال الايميل
    if (emailError != null) {
      Get.snackbar("خطأ", emailError);
      sendEmailResetIsLoading.value = false;
      return;
    }

    try {
      await _authService.resetPassword(email.value);
      Get.back();
      _startCooldown();
      // يظهر رسالة للمستخدم
      sendEmailResetIsLoading.value = false;
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
      sendEmailResetIsLoading.value = false;
      Get.snackbar("خطأ", message);
    } catch (e) {
      sendEmailResetIsLoading.value = false;
      Get.snackbar("خطأ", "حدث خطأ غير معروف");
    }
  }

//------------------------------------------------------------------------تابع تسجيل الدخول ---------------------------------------------

  void login() async {
    final emailError = Validators.email(email.value);
    final passError = Validators.password(password.value);

    if (emailError != null || passError != null) {
      Get.snackbar("خطأ", emailError ?? passError!);
      return;
    }
    try {
      isLoginLoading.value = true;

      if (!await handleFirebaseCheck(loginRequired: false)) {
        isLoginLoading.value = false;
        return;
      }

      isLoginLoading.value = true;

      await _authService.login(email: email.value, password: password.value);
      Get.snackbar("نجاح", "تم تسجيل الدخول");
      if (!_authService.currentUser!.emailVerified) {
        //مؤقته للتجربه
        // Get.toNamed(AppRoutes.personalInfo);
        Get.offAllNamed(AppRoutes.verifyEmail);
      } else {
        Get.offAllNamed(AppRoutes.personalInfo);
        //هون لازم اعمل التوجيه حسب حالة الطلب عنده!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      }
    } on FirebaseAuthException catch (e) {
      // print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" + e.toString());
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

//------------------------------------------------------------------------تابع انشاء الحساب---------------------------------------------
  void register() async {
    isRegisterLoading.value = true;
    try {
      //اولا التحقق من الحقول

      final emailError = Validators.email(email.value);
      final passError = Validators.password(password.value);
      final confirmError =
          Validators.confirmPassword(confirmPassword.value, password.value);
      final fnameError = Validators.firstName(firstName.value);
      final lnameError = Validators.lastName(lastName.value);
      final usernameError = Validators.username(username.value);

      if (emailError != null ||
          passError != null ||
          confirmError != null ||
          fnameError != null ||
          lnameError != null ||
          usernameError != null) {
        Get.snackbar(
            "خطأ",
            fnameError ??
                lnameError ??
                usernameError ??
                emailError ??
                passError ??
                confirmError!);
        // isRegisterLoading.value = false;
        return;
      }
      //التحقق من عدم تكرار اسم المستخدم
      final checkusername = await checkUsername(username.value, true);
      if (checkusername != null) {
        Get.snackbar("خطأ", "اسم المستخدم مستخدم مسبقا");
        // isRegisterLoading.value = false;
        return;
      }
      if (!agreed.value) {
        Get.snackbar("خطأ",
            "لا يمكنك التسجيل بدون الموافقة على شروط الخدمة وسياسة الخصوصية");
        // isRegisterLoading.value = false;
        return;
      }

      //ثانيا بدنا نعمل حساب المستخدم بما ان كل الحقول صح
      // try {
      // isRegisterLoading.value = true;

      //التحقق من الانترنت
      if (!await handleFirebaseCheck(loginRequired: false)) {
        // isRegisterLoading.value = false;
        return;
      }

      //انشاء حساب المستخدم وتسجيل دخوله
      await _authService.registerUser(
        firstName: firstName.value,
        lastName: lastName.value,
        username: username.value,
        email: email.value,
        password: password.value,
        role: userRole.value,
      );

      //لنضيف اسم المستخدم لقاعدة البيانات لضمان عدم تكراره
      StatusClasses st = await FirebaseCrud.createDocument(
          docId: username.value,
          collectionRef: _firestore.collection(CollectionsNames.usernames),
          body: {"uid": FirebaseAuth.instance.currentUser!.uid});

      //بحال ما نجحت العملية
      if (st != StatusClasses.success) {
        await FirebaseAuth.instance.currentUser?.delete();
        Get.snackbar("خطأ", "حدث خطأ اثناء انشاء الحساب");
        isRegisterLoading.value = false;
        return;
      }

      //بحال كل شي مر بدون اخطاء
      Get.snackbar("نجاح", "تم إنشاء الحساب");
      //نوجهه لصفحة التحقق من الايميل ليتحقق منه
      Get.offAllNamed(AppRoutes.verifyEmail);
    } on FirebaseAuthException catch (e) {
      //بحال صار خطأ بانشاء الحساب منطلعله الخطأ اللي اجا من الفاير بيز
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
      //بحال صار اي خطأ ثاني بانشاء الحساب وما انعمل
      Get.snackbar("خطأ", "حدث خطأ غير معروف : $e");
    } finally {
      isRegisterLoading.value = false;
    }
  }
}
