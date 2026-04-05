import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:freelancing_platform/core/utils/helper_function/validators.dart';
import 'package:freelancing_platform/models/user_collections/user_model.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final email = ''.obs;
  final password = ''.obs;
  final confirmPassword = ''.obs;
  var userRole = 'client'.obs; // client أو freelancer
  var firstName = ''.obs;
  var lastName = ''.obs;
  final isLoginLoading = false.obs;
  final isRegisterLoading = false.obs;

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
      isLoginLoading.value = true;
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
    } finally {
      isLoginLoading.value = false;
    }
  }

  void register() async {
    //اول شي عم نتحقق من ان مافي خطأ بالحقول هي وإلا رح يعطي سناك بار بأول خطأ طلع بس
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
      //انشأت المستخدم اول شي بالفايربيز
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.value, password: password.value);

      print("current user : ${FirebaseAuth.instance.currentUser}");

      //بعدين بدي دخل بيانات المستخدم بقاعدة البيانات
      final uid = userCredential.user!.uid;
      final newUser = UserModel(
        uid: uid,
        fname: firstName.value,
        lname: lastName.value,
        email: email.value,
        role: userRole.value,
      );
     
      try {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(uid)
            .set(newUser.toMap());
        Get.snackbar("نجاح", "تم إنشاء الحساب");
      } catch (e) {
        // إذا فشل الحفظ في Firestore، نحذف المستخدم اللي انشأناه
        await FirebaseAuth.instance.currentUser?.delete();
        Get.snackbar("خطأ", "حدث خطأ بادخال المستخدم في قاعدة البيانات : $e");

        rethrow; // لحتى يوصل للـ catch الخارجي
      }
      // await sendVerificationEmail();
      await userCredential.user!.sendEmailVerification();
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
      Get.snackbar("خطأ", "حدث خطأ غير معروف : $e");
    } finally {
      isRegisterLoading.value = false;
    }
  }
}
