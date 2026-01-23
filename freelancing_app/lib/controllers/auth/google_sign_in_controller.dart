import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInController extends GetxController {
  Future<void> signInWithGoogle() async {
    try {
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

      Get.snackbar("نجاح", "تم تسجيل الدخول");
    } catch (e) {
      Get.snackbar("فشل", "فشل تسجيل الدخول $e");
    }
  }

  Future<void> _addUserToFirestoreIfItsNotExist(user) async {
    // **الآن نتأكد إذا موجود في Firestore**
    DocumentReference userDoc =
        FirebaseFirestore.instance.collection('Users').doc(user.uid);

    final snapshot = await userDoc.get();

    if (!snapshot.exists) {
      String? role = await Get.dialog(
        SimpleDialog(
          title: Text('اختر نوع الحساب'),
          children: [
            SimpleDialogOption(
              child: Text('عميل'),
              onPressed: () => Get.back(result: 'client'),
            ),
            SimpleDialogOption(
              child: Text('مقدم خدمة'),
              onPressed: () => Get.back(result: 'freelancer'),
            ),
          ],
        ),
      );
      if (role == null) {
        return;
      } // المستخدم ألغى اختيار الدور

      // المستخدم جديد → نضيفه للـ Users collection
      await userDoc.set({
        'name': user.displayName ?? '',
        'email': user.email ?? '',
        'role': role,
        'photoUrl': user.photoURL ?? '',
        'bio': '',
        'skills': [],
        'rating': 0.0,
        'completed_projects': 0,
        'points': 0,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }
}
