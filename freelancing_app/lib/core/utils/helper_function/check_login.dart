import 'package:firebase_auth/firebase_auth.dart';
import 'package:freelancing_platform/core/classes/user_session.dart';

bool isLogin() {
  if (FirebaseAuth.instance.currentUser == null ||
      UserSession.uid == null ||
      UserSession.role == null) {
    return false;
  }
  return true;
}
