import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/classes/route_handler.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/widgets/base_screen.dart';
import 'package:freelancing_platform/core/widgets/custom_error_widget.dart';
import 'package:get/route_manager.dart';

class NoInternetView extends StatelessWidget {
  const NoInternetView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
        body: CustomErrorWidget(
      title: "لا يوجد انترنت",
      message: StatusClasses.offlineError.message,
      onRetry: () async {
        var route = await RouteHandler.firstRoutHandler();
        Get.offNamed(route);
      },
    ));
  }
}
