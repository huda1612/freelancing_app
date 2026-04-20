import 'package:freelancing_platform/views/user_request_section/freelancer_request/freelancer_request_controller/entry_test_controller.dart';
import 'package:freelancing_platform/views/user_request_section/freelancer_request/freelancer_request_controller/freelancer_request_controller.dart';
import 'package:get/get.dart';

class FreelancerRequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FreelancerRequestController>(
        () => FreelancerRequestController());
    Get.lazyPut<EntryTestController>(
        () => EntryTestController());
  }
}
