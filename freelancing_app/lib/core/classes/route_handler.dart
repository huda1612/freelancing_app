import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freelancing_platform/core/classes/firebase_crud.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/classes/user_session.dart';
import 'package:freelancing_platform/core/constants/app_constant_data.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/core/constants/collections_names.dart';
import 'package:freelancing_platform/core/constants/user_roles.dart';
import 'package:freelancing_platform/core/constants/user_status.dart';
import 'package:freelancing_platform/core/utils/helper_function/check_login.dart';
import 'package:freelancing_platform/models/user_collections/user_model.dart';

class RouteHandler {
  //اول ما يدخل او بعد تسجيل الدخول او بعد انشاء الحساب
  static Future<String> firstRoutHandler() async {
    //اول شي بشوف اذا هي اول مره بيفتح التطبيق
    if (AppConstantData.firstOpen == null) {
      return AppRoutes.onboarding;
    }

    //بعدين بشوف اذا مسجل دخول ولا لا
    if (!isLogin()) {
      return AppRoutes.welcome;
    }
    //مؤقتاااااااا
    // return AppRoutes.entryTest;

    //نتحقق اذا ادمن مناخده فورا على صفحته
    if (UserSession.role == UserRole.admin) {
      // return AppRoutes.adminHome;
      return AppRoutes.adminRequests;
    }

    //منتحقق من الايميل
    // if (!FirebaseAuth.instance.currentUser!.emailVerified) {
    //   return AppRoutes.verifyEmail;
    // }

    //اذا ما ادمن فمنتحقق من حالة المستخدم
    final docRef = FirebaseFirestore.instance
        .collection(CollectionsNames.users)
        .doc(UserSession.uid);

    final response = await FirebaseCrud.fetchDocument(
        docRef: docRef, fromMap: (map, id) => UserModel.fromMap(map, id));

    return response.fold((error) {
      //لو صار خطأ بجلب بيانات المستخدم
      if (error == StatusClasses.offlineError) {
        return AppRoutes.noInternet;
      }
      if (error == StatusClasses.unauthorized) {
        return AppRoutes.login;
      }
      print(error.message);
      return AppRoutes.error;
    }, (user) {
      //لو تم جلب بيانات المستخدم بنجاح منتأكد من حالته
      var status = user.status;
      switch (status) {
        case UserStatus.incomplete:
          {
            return UserSession.role == UserRole.freelancer
                ? AppRoutes.freelancerAccountInfo
                : AppRoutes.clientAccountInfo;
          }
        case UserStatus.rejected:
          {
            return AppRoutes.rejected;
          }
        case UserStatus.approved:
          {
            //هي بدها تعديل للهوم !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            return AppRoutes.approved;
          }
        case UserStatus.pending:
          {
            return AppRoutes.pending;
          }
        default:
          return UserSession.role == UserRole.freelancer
              ? AppRoutes.freelancerAccountInfo
              : AppRoutes.clientAccountInfo;
      }
    });
  }
}
