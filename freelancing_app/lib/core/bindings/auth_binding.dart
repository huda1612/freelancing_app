import 'package:freelancing_platform/data/repositories/auth_repository.dart';
import 'package:freelancing_platform/data/services/auth_service.dart';
import 'package:freelancing_platform/views/auth_section/auth_controller/auth_controller.dart';
import 'package:freelancing_platform/views/auth_section/auth_controller/google_sign_in_controller.dart';
import 'package:get/get.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepository>(() => AuthRepository(), fenix: true);
    Get.lazyPut<AuthService>(() => AuthService(Get.find<AuthRepository>()), fenix: true);
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
    Get.lazyPut<GoogleSignInController>(
      () => GoogleSignInController(),
      fenix: true,
    );
  }
}
