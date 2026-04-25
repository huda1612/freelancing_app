import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';
import 'package:freelancing_platform/core/constants/reuest_status.dart';
import 'package:freelancing_platform/core/widgets/custom_button.dart';
import 'package:freelancing_platform/views/admin_section/admin_requests/admin_requests_controller/admin_request_datails_controller.dart';
import 'package:freelancing_platform/views/admin_section/admin_requests/widgets/request_type.dart';
import 'package:get/get.dart';

class AdimnRequestDetailView extends StatelessWidget {
  AdimnRequestDetailView({super.key});

  final controller = Get.put(RequestDetailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[100],
      backgroundColor: AppColors.veryLightGrey,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text("تفاصيل الطلب"),
        leading: const BackButton(),
        actions: [
          Padding(
            padding: EdgeInsets.only(left: AppSpaces.paddingMedium),
            child: RequestType(RequestStatus.pending),
          )
        ],
      ),
      body: Obx(() {
        return SingleChildScrollView(
          padding: EdgeInsets.all(AppSpaces.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 Header Card (Status / Title)
              Container(
                padding: EdgeInsets.all(AppSpaces.paddingMedium),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.person, color: AppColors.purple),
                    SizedBox(width: AppSpaces.heightSmall),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.jobTitle.value,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text("اسم المستخدم الاول والاخير"),
                      ],
                    )
                  ],
                ),
              ),

              SizedBox(height: AppSpaces.heightLarge),

              /// 🔹 Request Details
              _sectionTitle("تفاصيل الطلب"),

              _infoRow("الاختصاص", controller.specialization.value),
              _infoRow("المسمى الوظيفي", controller.jobTitle.value),

              const SizedBox(height: 10),

              /// Bio
              _sectionTitle("نبذة"),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(AppSpaces.paddingMedium - 1),
                decoration: _box(),
                child: Text(controller.bio.value),
              ),

              const SizedBox(height: 20),

              /// Skills
              _sectionTitle("المهارات"),
              Wrap(
                spacing: 8,
                children: controller.skills
                    .map((e) => Chip(
                        label: Text(e), backgroundColor: AppColors.lightPurple))
                    .toList(),
              ),

              const SizedBox(height: 20),

              /// Work Samples
              _sectionTitle("عينات الأعمال"),
              ...controller.workSamples
                  .map((file) => _fileTile("عنوان العينه", file))
                  .toList(),

              const SizedBox(height: 20),

              /// Certificates
              _sectionTitle("الشهادات"),
              ...controller.certificates
                  .map((file) => _fileTile("شهادة", file))
                  .toList(),

              const SizedBox(height: 30),

              /// Buttons (Accept / Reject)
              // Row(
              //   children: [
              //     Expanded(
              //       child: OutlinedButton(
              //         onPressed: () {},
              //         style: OutlinedButton.styleFrom(
              //           foregroundColor: Colors.red,
              //         ),
              //         child: const Text("Reject"),
              //       ),
              //     ),
              //     const SizedBox(width: 10),
              //     Expanded(
              //       child: ElevatedButton(
              //         onPressed: () {},
              //         child: const Text("Accept"),
              //       ),
              //     ),
              //   ],
              // )
            ],
          ),
        );
      }),
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(10),
        // color: AppColors.white,
        child: Row(
          children: [
            Expanded(
                child: CustomButton(
              color: AppColors.red,
              text: "Reject",
              onTap: () {},
            )
                // OutlinedButton(
                //   onPressed: () {},
                //   style: OutlinedButton.styleFrom(
                //     foregroundColor: Colors.red,
                //   ),
                //   child: const Text("Reject"),
                // ),
                ),
            const SizedBox(width: 10),
            Expanded(
                child: CustomButton(
              color: AppColors.green,
              text: "Accept",
              onTap: () {},
            )
                // ElevatedButton(
                //   onPressed: () {},
                //   child: const Text("Accept"),
                // ),
                ),
          ],
        ),
      ),
    );
  }

  /// ================= UI Helpers =================

  Widget _sectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpaces.paddingSmall + 2),
      child: Text(
        title,
        style: AppTextStyles.blacksubheading.copyWith(fontSize: 18.sp),
        // style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold , ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSpaces.paddingSmall),
      padding: EdgeInsets.all(AppSpaces.paddingSmall + 2),
      decoration: _box(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _fileTile(String title, String url) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSpaces.paddingMedium),
      padding: const EdgeInsets.all(12),
      decoration: _box(),
      child: Row(
        children: [
          const Icon(Icons.insert_drive_file, color: AppColors.purple),
          SizedBox(width: AppSpaces.heightSmall),
          Expanded(child: Text(title)),
          TextButton(
            onPressed: () {
              // افتح الملف (url_launcher أو pdf viewer)
              print("Open: $url");
            },
            child: const Text("View"),
          )
        ],
      ),
    );
  }

  BoxDecoration _box() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 5,
        )
      ],
    );
  }
}
