import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/controllers/auth/google_sign_in_controller.dart';
import 'package:freelancing_platform/core/constants/app_assets.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';
import 'package:freelancing_platform/core/widgets/custom_button.dart';
import 'package:freelancing_platform/core/widgets/interactive_text_link.dart';
import 'package:get/get.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final googleController = Get.put(GoogleSignInController());

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
              SizedBox(height: AppSpaces.heightLarge),
              Text(
                "أهلا بك في منصة بيزي نحول",
                style: AppTextStyles.heading,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSpaces.heightLarge),
              SizedBox(
                width: 250.w,
                child: CustomButton(
                  text: "الدخول عبر البريد الإلكتروني",
                  onTap: () => Get.toNamed(AppRoutes.login),
                ),
              ),
              SizedBox(height: AppSpaces.heightSmall),
              SizedBox(
                width: 250.w,
                child: CustomButton(
                    text: "الدخول باستخدام حساب جوجل",
                    // onTap: () => Get.toNamed(AppRoutes.login),
                    onTap: () async {
                      await googleController.signInWithGoogle();
                      // هون لازم عيد توجيهه لصفحة الرئيسية حسب نوع المستخدم!!!!!!!!!!!!!!!!!!!!
                    }),
              ),
              SizedBox(height: AppSpaces.heightMedium),
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "ليس لديك حساب ؟",
                      style: AppTextStyles.link.copyWith(color: AppColors.grey),
                    ),
                    InteractiveTextLink(
                      text: "إنشاء حساب",
                      onTap: () => Get.toNamed(AppRoutes.register),
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
