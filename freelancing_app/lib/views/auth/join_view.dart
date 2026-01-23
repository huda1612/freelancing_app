import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_assets.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/widgets/interactive_text_link.dart';
import 'package:get/get.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/widgets/custom_button.dart';

class JoinView extends StatelessWidget {
  const JoinView({super.key});

  @override
  Widget build(BuildContext context) {
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
                child: Image.asset(AppAssets.logo1, fit: BoxFit.contain),
              ),

              SizedBox(height: AppSpaces.heightSmall),

              Text("بيزي نحول", style: AppTextStyles.heading),

              SizedBox(height: AppSpaces.heightSmall),

              Text(
                "منصّة تجمع بين الوظائف والعمل الحر",
                style: AppTextStyles.subheading,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSpaces.heightLarge),
              Text("انضم إلى المنصة", style: AppTextStyles.heading),
              SizedBox(height: AppSpaces.heightMedium),

              CustomButton(
                text: "إنشاء حساب عبر البريد الإلكتروني",
                onTap: () => Get.toNamed(AppRoutes.register),
              ),

              SizedBox(height: AppSpaces.heightMedium),

              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "لديك حساب ؟",
                      style: AppTextStyles.link.copyWith(color: AppColors.grey),
                    ),
                    InteractiveTextLink(
                      text: "تسجيل الدخول",
                      onTap: () => Get.toNamed(AppRoutes.accountSelection),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpaces.heightLarge),
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "بالتسجيل، أنت توافق على ",
                      style: AppTextStyles.link.copyWith(color: AppColors.grey),
                    ),
                    InteractiveTextLink(
                      text: "شروط الخدمة",
                      onTap: () {
                        // افتحي صفحة الشروط
                        Get.toNamed(AppRoutes.terms);
                      },
                    ),
                    Text(
                      " و ",
                      style: AppTextStyles.link.copyWith(color: AppColors.grey),
                    ),
                    InteractiveTextLink(
                      text: "سياسة الخصوصية",
                      onTap: () {
                        // افتحي صفحة الخصوصية
                        Get.toNamed(AppRoutes.privacy);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
