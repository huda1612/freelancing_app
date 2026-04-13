import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/utils/helper_function/validators.dart';
import 'package:freelancing_platform/core/widgets/base_screen.dart';
import 'package:freelancing_platform/core/widgets/custom_app_bar.dart';
import 'package:freelancing_platform/core/widgets/custom_text_field.dart';
import 'package:freelancing_platform/views/user_request_section/freelancer_request/freelancer_request_controller/skill_controller.dart';
import 'package:freelancing_platform/views/user_request_section/freelancer_request/freelancer_request_widgets/skill_tile.dart';
import 'package:get/get.dart';

class FreelancerAccountInfoView extends StatelessWidget {
  FreelancerAccountInfoView({super.key});

  final FreelancerAccountInfoController controller =
      Get.put(FreelancerAccountInfoController());
  // final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: BaseScreen(
        appBar: CustomAppBar(
          title: "معلومات الحساب ",
          bottom: const TabBar(
            labelColor: AppColors.white,
            unselectedLabelColor: AppColors.grey,
            indicatorColor: AppColors.white,
            tabs: [
              Tab(text: "المعلومات"),
              Tab(text: "المهارات"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // ---------------------- Tab 1 ----------------------
            Padding(
              padding: EdgeInsets.all(AppSpaces.mediumHorizontalPadding),
              child: Form(
                key: controller.formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: AppSpaces.heightMedium),
                      CustomTextField(
                        hintText: "التخصص",
                        keyboardType: TextInputType.name,
                        validator: Validators.validateSpecialization,
                        onChanged: (v) => controller.specialization.value = v,
                      ),
                      SizedBox(height: AppSpaces.heightMedium2),
                      CustomTextField(
                        hintText: "المسمى الوظيفي",
                        keyboardType: TextInputType.name,
                        validator: Validators.validateJobTitle,
                        onChanged: (v) => controller.jobTitle.value = v,
                      ),
                      SizedBox(height: AppSpaces.heightMedium2),
                      CustomTextField(
                        hintText: "نبذة",
                        keyboardType: TextInputType.multiline,
                        validator: Validators.validateBio,
                        onChanged: (v) => controller.bio.value = v,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // ---------------------- Tab 2 ----------------------
            ListView.builder(
              itemCount: controller.skills.length,
              itemBuilder: (context, index) {
                return Obx(() {
                  final skill = controller.skills[index];

                  return SkillTile(
                    title: skill.name,
                    subSkills: skill.subSkills,
                    isExpanded: skill.expanded.value,
                    selectedSubSkills: skill.selectedSubSkills,
                    onToggle: () => controller.toggleSkill(index),
                    onSubSkillToggle: (sub) =>
                        controller.toggleSubSkill(index, sub),
                  );
                });
              },
            )
          ],
        ),
        floatingActionButton: Obx(() {
          return ElevatedButton(
            onPressed: controller.canSubmit
                ? () => controller.nextBottonOnPressed()
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.vividPurple,
              padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              "التالي",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }),
      ),
    );
  }
}
