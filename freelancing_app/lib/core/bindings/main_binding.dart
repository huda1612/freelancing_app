import 'package:freelancing_platform/core/general_controllers.dart/image_upload_controller.dart';
import 'package:freelancing_platform/views/profile_section/profile_controllers/profile_controller.dart';
import 'package:get/get.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut(() => MainController());
    Get.lazyPut(() => ProfileController());
    Get.lazyPut(() => ImageUploadController());
  }
}
