// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:freelancing_platform/core/constants/app_constant_data.dart';
// import 'package:freelancing_platform/core/constants/app_routes.dart';
// import 'package:freelancing_platform/core/constants/user_status.dart';
// import 'package:freelancing_platform/core/utils/helper_function/check_login.dart';

// class RouteHandler {
//   static Future<String> firstRoutHandler() async {
//     //اول شي بشوف اذا هي اول مره بيفتح التطبيق
//     if (AppConstantData.firstOpen == null) {
//       return AppRoutes.onboarding;
//     }

//     //بعدين بشوف اذا مسجل دخول ولا لا
//     if (!isLogin()) {
//       return AppRoutes.welcome;
//     }

//     //منتحقق من الايميل
//     if (!FirebaseAuth.instance.currentUser!.emailVerified) {
//       return AppRoutes.verifyEmail;
//     }

//     //منتحقق من حالة المستخدم 
//     final status = await ;
//     if(status == UserStatus.incomplete ){
//       return AppRoutes.
//     }
//     if(status == UserStatus.pending ){
//       return AppRoutes.
//     }
//     if(status == UserStatus.rejected ){
//       return AppRoutes.
//     }
//     if(status == UserStatus.approved ){
//       return AppRoutes.
//     }

//   }
// }
