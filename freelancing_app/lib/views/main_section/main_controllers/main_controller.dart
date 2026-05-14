// import 'package:freelancing_platform/views/chat_section/chat_views/chat_view.dart';
// import 'package:freelancing_platform/views/home_section/home_views/home_view.dart';
// import 'package:freelancing_platform/views/profile_section/profile_views/profile_view.dart';
// import 'package:freelancing_platform/views/search_section/search_views/search_view.dart';
// import 'package:get/get.dart';
// class MainController extends GetxController {
//   var currentIndex = 0.obs;

//   final pages = [
//     HomeView(),
//     SearchView(),
//     ChatView(),
//     ProfileView(),
//   ];

//   void changePage(int index) {
//     currentIndex.value = index;
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  final RxInt currentIndex = 0.obs;

  final Map<int, GlobalKey<NavigatorState>> navigatorKeys = {
    0: Get.nestedKey(0)!,
    1: Get.nestedKey(1)!,
    2: Get.nestedKey(2)!,
    3: Get.nestedKey(3)!,
  };

  void changePage(int index) {
    // if (currentIndex.value == index) {
    //   final navigator = navigatorKeys[index]!.currentState!;

    //   if (navigator.canPop()) {
    //     navigator.popUntil(
    //       (route) => route.isFirst,
    //     );
    //   }

    //   return;
    // }

    currentIndex.value = index;
  }

  Future<bool> onWillPop() async {
    final NavigatorState currentNavigator =
        navigatorKeys[currentIndex.value]!.currentState!;

    if (currentNavigator.canPop()) {
      currentNavigator.pop();

      return false;
    }

    return true;
  }
}
