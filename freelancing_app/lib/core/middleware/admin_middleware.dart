import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:freelancing_platform/core/classes/user_session.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/core/constants/user_roles.dart';
import 'package:get/get.dart';

class AdminMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || UserSession.uid == null || UserSession.role == null) {
      // if (user == null) {
      Get.snackbar("وصول غير مصرح به",
          "لا يمكنك الوصول الى هذه الصفحه ، يرجى تسجيل الدخول اولا");
      return RouteSettings(name: AppRoutes.login);
    }
    if (UserSession.role != UserRole.admin) {
      Get.snackbar("وصول غير مصرح به",
          "لا يمكنك الوصول الى هذه الصفحه ،هذه الصفحة مخصصة للأدمن فقط");
      return RouteSettings(name: AppRoutes.login);
    }
    return super.redirect(route);
  }
}
