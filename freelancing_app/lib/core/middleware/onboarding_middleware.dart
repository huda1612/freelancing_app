// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:freelancing_platform/core/constants/app_constant_data.dart';
// import 'package:freelancing_platform/core/constants/app_routes.dart';
// import 'package:freelancing_platform/core/utils/helper_function/check_login.dart';
// import 'package:get/get.dart';

// class OnboardingMiddleware extends GetMiddleware {
//   @override
//   RouteSettings? redirect(String? route) {
//     //if its not the first time
//     if (AppConstantData.firstOpen != null) {
//       //if the user has not log in
//       if (!isLogin()) {
//         return RouteSettings(name: AppRoutes.welcome);
//       }
//       //if the user has log in
//       else {
//         //بشوف التحقق من الايميل
//         if (!FirebaseAuth.instance.currentUser!.emailVerified) {
//           return RouteSettings(name: AppRoutes.verifyEmail);
//         } else {
//           //لازم هون شوف حالة الطلب بعدين
//           return RouteSettings(name: AppRoutes.personalInfo);
//         }
//       }
//     }
//     return null; // يعني ما في تحويل، خليه يكمل للصفحة المطلوبة
//   }
// }
