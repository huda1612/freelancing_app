import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';

InputDecoration unifiedDecoration(String label) {
  return InputDecoration(
    labelText: label,
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    isDense: true,
    filled: true,
    fillColor: AppColors.veryLightGrey,
    contentPadding: EdgeInsets.symmetric(
      vertical: 12.h,
      horizontal: 16.w,
    ),
    labelStyle: TextStyle(
      fontSize: 12.sp,
      color: AppColors.vividPurple,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpaces.radiusSmall),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpaces.radiusSmall),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpaces.radiusSmall),
      borderSide: BorderSide(
        color: AppColors.purple,
        width: 1.5,
      ),
    ),
  );
}
