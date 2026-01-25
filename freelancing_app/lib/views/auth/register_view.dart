import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/controllers/auth/google_sign_in_controller.dart';
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
import 'package:freelancing_platform/views/auth/widgets/role_option.dart';
import 'package:get/get.dart';
import '../../controllers/auth/auth_controller.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthController());
    final googleController = Get.put(GoogleSignInController());

    return BaseScreen(
        appBar: CustomAppBar(
          leadingIcon: IconButton(
            onPressed: () => Get.toNamed(AppRoutes.accountSelection),
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: AppSpaces.screenHorizontalPadding.h,
              horizontal: AppSpaces.mediumVerticalSpacing.w,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "ابدأ رحلتك في العمل الحر بثقة",
                  style: AppTextStyles.meduimstyle,
                ),

                SizedBox(height: AppSpaces.heightSmall),
                Text("أنشئ حسابك وحقق أهدافك", style: AppTextStyles.body),

                SizedBox(height: AppSpaces.heightMedium),
//الاسم الاول
                CustomTextField(
                  hintText: "الاسم الأول",
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) => controller.firstName.value = value,
                  validator: (value) => Validators.firstName(value ?? ""),
                ),

                SizedBox(height: AppSpaces.heightMedium),
                // الاسم الاخير
                CustomTextField(
                  hintText: "الاسم الأخير",
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) => controller.lastName.value = value,
                  validator: (value) => Validators.lastName(value ?? ""),
                ),

                SizedBox(height: AppSpaces.heightMedium),

                // الاييمل
                CustomTextField(
                  hintText: "البريد الإلكتروني",
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) => controller.email.value = value,
                  validator: (value) => Validators.email(value ?? ""),
                ),

                SizedBox(height: AppSpaces.heightMedium),

                //الباسوورد
                CustomTextField(
                  hintText: "كلمة المرور",
                  obscureText: true,
                  onChanged: (value) => controller.password.value = value,
                  validator: (value) => Validators.password(value ?? ""),
                ),

                SizedBox(height: AppSpaces.heightMedium),

                //تاكيد الباسوورد
                CustomTextField(
                  hintText: " تأكيد كلمة المرور ",
                  obscureText: true,
                  onChanged: (value) =>
                      controller.confirmPassword.value = value,
                  validator: (value) => Validators.confirmPassword(
                    value ?? "",
                    controller.password.value,
                  ),
                ),

                SizedBox(height: AppSpaces.heightMedium),
                //لاختيار مستقل او عميل
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "نوع الحساب",
                    style: AppTextStyles.body
                        .copyWith(color: AppColors.darkBackground),
                  ),
                ),

                SizedBox(height: 12),

                Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // زر العميل
                        RoleOption(
                          label: "عميل",
                          icon: Icons.person_outline,
                          isSelected: controller.userRole.value == "client",
                          onTap: () => controller.userRole.value = "client",
                        ),

                        SizedBox(width: 16.w),

                        // زر المستقل
                        RoleOption(
                          label: "مستقل",
                          icon: Icons.work_outline,
                          isSelected: controller.userRole.value == "freelancer",
                          onTap: () => controller.userRole.value = "freelancer",
                        ),
                      ],
                    )),

                SizedBox(height: AppSpaces.heightLarge),

                // زر انشاء حساب
                SizedBox(
                  width: 380.w,
                  child: CustomButton(
                    text: "إنشاء حساب",
                    onTap: controller.register,
                  ),
                ),
                SizedBox(height: AppSpaces.heightSmall),

                //للشروط المنصة
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InteractiveTextLink(
                        text: "سياسة الخصوصية",
                        onTap: () {
                          // افتحي صفحة الخصوصية
                          //     Get.toNamed(AppRoutes.privacy);
                        },
                      ),
                      Text(
                        " و ",
                        style:
                            AppTextStyles.link.copyWith(color: AppColors.grey),
                      ),
                      InteractiveTextLink(
                        text: "شروط الخدمة",
                        onTap: () {
                          // افتحي صفحة الشروط
                          // Get.toNamed(AppRoutes.terms);
                        },
                      ),
                      Text(
                        "بالتسجيل، أنت توافق على ",
                        style:
                            AppTextStyles.link.copyWith(color: AppColors.grey),
                      ),
                    ],
                  ),
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
                    text: "الدخول باستخدام حساب جوجل",
                    color: AppColors.white,
                    textStyle:
                        AppTextStyles.button.copyWith(color: AppColors.black),
                    prefix: Image.asset(
                      AppIcons.google,
                      width: 24.w,
                      height: 24.h,
                    ),
                    onTap: () async {
                      await googleController.signInWithGoogle();
                      // هون لازم عيد توجيهه لصفحة الرئيسية حسب نوع المستخدم!!!!!!!!!!!!!!!!!!!!
                    },
                  ),
                ),
                SizedBox(height: AppSpaces.heightMedium),

                SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InteractiveTextLink(
                        text: "تسجيل الدخول",
                        onTap: () => Get.toNamed(AppRoutes.login),
                      ),
                      Text(
                        " لديك حساب ؟",
                        style: AppTextStyles.link.copyWith(
                          color: AppColors.grey,
                        ),
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
