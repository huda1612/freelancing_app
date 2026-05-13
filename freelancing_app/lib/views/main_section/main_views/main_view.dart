import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/classes/user_session.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/user_roles.dart';
import 'package:freelancing_platform/core/widgets/custom_bottom_nav_bar.dart';
import 'package:freelancing_platform/views/main_section/main_controllers/main_controller.dart';
import 'package:get/get.dart';

class MainView extends StatelessWidget {
  MainView({super.key});

  final controller = Get.find<MainController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: controller.pages[controller.currentIndex.value],
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changePage,
          isClient:
              UserSession.role == UserRole.client, // أو false حسب نوع المستخدم
        ),
      ),
    );
  }
}
