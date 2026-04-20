import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freelancing_platform/core/classes/firebase_crud.dart';
import 'package:freelancing_platform/core/classes/route_handler.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/constants/collections_names.dart';
import 'package:freelancing_platform/core/utils/helper_function/handle_firebase_check.dart';
import 'package:freelancing_platform/data/services/auth_service.dart';
import 'package:freelancing_platform/models/user_collections/user_model.dart';
import 'package:freelancing_platform/views/auth_section/auth_controller/auth_controller.dart';

import 'package:freelancing_platform/views/auth_section/widgets/role_username_set_dialog.dart';
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
      await _addUserToFirestoreIfItsNotExistAndSaveTheUserSeeion(user);
      //لازم وجهه !!!!!
       var nextRoute = await RouteHandler.firstRoutHandler();
      Get.offAllNamed(nextRoute);
      //مؤقتا
      // Get.offAllNamed(AppRoutes.personalInfo);
    } catch (e) {
      Get.snackbar("فشل", "فشل تسجيل الدخول $e");
    }
  }

  Future<void> _addUserToFirestoreIfItsNotExistAndSaveTheUserSeeion(
      User user) async {
    final controller = Get.find<AuthController>();
    // اولا بدي اتأكد اذا المستخدم موجود في فاير ستور
    DocumentReference userDoc =
        FirebaseFirestore.instance.collection('Users').doc(user.uid);

    final snapshot = await userDoc.get();

    //لو ما موجودالمستخدم
    if (!snapshot.exists) {
      //بخليه يدخل الدور واسم المستخدم
      String? role =
          await Get.dialog(RoleUsernameSetDialog(controller: controller));

      //اذا الغى الادخال بطلعه ما بخليه يسجل دخوله
      if (role == null) {
        await FirebaseAuth.instance.currentUser?.delete();
        Get.snackbar("تم الإلغاء", "تم إلغاء تسجيل الدخول");
        return;
      }
      if (controller.username.value.isEmpty) {
        await FirebaseAuth.instance.currentUser?.delete();
        Get.snackbar("تم الإلغاء", "تم إلغاء تسجيل الدخول");
        return;
      }

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
        username: controller.username.value,
        email: user.email ?? '',
        role: role,
        photoUrl: user.photoURL ?? '',
      );

      //ادخال المستخدم في قاعدة البيانات
      try {
        //بدخله اول على مجموعه المستخدمين
        await userDoc.set(newUser.toMap());

        //بعدين منضيف اسم المستخدم لقاعدة البيانات لضمان عدم تكراره
        var firestore = FirebaseFirestore.instance;
        StatusClasses st = await FirebaseCrud.createDocument(
            docId: controller.username.value,
            collectionRef: firestore.collection(CollectionsNames.usernames),
            body: {"uid": FirebaseAuth.instance.currentUser!.uid});

        //بحال ما نجحت العملية
        if (st != StatusClasses.success) {
          await FirebaseAuth.instance.currentUser?.delete();
          Get.snackbar("خطأ", "حدث خطأ اثناء انشاء الحساب");
          // isRegisterLoading.value = false;
          return;
        }

        //بعد ما خلص بحفظ الجلسة
        final AuthService authService = Get.find<AuthService>();
        await authService.saveUserSession(passedRole: role);
      } catch (e) {
        //هي بحال فشل ادخال سجل للمستخدم بقاعدة البيانات
        await FirebaseAuth.instance.currentUser?.delete();
        Get.snackbar("خطأ", "حدث خطأ بادخال المستخدم في قاعدة البيانات : $e");
        return;
      }
    } else {
      //في حال وجود المستخدم مسبقا فقط نحفظ المستخدم في الجلسه
      final AuthService authService = Get.find<AuthService>();
      await authService.saveUserSession(passedRole: null);

      Get.snackbar("نجاح", "تم تسجيل الدخول");
      return;
    }
  }
}
