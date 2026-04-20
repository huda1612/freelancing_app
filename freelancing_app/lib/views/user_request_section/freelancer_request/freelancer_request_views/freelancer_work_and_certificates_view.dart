import 'package:flutter/material.dart';
import 'package:freelancing_platform/views/user_request_section/freelancer_request/freelancer_request_controller/work_cert_controller.dart';
import 'package:freelancing_platform/views/user_request_section/freelancer_request/freelancer_request_widgets/certificate_item_widget.dart';
import 'package:freelancing_platform/views/user_request_section/freelancer_request/freelancer_request_widgets/work_item_widget.dart';
import 'package:get/get.dart';


class FreelancerWorkAndCertificatesView extends StatelessWidget {
  final controller = Get.put(WorkCertController());

   FreelancerWorkAndCertificatesView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("الأعمال والشهادات"),
          bottom: TabBar(
            tabs: [
              Tab(text: "الأعمال"),
              Tab(text: "الشهادات"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildWorksTab(),
            _buildCertificatesTab(),
          ],
        ),
        bottomNavigationBar: Obx(() {
          final enabled = controller.workItems.where((e) => e["valid"]).length >= 2;

          return Padding(
            padding: const EdgeInsets.all(12),
            child: ElevatedButton(
              onPressed: enabled ? () {} : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: enabled ? Colors.blue : Colors.grey,
                padding: EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text("التالي"),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildWorksTab() {
    return Obx(() {
      return SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            ...controller.workItems
                .asMap()
                .entries
                .map((e) => WorkItemWidget(index: e.key))
                ,
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: controller.addWorkItem,
              child: Text("إضافة عمل"),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildCertificatesTab() {
    return Obx(() {
      return SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            ...controller.certItems
                .asMap()
                .entries
                .map((e) => CertificateItemWidget(index: e.key))
                ,
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: controller.addCertificateItem,
              child: Text("إضافة شهادة"),
            ),
          ],
        ),
      );
    });
  }
}
