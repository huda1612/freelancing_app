import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/widgets/base_screen.dart';
import 'package:freelancing_platform/core/widgets/custom_app_bar.dart';
import 'package:freelancing_platform/views/user_request_section/request_controller/work_cert_controller.dart';
import 'package:freelancing_platform/views/user_request_section/request_widgets/work_item_widget.dart';
import 'package:get/get.dart';

class ClientWorkView extends StatelessWidget {
  ClientWorkView({super.key});

  final WorkCertController controller = Get.put(WorkCertController());

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      appBar: const CustomAppBar(
        title: "الأعمال",
      ),
      body: _buildWorksBody(),
      floatingActionButton: Obx(() {
        return Padding(
          padding: const EdgeInsets.all(12),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: ElevatedButton(
              onPressed: () {},
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
        );
      }),
    );
  }

  Widget _buildWorksBody() {
    return Obx(() {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // البوكسين الثابتين
            WorkItemWidget(index: 0),
            const SizedBox(height: 12),
            WorkItemWidget(index: 1),

            const SizedBox(height: 16),

            // العناصر اللي يضيفها المستخدم
            ...List.generate(
              (controller.workItems.length - 2).clamp(0, 1 << 31),
              (i) => WorkItemWidget(index: i + 2),
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
