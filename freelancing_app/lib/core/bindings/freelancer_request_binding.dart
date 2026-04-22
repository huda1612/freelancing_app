import 'package:freelancing_platform/views/auth_section/auth_controller/sign_out_controller.dart';
import 'package:freelancing_platform/views/user_request_section/request_controller/entry_test_controller.dart';
import 'package:freelancing_platform/views/user_request_section/request_controller/freelancer_request_controller.dart';
import 'package:get/get.dart';

class FreelancerRequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignOutController>(() => SignOutController(), fenix: true);
    Get.lazyPut<FreelancerRequestController>(
        () => FreelancerRequestController(),
        fenix: true);
    Get.lazyPut<EntryTestController>(() => EntryTestController(), fenix: true);
  }
}
