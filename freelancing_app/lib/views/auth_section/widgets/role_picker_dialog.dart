import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/widgets/custom_button.dart';
import 'package:freelancing_platform/views/auth_section/widgets/role_option.dart';
import 'package:get/get.dart';

class RolePickerDialog extends StatelessWidget {
  const RolePickerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedRole = 'client'.obs;

    return SimpleDialog(
      title: const Text('اختر نوع الحساب', textAlign: TextAlign.center),
      children: [
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RoleOption(
                label: "عميل",
                icon: Icons.person_outline,
                isSelected: selectedRole.value == "client",
                onTap: () => selectedRole.value = "client",
              ),
              SizedBox(width: 16.w),
              RoleOption(
                label: "مستقل",
                icon: Icons.work_outline,
                isSelected: selectedRole.value == "freelancer",
                onTap: () => selectedRole.value = "freelancer",
              ),
            ],
          ),
        ),
        SizedBox(height: AppSpaces.heightLarge),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 120.w),
          child: CustomButton(
            text: "موافق",
            onTap: () => Get.back(result: selectedRole.value),
            height: 50.h,
          ),
        ),
      ],
    );
  }
}
