import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

void customSnackbar({required String message}) {
  Get.snackbar(
    "",
    "",
    barBlur: 0,
    titleText: const SizedBox(), // بدون عنوان
    messageText: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
      decoration: BoxDecoration(
        color: AppColors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          message,
          // "تم الحفظ بنجاح",
          style: TextStyle(color: Colors.white),
        ),
      ),
    ),
    animationDuration: Duration.zero,
    forwardAnimationCurve: Curves.linear,

    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.transparent,
    margin: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
    duration: const Duration(seconds: 2),
    isDismissible: false,
    // forwardAnimationCurve: Curves.easeOut,
  );
}
