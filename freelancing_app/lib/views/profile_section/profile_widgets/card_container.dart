import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';

Widget cardContainer({required Widget child}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      // color: AppColors.white,
      borderRadius: BorderRadius.circular(AppSpaces.radiusMedium),
    ),
    child: child,
  );
}
