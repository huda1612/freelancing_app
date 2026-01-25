import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSpaces {
  // -------------------------
  // Responsive Spacing (ScreenUtil)
  // -------------------------

  // Padding
  static double get paddingSmall => 8.w;
  static double get paddingMedium => 16.w;
  static double get paddingLarge => 24.w;

  // Margin
  static double get marginSmall => 8.w;
  static double get marginMedium => 16.w;

  // Border radius
  static double get radiusSmall => 8.r;
  static double get radiusMedium => 16.r;
  static double get radiusLarge => 24.r;

  // SizedBox Heights
  static double get heightSmall => 8.h;
  static double get heightMedium => 16.h;
  static double get heightLarge => 32.h;

  // SizedBox width
  static double get width => 12.w;

  // -------------------------
  // ثابتة (بدون ScreenUtil)
  // -------------------------

  static const double screenHorizontalPadding = 20.0;
  static const double mediumHorizontalPadding = 16.0;
  static const double smallHorizontalPadding = 8.0;
  static const double mediumVerticalSpacing = 14.0;
  static const double largeVerticalSpacing = 24.0;
  static const double smallVerticalSpacing = 8.0;

  // -------------------------
  // Responsive Padding (ScreenUtil)
  // -------------------------

  static EdgeInsets get screenPadding => EdgeInsets.symmetric(
        horizontal: screenHorizontalPadding.w,
        vertical: mediumVerticalSpacing.h,
      );
}
