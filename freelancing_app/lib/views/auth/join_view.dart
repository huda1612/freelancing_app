import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_assets.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_icons.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/widgets/base_screen.dart';
import 'package:freelancing_platform/core/widgets/interactive_text_link.dart';
import 'package:get/get.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/widgets/custom_button.dart';

class JoinView extends StatelessWidget {
  const JoinView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 40.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //الشعار
                SizedBox(
                  height: 240.h,
                  child: Image.asset(AppAssets.logo, fit: BoxFit.contain),
                ),
                SizedBox(height: AppSpaces.heightSmall),
                //اسم التطبيق
                Text( "FREELANCITY", style: AppTextStyles.heading),
                SizedBox(height: AppSpaces.heightSmall),
                Text(
                  "منصّة تجمع بين الوظائف والعمل الحر",
                  style: AppTextStyles.subheading,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppSpaces.heightLarge),
                Text("انضم إلى المنصة", style: AppTextStyles.heading),
                SizedBox(height: AppSpaces.heightMedium),
                //زر انشاء حساب بالايميل
                SizedBox(
                  width: 380.w,
                  child: CustomButton(
                    text: "إنشاء حساب عبر البريد الإلكتروني",
                    onTap: () => Get.toNamed(AppRoutes.register),
                  ),
                ),
                SizedBox(height: AppSpaces.heightMedium),
                //زر بالجوجل
                SizedBox(
                  width: 380.w,
                  child: CustomButton(
                    text: "الدخول باستخدام حساب جوجل",
                                      textStyle: AppTextStyles.button.copyWith(color: AppColors.black),

                    color: AppColors.white,
                    prefix: Image.asset(
                      AppIcons.google,
                      width: 24.w,
                      height: 24.h,
                    ),
                    onTap: () async {
                      //await googleController.signInWithGoogle();
                      // هون لازم عيد توجيهه لصفحة الرئيسية حسب نوع المستخدم!!!!!!!!!!!!!!!!!!!!
                    },
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "لديك حساب ؟",
                        style:
                            AppTextStyles.link.copyWith(color: AppColors.grey),
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
                        style:
                            AppTextStyles.link.copyWith(color: AppColors.grey),
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
                        style:
                            AppTextStyles.link.copyWith(color: AppColors.grey),
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
      ),
    );
  }
}
