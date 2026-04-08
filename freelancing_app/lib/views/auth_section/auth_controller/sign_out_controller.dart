import 'package:firebase_auth/firebase_auth.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignOutController extends GetxController {
  Future<void> signOut() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed(AppRoutes.welcome);
  }
}
