import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_icons.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';
import 'package:freelancing_platform/core/widgets/app_brand.dart';
import 'package:freelancing_platform/core/widgets/base_screen.dart';
import 'package:freelancing_platform/core/widgets/custom_button.dart';
import 'package:freelancing_platform/core/widgets/interactive_text_link.dart';
import 'package:freelancing_platform/views/auth_section/auth_controller/google_sign_in_controller.dart';
import 'package:get/get.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final googleController = Get.find<GoogleSignInController>();

    return BaseScreen(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: AppSpaces.heightMedium2),
              AppBrand(),

              SizedBox(height: AppSpaces.heightLarge),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "  أهلا بك في منصة  ",
                    style: AppTextStyles.blacksubheading,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    " FREELANCITY",
                    style: AppTextStyles.heading,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              SizedBox(height: AppSpaces.heightLarge),
              //زر للدخول بالايميل
              SizedBox(
                width: 380.w,
                child: CustomButton(
                  text: "الدخول عبر البريد الإلكتروني",
                  onTap: () => Get.toNamed(AppRoutes.login),
                ),
              ),
              SizedBox(height: AppSpaces.heightSmall),
              //زر للدخول بجوجل
              SizedBox(
                width: 380.w,
                child: CustomButton(
                    text: "الدخول باستخدام حساب جوجل",
                    textStyle:
                        AppTextStyles.button.copyWith(color: AppColors.black),

                    // onTap: () => Get.toNamed(AppRoutes.login),
                    color: AppColors.white,
                    prefix: Image.asset(
                      AppIcons.google,
                      width: 24.w,
                      height: 24.h,
                    ),
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
                      " ليس لديك حساب ؟",
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
