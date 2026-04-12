import 'package:freelancing_platform/core/constants/app_routes.dart';
// import 'package:freelancing_platform/core/utils/helper_function/check_internet.dart';
import 'package:freelancing_platform/core/utils/helper_function/check_login.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

//هالتابع بيتأكد اذا في نت واذا بدي بيتأكد كمان ان في مستخدم مسجل دخول بالتطبيق
//بستخدم هالتابع بالكنترولر قبل كل استدعاء لخدمه بتستعمل الفاير بيز ولو رد التابع فولس بوقف الاستدعاء وما بعمله

Future<bool> handleFirebaseCheck({bool loginRequired = true}) async {
  try {
    if (!await checkInternet()) {
      //لو ما في اتصال بالنت
      Get.snackbar("لا يوجد إنترنت", "الرجاء التحقق من اتصالك بالإنترنت");
      return false;
    }

    if (loginRequired) {
      //لو مطلوب تسجيل الدخول مشان نفذ الاستعلام
      if (!checkLogin()) {
        //لو المستخدم ما مسجل دخوله
        Get.snackbar("unauthorized", "يرجى تسجيل الدخول أولاً");
        Get.offAllNamed(AppRoutes.login);
        return false;
      }
    }

    //لو كل الشروط تمام بنفذ الاستعلام
    return true;
  } catch (e) {
    // print(e);
    return false;
  }
}


