import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';


Widget titleText(String t) {
  return Text(
    t,
    style: AppTextStyles.subheading.copyWith(color: AppColors.darkPurple),
  );
}
