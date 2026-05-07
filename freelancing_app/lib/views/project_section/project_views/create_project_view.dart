import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_input_styles.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';
import 'package:freelancing_platform/core/widgets/custom_app_bar.dart';
import 'package:freelancing_platform/core/widgets/custom_button.dart';
import 'package:freelancing_platform/core/widgets/custom_text_field.dart';
import 'package:freelancing_platform/core/widgets/get_rerponse_handler.dart';
import 'package:freelancing_platform/views/project_section/project_controller/create_project_controller.dart';
import 'package:get/get.dart';

class CreateProjectView extends StatelessWidget {
  CreateProjectView({super.key});

  final CreateProjectController controller = Get.find<CreateProjectController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: 'إنشاء مشروع',
        backgroundGradient: AppColors.gradientColor,
      ),
      body: Obx(() {
        return UiStateHandler(
          status: controller.pageState.value,
          fetchDataFun: controller.fetchSpecializations,
          child: SafeArea(
            top: false,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppSpaces.paddingMedium),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                    _SectionTitle(text: 'عنوان المشروع'),
                    CustomTextField(
                      controller: controller.titleController,
                      hintText: 'اكتب عنوان المشروع',
                      keyboardType: TextInputType.name,
                      validator: (value) =>
                          controller.validateRequired(value, 'عنوان المشروع'),
                    ),
                    SizedBox(height: AppSpaces.heightMedium2),
                    _SectionTitle(text: 'وصف المشروع'),
                    CustomTextField(
                      controller: controller.descriptionController,
                      hintText: 'اكتب وصف المشروع',
                      keyboardType: TextInputType.multiline,
                      validator: (value) =>
                          controller.validateRequired(value, 'وصف المشروع'),
                    ),
                    SizedBox(height: AppSpaces.heightMedium2),
                    _SectionTitle(text: 'الميزانية'),
                    CustomTextField(
                      controller: controller.budgetController,
                      hintText: 'المبلغ',
                      keyboardType: TextInputType.number,
                      validator: controller.validateBudget,
                    ),
                    SizedBox(height: AppSpaces.heightMedium2),
                    _SectionTitle(text: 'مدة التنفيذ (بالأيام)'),
                    CustomTextField(
                      controller: controller.durationController,
                      hintText: 'عدد الأيام',
                      keyboardType: TextInputType.number,
                      validator: controller.validateDuration,
                    ),
                    SizedBox(height: AppSpaces.heightMedium2),
                    _SectionTitle(text: 'التخصص'),
                    Obx(() {
                      return DropdownButtonFormField<String>(
                        initialValue: controller.selectedSpecialization.value,
                        isExpanded: true,
                        decoration: unifiedDecoration('اختر التخصص'),
                        items: controller.allSpecializations
                            .map(
                              (o) => DropdownMenuItem<String>(
                                value: o.slug,
                                child: Text(
                                  o.name,
                                  textDirection: TextDirection.rtl,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) =>
                            controller.selectedSpecialization.value = value,
                        validator: (value) =>
                            value == null || value.isEmpty ? 'التخصص مطلوب' : null,
                      );
                    }),
                    SizedBox(height: AppSpaces.heightLarge),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: AppColors.gradientColor,
                            borderRadius:
                                BorderRadius.circular(AppSpaces.radiusSmall),
                          ),
                          child: IconButton(
                            onPressed: controller.openSkillsSelection,
                            icon: const Icon(Icons.add, color: AppColors.white),
                          ),
                        ),
                        _SectionTitle(text: 'المهارات المطلوبة'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Divider(
                            color: AppColors.lightPurple,
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpaces.heightMedium),
                    Obx(() {
                      if (controller.selectedSkills.isEmpty) {
                        return Text(
                          'لم يتم اختيار مهارات بعد',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.black54,
                          ),
                        );
                      }
                      return Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        textDirection: TextDirection.rtl,
                        children: controller.selectedSkills.map((skill) {
                          return Chip(
                            label: Text(skill),
                            onDeleted: () => controller.removeSkill(skill),
                            deleteIcon: const Icon(
                              Icons.close,
                              size: 18,
                              color: AppColors.vividPurple,
                            ),
                            labelStyle: const TextStyle(
                              color: AppColors.darkPurple,
                              fontWeight: FontWeight.w600,
                            ),
                            backgroundColor: AppColors.veryLightPurple,
                            side: const BorderSide(
                              color: AppColors.lightPurple,
                            ),
                          );
                        }).toList(),
                      );
                    }),
                    SizedBox(height: AppSpaces.heightLarge1),
                    Obx(() {
                      return CustomButton(
                        text: 'إنشاء المشروع',
                        onTap: controller.submitProject,
                        isLoading: controller.submitLoading.value,
                        gradient: AppColors.gradientColor,
                      );
                    }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        textDirection: TextDirection.rtl,
             style: AppTextStyles.subheading.copyWith(color: AppColors.darkPurple),

      ),
    );
  }
}
