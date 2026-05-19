import 'package:flutter/material.dart';
import 'package:freelancing_platform/views/main_section/main_controllers/navigation_controller.dart';
import 'package:get/get.dart';

class NavigationService {
  static NavigationController get _controller =>
      Get.find<NavigationController>();

  static int get currentTab => _controller.currentIndex.value;
  // static T? arguments<T>(
  //   BuildContext context,
  // ) {
  //   return ModalRoute.of(context)!.settings.arguments as T?;
  // }
  // static T? currentArguments<T>() {
  //   return ModalRoute.of(Get.context!)?.settings.arguments as T?;
  // }
  // static T? arguments<T>() {
  //   final context = Get.context;
  //   print("context : $context");
  //   if (context == null) return null;

  //   final route = ModalRoute.of(context);
  //   print("route : $route");
  //   if (route == null) return null;

  //   return route.settings.arguments as T?;
  // }

  static T? arguments<T>(BuildContext context) {
    return ModalRoute.of(context)?.settings.arguments as T?;
  }

  // static Map<String, dynamic>? routeArguments(String route) {
  //   if (!Get.isRegistered<Map<String, dynamic>>(tag: route)) {
  //     return null;
  //   }

  //   return Get.find<Map<String, dynamic>>(tag: route);
  // }
  static String routeTag(
    String route, {
    int? tabIndex,
  }) {
    return "${route}_${tabIndex ?? currentTab}";
  }

  static Map<String, dynamic>? routeArguments(
    String route, {
    int? tabIndex,
  }) {
    final tag = routeTag(
      route,
      tabIndex: tabIndex,
    );

    if (!Get.isRegistered<Map<String, dynamic>>(tag: tag)) {
      return null;
    }

    return Get.find<Map<String, dynamic>>(
      tag: tag,
    );
  }

  /// Nested Navigation
  static Future<dynamic>? toNamed(
    String route, {
    dynamic arguments,
    int? id,
  }) {
    return Get.toNamed(
      route,
      id: id ?? currentTab,
      arguments: arguments,
    );
  }

  static Future<dynamic>? offNamed(
    String route, {
    dynamic arguments,
    int? id,
  }) {
    return Get.offNamed(
      route,
      id: id ?? currentTab,
      arguments: arguments,
    );
  }

  static Future<dynamic>? offAllNamed(
    String route, {
    dynamic arguments,
    int? id,
  }) {
    return Get.offAllNamed(
      route,
      id: id ?? currentTab,
      arguments: arguments,
    );
  }

  static void back({int? id, bool? result}) {
    Get.back(id: id ?? currentTab, result: result);
  }

  /// Root Navigation
  static Future<dynamic>? rootToNamed(
    String route, {
    dynamic arguments,
  }) {
    return Get.toNamed(
      route,
      arguments: arguments,
    );
  }

  static Future<dynamic>? rootOffNamed(
    String route, {
    dynamic arguments,
  }) {
    return Get.offNamed(
      route,
      arguments: arguments,
    );
  }

  static Future<dynamic>? rootOffAllNamed(
    String route, {
    dynamic arguments,
  }) {
    return Get.offAllNamed(
      route,
      arguments: arguments,
    );
  }

  static void changeTab(int index) {
    _controller.changePage(index);
  }
}
