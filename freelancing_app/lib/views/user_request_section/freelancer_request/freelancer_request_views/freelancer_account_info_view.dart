import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/utils/helper_function/validators.dart';
import 'package:freelancing_platform/core/widgets/base_screen.dart';
import 'package:freelancing_platform/core/widgets/custom_app_bar.dart';
import 'package:freelancing_platform/core/widgets/custom_text_field.dart';
import 'package:freelancing_platform/core/widgets/search_field.dart';
import 'package:freelancing_platform/views/user_request_section/freelancer_request/freelancer_request_controller/skill_controller.dart';
import 'package:freelancing_platform/views/user_request_section/freelancer_request/freelancer_request_widgets/selected_skills_box.dart';
import 'package:freelancing_platform/views/user_request_section/freelancer_request/freelancer_request_widgets/skill_tile.dart';
import 'package:freelancing_platform/views/user_request_section/freelancer_request/freelancer_request_widgets/sub_skill_result_item.dart';
import 'package:get/get.dart';

class FreelancerAccountInfoView extends StatelessWidget {
  FreelancerAccountInfoView({super.key});

  final FreelancerAccountInfoController controller =
      Get.put(FreelancerAccountInfoController());

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
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                children: [
                  // ---------------------- Tab 1 ----------------------
                  Padding(
                    padding:
                        EdgeInsets.all(AppSpaces.mediumHorizontalPadding),
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
                              onChanged: (v) =>
                                  controller.specialization.value = v,
                            ),
                            SizedBox(height: AppSpaces.heightMedium2),
                            CustomTextField(
                              hintText: "المسمى الوظيفي",
                              keyboardType: TextInputType.name,
                              validator: Validators.validateJobTitle,
                              onChanged: (v) =>
                                  controller.jobTitle.value = v,
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
                  Padding(
                    padding:
                        EdgeInsets.all(AppSpaces.mediumHorizontalPadding),
                    child: Column(
                      children: [
                        SearchField(
                          hint: "ابحث عن مهارة...",
                          onChanged: controller.onSearchChanged,
                        ),
                        SizedBox(height: 12.h),
                        Expanded(
                          child: Obx(() {
                            if (controller.searchQuery.value.isNotEmpty) {
                              return ListView(
                                children: controller.filteredSubSkills
                                    .map((sub) {
                                  return SubSkillResultItem(
                                    title: sub,
                                    isSelected: controller
                                        .selectedSubSkills
                                        .contains(sub),
                                    onTap: () => controller
                                        .toggleSelectSubSkill(sub),
                                  );
                                }).toList(),
                              );
                            }

                            return ListView.builder(
                              itemCount: controller.skills.length,
                              itemBuilder: (context, index) {
                                return Obx(() {
                                  final skill = controller.skills[index];

                                  return SkillTile(
                                    title: skill.name,
                                    subSkills: skill.subSkills,
                                    isExpanded: skill.expanded.value,
                                    selectedSubSkills:
                                        skill.selectedSubSkills,
                                    onToggle: () =>
                                        controller.toggleSkill(index),
                                    onSubSkillToggle: (sub) =>
                                        controller.toggleSubSkill(
                                            index, sub),
                                  );
                                });
                              },
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _buildBottomSkillsBar(context),
          ],
        ),
      ),
    );
  }

  /// شريط سفلي: المهارات المختارة (تظهر فقط عند الاختيار) بجانب زر التالي.
  Widget _buildBottomSkillsBar(BuildContext context) {
    return Obx(() {
      final hasSkills = controller.selectedSubSkills.isNotEmpty;
      return SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpaces.mediumHorizontalPadding,
            8.h,
            AppSpaces.mediumHorizontalPadding,
            12.h,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            textDirection: TextDirection.rtl,
            mainAxisAlignment:
                hasSkills ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: [
              if (hasSkills) ...[
                Expanded(
                  child: SelectedSkillsBox(
                    skills: controller.selectedSubSkills.toList(),
                    onRemove: controller.toggleSelectSubSkill,
                    maxContentHeight: 80,
                  ),
                ),
                SizedBox(width: 10.w),
              ],
              ElevatedButton(
                onPressed: controller.canSubmit
                    ? () => controller.nextBottonOnPressed()
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.vividPurple,
                  padding:
                      EdgeInsets.symmetric(horizontal: 40.w, vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'التالي',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
