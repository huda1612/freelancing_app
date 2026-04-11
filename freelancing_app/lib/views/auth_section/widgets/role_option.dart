import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';

class RoleOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const RoleOption({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: 140.w,
          padding:
              EdgeInsets.symmetric(vertical: AppSpaces.mediumVerticalSpacing.h),
          decoration: BoxDecoration(
            color: AppColors.white, // دائماً أبيض
            borderRadius: BorderRadius.circular(AppSpaces.radiusMedium),
            border: Border.all(
              color: isSelected
                  ? AppColors.vividPurple
                  : AppColors.grey, // حدود واضحة
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 22.w,
                color: isSelected ? AppColors.purple : AppColors.grey,
              ),
              SizedBox(width: AppSpaces.marginSmall),
              Text(
                label,
                style: AppTextStyles.button.copyWith(
                  color: isSelected ? AppColors.purple : AppColors.grey,
                ),
              ),
            ],
          )),
    );
  }
}
