import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';

Widget customEmptyMessage({required String? message}) {
  return Center(
    child: Text(
      message ?? "لا يوجد بيانات",
      style: AppTextStyles.blacksubheading.copyWith(color: AppColors.grey),
    ),
  );
}
