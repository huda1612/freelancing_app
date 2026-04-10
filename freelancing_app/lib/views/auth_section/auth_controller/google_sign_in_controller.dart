import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/utils/helper_function/handle_firebase_check.dart';
import 'package:freelancing_platform/core/widgets/custom_button.dart';
import 'package:freelancing_platform/models/user_collections/user_model.dart';
import 'package:freelancing_platform/views/auth_section/auth_controller/auth_controller.dart';
import 'package:freelancing_platform/views/auth_section/widgets/role_option.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInController extends GetxController {
  Future<void> signInWithGoogle() async {
    try {
      if (!await handleFirebaseCheck(loginRequired: false)) return;

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return;
      } // المستخدم ألغى العملية

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      //لهون بكون سجل المستخدم دخوله خلص
      //هلأ بدي اتأكد لو ما موجود يقاعدة البيانات بضيفه
      User? user = userCredential.user;
      if (user == null) {
        return;
      }
      await _addUserToFirestoreIfItsNotExist(user);

      // Get.snackbar("نجاح", "تم تسجيل الدخول");
    } catch (e) {
      Get.snackbar("فشل", "فشل تسجيل الدخول $e");
    }
  }

  Future<void> _addUserToFirestoreIfItsNotExist(User user) async {
    final controller = Get.find<AuthController>();
    // **الآن نتأكد إذا موجود في Firestore**
    DocumentReference userDoc =
        FirebaseFirestore.instance.collection('Users').doc(user.uid);

    final snapshot = await userDoc.get();

    if (!snapshot.exists) {
      String? role = await Get.dialog(
        SimpleDialog(
          title: Text(
            'اختر نوع الحساب',
            textAlign: TextAlign.center,
          ),
          children: [
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // زر العميل
                    RoleOption(
                      label: "عميل",
                      icon: Icons.person_outline,
                      isSelected: controller.userRole.value == "client",
                      onTap: () => controller.userRole.value = "client",
                    ),

                    SizedBox(width: 16.w),

                    // زر المستقل
                    RoleOption(
                      label: "مستقل",
                      icon: Icons.work_outline,
                      isSelected: controller.userRole.value == "freelancer",
                      onTap: () => controller.userRole.value = "freelancer",
                    ),
                  ],
                )),
            SizedBox(height: AppSpaces.heightLarge),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 120.w),
              child: SizedBox(
                child: CustomButton(
                  text: "موافق",
                  onTap: () => Get.back(result: controller.userRole.value),
                  height: 50.h,
                ),
              ),
            ),

            // SizedBox(
            //     width: 100.w,
            //     child: CustomButton(
            //         text: "موافق",
            //         width: 50.w,
            //         onTap: () => Get.back(result: controller.userRole.value))),
            // SimpleDialogOption(
            //   child: Text('عميل'),
            //   onPressed: () => Get.back(result: 'client'),
            // ),
            // SimpleDialogOption(
            //   child: Text('مقدم خدمة'),
            //   onPressed: () => Get.back(result: 'freelancer'),
            // ),
          ],
        ),
      );
      if (role == null) {
        await FirebaseAuth.instance.currentUser?.delete();
        Get.snackbar("تم الإلغاء", "تم إلغاء تسجيل الدخول");
        return;
      } // المستخدم ألغى اختيار الدور

      // المستخدم جديد → نضيفه للـ Users collection
      String fullName = user.displayName ?? "";
      // نقسم الاسم حسب الفراغات
      List<String> nameParts = fullName.split(" ");
      // الاسم الأول = أول عنصر
      String firstName = nameParts.isNotEmpty ? nameParts[0] : "";
      // الاسم الأخير = الباقي بعد الاسم الأول
      String lastName =
          nameParts.length > 1 ? nameParts.sublist(1).join(" ") : "";
      //انشاء غرض للمستخدم
      final newUser = UserModel(
        uid: user.uid,
        fname: firstName,
        lname: lastName,
        email: user.email ?? '',
        role: role,
        photoUrl: user.photoURL ?? '',
      );
      //ادخال المستخدم في قاعدة البيانات
      try {
        await userDoc.set(newUser.toMap());
      } catch (e) {
        await FirebaseAuth.instance.currentUser?.delete();
        Get.snackbar("خطأ", "حدث خطأ بادخال المستخدم في قاعدة البيانات : $e");
        return;
      } //هي بحال فشل ادخال سجل للمستخدم بقاعدة البيانات
    }
    Get.snackbar("نجاح", "تم تسجيل الدخول");
  }
}
