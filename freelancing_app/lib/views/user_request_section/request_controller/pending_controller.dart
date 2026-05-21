import 'package:freelancing_platform/core/classes/route_handler.dart';
import 'package:get/get.dart';

class PendingController extends GetxController {
  Future<void> checkRoute() async {
    final route = await RouteHandler.firstRoutHandler();
    Get.offAllNamed(route);
  }
}
