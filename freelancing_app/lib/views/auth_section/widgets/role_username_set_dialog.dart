import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';

import 'package:freelancing_platform/core/utils/helper_function/validators.dart';
import 'package:freelancing_platform/core/widgets/custom_button.dart';
import 'package:freelancing_platform/core/widgets/custom_text_field.dart';
import 'package:freelancing_platform/views/auth_section/auth_controller/auth_controller.dart';

import 'package:freelancing_platform/views/auth_section/widgets/role_option.dart';
import 'package:get/get.dart';

class RoleUsernameSetDialog extends StatelessWidget {
  final AuthController controller;

  const RoleUsernameSetDialog({super.key, required this.controller});
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(
        'اختر اسم المستخدم و نوع الحساب',
        textAlign: TextAlign.center,
        style: AppTextStyles.heading,
      ),
      children: [
        Padding(
          padding: EdgeInsets.all(AppSpaces.paddingLarge),
          child: Column(
            children: [
              CustomTextField(
                hintText: "اسم المستخدم",
                keyboardType: TextInputType.name,
                onChanged: controller.onUsernameChanged,
                validator: Validators.username,
              ),
              Obx(() {
                if (controller.usernameError.value != null) {
                  return Text(
                    controller.usernameError.value!,
                    style: const TextStyle(color: Colors.red),
                  );
                } else {
                  return SizedBox.shrink();
                }
              }),
            ],
          ),
        ),
        SizedBox(
          height: AppSpaces.heightMedium,
        ),
        Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // زر العميل
                RoleOption(
                  label: "عميل",
                  icon: Icons.person_outline,
                  isSelected: controller.userRole.value == "client",
                  onTap: () => controller.userRole.value = "client",
                ),

                SizedBox(width: 16.w),

                // زر المستقل
                RoleOption(
                  label: "مستقل",
                  icon: Icons.work_outline,
                  isSelected: controller.userRole.value == "freelancer",
                  onTap: () => controller.userRole.value = "freelancer",
                ),
              ],
            )),
        SizedBox(height: AppSpaces.heightLarge),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 120.w),
          child: SizedBox(
            child: CustomButton(
              text: "موافق",
              onTap: () => Get.back(result: controller.userRole.value),
              height: 50.h,
            ),
          ),
        ),
      ],
    );
  }
}
