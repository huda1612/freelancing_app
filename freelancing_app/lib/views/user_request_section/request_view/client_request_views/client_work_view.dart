import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/core/widgets/base_screen.dart';
import 'package:freelancing_platform/core/widgets/custom_app_bar.dart';
import 'package:freelancing_platform/views/user_request_section/request_controller/client_request_controller.dart';
import 'package:freelancing_platform/views/user_request_section/request_widgets/work_item_widget.dart';
import 'package:get/get.dart';

class ClientWorkView extends StatelessWidget {
  ClientWorkView({super.key});

  final controller = Get.find<ClientRequestController>();

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
        appBar: const CustomAppBar(
          title: "الأعمال",
        ),
        body: _buildWorksBody(),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(12),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: ElevatedButton(
              onPressed: () {
                Get.toNamed(AppRoutes.entryTest);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.vividPurple,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'التالي',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ));
  }

  Widget _buildWorksBody() {
    return Obx(() {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ...List.generate(
              controller.workItems.length,
              (i) => WorkItemWidget(
                key: ValueKey(controller.workItems[i]),
                index: i,
                workItems: controller.workItems,
                uploadImage: controller.pickAndUploadImage,
                removeWorkItem: controller.removeWorkItem,
                validateWork: controller.validateWork,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: controller.addWorkItem,
              child: const Text("إضافة عمل"),
            ),
          ],
        ),
      );
    });
  }
}
