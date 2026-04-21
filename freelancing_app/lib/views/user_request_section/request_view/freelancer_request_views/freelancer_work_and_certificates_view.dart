import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/widgets/base_screen.dart';
import 'package:freelancing_platform/core/widgets/custom_app_bar.dart';
import 'package:freelancing_platform/views/user_request_section/request_controller/work_cert_controller.dart';
import 'package:freelancing_platform/views/user_request_section/request_widgets/certificate_item_widget.dart';
import 'package:freelancing_platform/views/user_request_section/request_widgets/work_item_widget.dart';
import 'package:get/get.dart';


class FreelancerWorkAndCertificatesView extends StatelessWidget {
  final controller = Get.put(WorkCertController());

   FreelancerWorkAndCertificatesView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: BaseScreen(
        appBar: CustomAppBar(
          title: "الأعمال والشهادات",
          bottom: const TabBar(
              labelColor: AppColors.white,
            unselectedLabelColor: AppColors.grey,
            indicatorColor: AppColors.white,

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
        floatingActionButton: Obx(() {
final enabled =
      controller.workItems.where((e) => e["valid"] == true).length >= 2;
  return Padding(
    padding: const EdgeInsets.all(12),
    child: Align(
      alignment: Alignment.bottomLeft, // ← هون صار على اليمين
      child: ElevatedButton(
        onPressed: enabled ? () {} : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled ? AppColors.vividPurple : Colors.grey,
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
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
        
      
        

      ),
      
    );
    
  }


 Widget _buildWorksTab() {
  return Obx(() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // ⭐ البوكسين الثابتين
          WorkItemWidget(index: 0),
          SizedBox(height: 12),
          WorkItemWidget(index: 1),

          SizedBox(height: 16),

          // ⭐ العناصر اللي يضيفها المستخدم
          ...List.generate(
            (controller.workItems.length - 2).clamp(0, 1 << 31),
            (i) => WorkItemWidget(index: i + 2),
          ),

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
          // ⭐ البوكسين الثابتين
          CertificateItemWidget(index: 0),
          SizedBox(height: 12),
          CertificateItemWidget(index: 1),

          SizedBox(height: 16),

          // ⭐ العناصر اللي يضيفها المستخدم
         ...List.generate(
            (controller.certItems.length - 2).clamp(0, 1 << 31),
            (i) => CertificateItemWidget(index: i + 2),
          ),

          SizedBox(height: 16),

          ElevatedButton(
            onPressed: controller.addCertificateItem,
            child: Text("إضافة شهادة"),
          ),
        ],
      ),
    );
  });
 }}