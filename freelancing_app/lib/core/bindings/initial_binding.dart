import 'package:freelancing_platform/core/services/notification_services.dart';
import 'package:freelancing_platform/views/main_section/main_controllers/navigation_controller.dart';
import 'package:get/get.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavigationController>(() => NavigationController(),
        fenix: true);
  Get.put(NotificationServices(), permanent: true);
  }
    // Get.put(FirebaseAuth.instance);
    // Get.put(FirebaseFirestore.instance);

    // Get.put(
    //   FirebaseCrud(
    //     Get.find<FirebaseFirestore>(),
    //     // Get.find<FirebaseAuth>(),
    //   ),
    // );
  }

