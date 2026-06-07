// import 'dart:async';
// import 'package:freelancing_platform/core/constants/app_routes.dart';
// import 'package:freelancing_platform/core/services/navigation_service.dart';
// import 'package:freelancing_platform/views/profile_section/profile_controllers/profile_controller.dart';
// import 'package:get/get.dart';
// import 'package:app_links/app_links.dart';

// class DeepLinkService extends GetxService {
//   StreamSubscription? _sub;
//   final AppLinks _appLinks = AppLinks();
//   @override
//   void onInit() {
//     super.onInit();
//     init();
//   }

//   Future<void> init() async {
//     // التطبيق كان مغلق
//     final initialUri = await _appLinks.getInitialLink();

//     if (initialUri != null) {
//       _handleLink(initialUri);
//     }

//     // التطبيق مفتوح
//     _sub = _appLinks.uriLinkStream.listen((Uri uri) {
//       _handleLink(uri);
//     });
//   }

//   void _handleLink(Uri uri) {
//     print("Deep Link: $uri");

//     if (uri.host == "deeplinks" &&
//         uri.pathSegments.contains("stripe-success")) {
//       if (Get.isRegistered<ProfileController>()) {
//         Get.find<ProfileController>().loadProfile();
//       }

//       NavigationService.changeTab(3);

//       NavigationService.offAllNamed(
//         AppRoutes.myProfile,
//         id: 3,
//       );
//     }
//   }

//   @override
//   void onClose() {
//     _sub?.cancel();
//     super.onClose();
//   }
// }
