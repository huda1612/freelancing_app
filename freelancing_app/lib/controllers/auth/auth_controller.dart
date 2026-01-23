import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:freelancing_platform/core/utils/helper_function/validators.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final email = ''.obs;
  final password = ''.obs;
  final confirmPassword = ''.obs;

  Future<void> sendVerificationEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  void resetPassword() async {
    final emailError = Validators.email(email.value);
    //التحقق من ادخال الايميل
    if (emailError != null) {
      Get.snackbar("خطأ", emailError);
      return;
    }

    // تحقق من وجود المستخدم في Firestore
    final userDoc = await FirebaseFirestore.instance
        .collection('Users')
        .where('email', isEqualTo: email.value)
        .get();

    if (userDoc.docs.isEmpty) {
      Get.snackbar("خطأ", "هذا المستخدم غير موجود");
      return;
    }

    //ارسال ايميل اعادة تعيين كلمة السر
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.value);
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
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.value, password: password.value);
      Get.snackbar("نجاح", "تم تسجيل الدخول");
      if (FirebaseAuth.instance.currentUser!.emailVerified) {
        // Get.toNamed("") //the home page !!!!!!!!!!!!!!!!
      } else {
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
      // print("##########################################################");
      // print(e);
    }
  }

  void register() async {
    final emailError = Validators.email(email.value);
    final passError = Validators.password(password.value);
    final confirmError =
        Validators.confirmPassword(confirmPassword.value, password.value);

    if (emailError != null || passError != null || confirmError != null) {
      Get.snackbar("خطأ", emailError ?? passError ?? confirmError!);
      return;
    }

    try {
      //انشأت المستخدم اول شي
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.value, password: password.value);

      final uid = userCredential.user!.uid;
      //بدي دخل بيانات المستخدم بقاعدة البيانات
      await FirebaseFirestore.instance.collection('Users').doc(uid).set({
        'name': '', //هون لازم يكون مدخل حقل للاسم لازم نضيفه!!!!!!!!!!!
        'email': email.value,
        'role':
            'client', // أو 'freelancer' حسب اختيار المستخدم لازم نضيف حقل للنوع !!!!!!!
        'photoUrl': '', // افتراضي فارغ
        'bio': '',
        'skills': [],
        'rating': 0.0,
        'completed_projects': 0,
        'points': 0,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // المجموعات الفرعية يمكن إضافتها لاحقًا عند الحاجة
      // portfolio, reviews, suggestions, activities

      Get.snackbar("نجاح", "تم إنشاء الحساب");

      await sendVerificationEmail();

      Get.toNamed("/verify-email"); //the email validate page
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
      Get.snackbar("خطأ", "حدث خطأ غير معروف");
    }
  }
}
