// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:freelancing_platform/core/classes/firebase_crud.dart';
import 'package:freelancing_platform/views/main_section/main_controllers/main_controller.dart';
import 'package:get/get.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavigationController>(() => NavigationController(),
        fenix: true);

    // Get.put(FirebaseAuth.instance);
    // Get.put(FirebaseFirestore.instance);

    // Get.put(
    //   FirebaseCrud(
    //     Get.find<FirebaseFirestore>(),
    //     // Get.find<FirebaseAuth>(),
    //   ),
    // );
  }
}
