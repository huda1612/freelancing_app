import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_icons.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';
import 'package:freelancing_platform/core/constants/user_roles.dart';
import 'package:freelancing_platform/core/utils/helper_function/validators.dart';
import 'package:freelancing_platform/core/widgets/base_screen.dart';
import 'package:freelancing_platform/core/widgets/custom_app_bar.dart';
import 'package:freelancing_platform/core/widgets/custom_button.dart';
import 'package:freelancing_platform/core/widgets/custom_text_field.dart';
import 'package:freelancing_platform/core/widgets/interactive_text_link.dart';
import 'package:freelancing_platform/views/auth_section/auth_controller/auth_controller.dart';
import 'package:freelancing_platform/views/auth_section/auth_controller/google_sign_in_controller.dart';
import 'package:freelancing_platform/views/auth_section/widgets/role_option.dart';
import 'package:get/get.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

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
                  keyboardType: TextInputType.name,
                  onChanged: (value) => controller.firstName.value = value,
                  validator: Validators.firstName,
                ),

                SizedBox(height: AppSpaces.heightMedium),
                // الاسم الاخير
                CustomTextField(
                  hintText: "الاسم الأخير",
                  keyboardType: TextInputType.name,
                  onChanged: (value) => controller.lastName.value = value,
                  validator: Validators.lastName,
                ),
                SizedBox(height: AppSpaces.heightMedium),
                CustomTextField(
                  hintText: "اسم المستخدم",
                  keyboardType: TextInputType.name,
                  // onChanged: (value) => controller.username.value = value,
                  onChanged: controller.onUsernameChanged,
                  validator: Validators.username,
                ),
                Obx(() {
                  if (controller.usernameError.value != null) {
                    return Text(
                      controller.usernameError.value!,
                      style: const TextStyle(color: Colors.red),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                }),
                SizedBox(height: AppSpaces.heightMedium),

                // الاييمل
                CustomTextField(
                  hintText: "البريد الإلكتروني",
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) => controller.email.value = value,
                  validator: Validators.email,
                ),

                SizedBox(height: AppSpaces.heightMedium),

                //الباسوورد
                CustomTextField(
                  hintText: "كلمة المرور",
                  obscureText: true,
                  onChanged: (value) => controller.password.value = value,
                  validator: Validators.password,
                ),

                SizedBox(height: AppSpaces.heightMedium),

                //تاكيد الباسوورد
                CustomTextField(
                  hintText: " تأكيد كلمة المرور ",
                  obscureText: true,
                  onChanged: (value) =>
                      controller.confirmPassword.value = value,
                  validator: (value) => Validators.confirmPassword(
                    value,
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
                          label: "client",
                          icon: Icons.person_outline,
                          isSelected:
                              controller.userRole.value == UserRole.client,
                          onTap: () =>
                              controller.userRole.value = UserRole.client,
                        ),

                        SizedBox(width: 16.w),

                        // زر المستقل
                        RoleOption(
                          label: "freelancer",
                          icon: Icons.work_outline,
                          isSelected:
                              controller.userRole.value == UserRole.freelancer,
                          onTap: () =>
                              controller.userRole.value = UserRole.freelancer,
                        ),
                      ],
                    )),

                SizedBox(height: AppSpaces.heightMedium),

                /// الموافقة على الشروط
                Row(
                  children: [
                    Obx(() => Checkbox(
                          // value: controller.agreed.value,
                          // onChanged: (v) {},
                          value: controller.agreed.value,
                          onChanged: (v) {
                            controller.agreed.value = v!;
                          },
                        )),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "أوافق على ",
                            style: AppTextStyles.link
                                .copyWith(color: AppColors.grey),
                          ),
                          InteractiveTextLink(
                            text: "شروط الخدمة",
                            onTap: () => Get.toNamed(AppRoutes.terms),
                          ),
                          Text(
                            " و ",
                            style: AppTextStyles.link
                                .copyWith(color: AppColors.grey),
                          ),
                          InteractiveTextLink(
                            text: "سياسة الخصوصية",
                            onTap: () => Get.toNamed(AppRoutes.privacy),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpaces.heightMedium),

                // زر انشاء حساب
                SizedBox(
                  width: 380.w,
                  child: Obx(() {
                    // if (controller.isRegisterLoading.value) {
                    //   return const Center(
                    //     child: CircularProgressIndicator(),
                    //   );
                    // }
                    return CustomButton(
                      isLoading: controller.isRegisterLoading.value,
                      text: "إنشاء حساب",
                      onTap: controller.register,
                    );
                  }),
                ),
                SizedBox(height: AppSpaces.heightSmall),

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
                    },
                  ),
                ),
                SizedBox(height: AppSpaces.heightMedium),

                SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        " لديك حساب ؟ ",
                        style: AppTextStyles.link.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                      InteractiveTextLink(
                        text: "تسجيل الدخول",
                        onTap: () => Get.toNamed(AppRoutes.login),
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
