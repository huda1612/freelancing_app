import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_icons.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';
import 'package:freelancing_platform/core/utils/helper_function/validators.dart';
import 'package:freelancing_platform/core/widgets/base_screen.dart';
import 'package:freelancing_platform/core/widgets/custom_app_bar.dart';
import 'package:freelancing_platform/core/widgets/custom_button.dart';
import 'package:freelancing_platform/core/widgets/custom_text_field.dart';
import 'package:freelancing_platform/core/widgets/interactive_text_link.dart';
import 'package:freelancing_platform/views/auth_section/auth_controller/auth_controller.dart';
import 'package:freelancing_platform/views/auth_section/auth_controller/google_sign_in_controller.dart';
import 'package:get/get.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    final googleController = Get.find<GoogleSignInController>();

    return BaseScreen(
        appBar: CustomAppBar(
          // leadingIcon: IconButton(
          //   onPressed: () => Get.toNamed(AppRoutes.join),
          //   icon: const Icon(Icons.arrow_back),
          // ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: AppSpaces.screenHorizontalPadding.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("سعيدون بعودتك من جديد", style: AppTextStyles.meduimstyle),

                SizedBox(height: AppSpaces.heightSmall),
                Text("سجّل الدخول لنكمل العمل معًا", style: AppTextStyles.body),

                SizedBox(height: AppSpaces.heightMedium),

                // EMAIL
                CustomTextField(
                  hintText: "البريد الإلكتروني",
                  onChanged: (value) => controller.email.value = value,
                  validator: Validators.email,
                ),

                SizedBox(height: AppSpaces.heightMedium),

                // PASSWORD
                CustomTextField(
                  hintText: "كلمة المرور",
                  obscureText: true,
                  onChanged: (value) => controller.password.value = value,
                  validator:Validators.password,
                ),

                SizedBox(height: AppSpaces.heightSmall),
                Align(
                  alignment: Alignment.centerRight,
                  child: InteractiveTextLink(
                    text: "نسيت كلمة المرور؟",
                    onTap: controller.resetPassword,
                   
                  ),
                ),

                SizedBox(height: AppSpaces.heightLarge),

                // LOGIN BUTTON with email
                SizedBox(
                  width: 380.w,
                  child: Obx(() {
                    if (controller.isLoginLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return CustomButton(
                      text: "تسجيل الدخول",
                      onTap: controller.login,
                    );
                  }),
                 
                ),
                SizedBox(height: AppSpaces.heightLarge),

                //or line
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: AppColors.veryLightGrey,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Text(
                        "أو",
                        style: AppTextStyles.button
                            .copyWith(color: AppColors.veryLightGrey),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: AppColors.veryLightGrey,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpaces.heightLarge),

                // LOGIN BUTTON with google
                SizedBox(
                  width: 380.w,
                  child: CustomButton(
                      text: "تسجيل الدخول باستخدام حساب جوجل",
                      textStyle:
                          AppTextStyles.button.copyWith(color: AppColors.black),
                      prefix: Image.asset(
                        AppIcons.google,
                        width: 24.w,
                        height: 24.h,
                      ),
                      color: AppColors.white,
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
                      InteractiveTextLink(
                        text: "إنشاء حساب",
                        onTap: () => Get.toNamed(AppRoutes.register),
                      ),
                      Text(
                        " ليس لديك حساب ؟",
                        style:
                            AppTextStyles.link.copyWith(color: AppColors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
