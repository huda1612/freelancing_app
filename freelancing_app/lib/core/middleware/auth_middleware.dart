import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:freelancing_platform/core/classes/user_session.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:get/get.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || UserSession.uid == null || UserSession.role == null) {
      // Get.snackbar("وصول غير مصرح به",
      //     "لا يمكنك الوصول الى هذه الصفحه ، يرجى تسجيل الدخول اولا");
      return RouteSettings(name: AppRoutes.login , arguments: {"reason": "unauthorized"},);
    }
    return super.redirect(route);
  }
}
