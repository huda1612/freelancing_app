import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/classes/route_handler.dart';
import 'package:freelancing_platform/core/widgets/base_screen.dart';
import 'package:freelancing_platform/core/widgets/custom_error_widget.dart';
import 'package:get/route_manager.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(body: CustomErrorWidget(
      onRetry: () async {
        var route = await RouteHandler.firstRoutHandler();
        Get.offNamed(route);
      },
    ));
  }
}
