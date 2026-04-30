import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/classes/route_handler.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/widgets/base_screen.dart';
import 'package:freelancing_platform/core/widgets/custom_app_bar.dart';
import 'package:freelancing_platform/core/widgets/custom_error_widget.dart';
import 'package:freelancing_platform/views/auth_section/auth_controller/sign_out_controller.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/route_manager.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    SignOutController signOutController = Get.find<SignOutController>();

    return BaseScreen(
        appBar: CustomAppBar(
          leadingIcon: IconButton(
              onPressed: signOutController.signOut,
              icon: Icon(
                Icons.output_rounded,
                color: AppColors.white,
              )),
        ),
        body: CustomErrorWidget(
          onRetry: () async {
            var route = await RouteHandler.firstRoutHandler();
            Get.offNamed(route);
          },
        ));
  }
}
