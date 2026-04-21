import 'package:freelancing_platform/core/classes/user_session.dart';
import 'package:freelancing_platform/core/constants/user_roles.dart';
import 'package:freelancing_platform/views/user_request_section/request_controller/entry_test_controller.dart';
import 'package:freelancing_platform/views/user_request_section/request_controller/freelancer_request_controller.dart';
import 'package:get/get.dart';

class EntryTestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EntryTestController>(() => EntryTestController());
    if (UserSession.role == UserRole.freelancer) {
      Get.lazyPut<FreelancerRequestController>(
          () => FreelancerRequestController());
    } else if (UserSession.role == UserRole.client) {
      Get.lazyPut<FreelancerRequestController>(
          () => FreelancerRequestController());
    }
  }
}
