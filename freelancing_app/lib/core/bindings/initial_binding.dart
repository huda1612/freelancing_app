// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:freelancing_platform/core/classes/firebase_crud.dart';
// import 'package:get/get.dart';

// class InitialBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.put(FirebaseAuth.instance);
//     Get.put(FirebaseFirestore.instance);

//     Get.put(
//       FirebaseCrud(
//         Get.find<FirebaseFirestore>(),
//         // Get.find<FirebaseAuth>(),
//       ),
//     );
//   }
// }