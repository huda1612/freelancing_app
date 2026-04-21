import 'package:freelancing_platform/core/classes/route_handler.dart';
// import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();

    // الانتقال بعد 5 ثواني
    Future.delayed(const Duration(seconds: 5), () async {
      // هون التوجيه الاول
      final nextRoute = await RouteHandler.firstRoutHandler();
      Get.offAllNamed(nextRoute);

      // Get.offNamed(AppRoutes.onboarding);
    });
  }
}
