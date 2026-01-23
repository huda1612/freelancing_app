import 'package:flutter/material.dart';
import 'package:freelancing_platform/controllers/splash/splash_controller.dart';
import 'package:freelancing_platform/core/constants/app_assets.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_text_styles.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.softPurple, // بنفسجي
               AppColors.softBlue, // أزرق
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 240.h,
                child: Image.asset(
                 AppAssets.logo1,
                  fit: BoxFit.contain,
                ),
              ),

              SizedBox(height: AppSpaces.heightSmall),

              Text(
                "بيزي نحول",
                style: AppTextStyles.heading,
              ),

              SizedBox(height: AppSpaces.heightSmall),

              Text(
                "منصّة تجمع بين الوظائف والعمل الحر",
                style: AppTextStyles.subheading,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
