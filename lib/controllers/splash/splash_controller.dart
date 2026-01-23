import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:get/get.dart';


class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();

    // الانتقال بعد 5 ثواني
    Future.delayed(const Duration(seconds: 5), () {
      Get.offNamed(AppRoutes.onboarding);

    });
  }
}
