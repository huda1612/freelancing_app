import 'package:flutter/material.dart';
import 'package:freelancing_platform/controllers/auth/google_sign_in_controller.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';
import 'package:freelancing_platform/core/utils/helper_function/validators.dart';
import 'package:freelancing_platform/core/widgets/custom_app_bar.dart';
import 'package:freelancing_platform/core/widgets/custom_button.dart';
import 'package:freelancing_platform/core/widgets/custom_text_field.dart';
import 'package:freelancing_platform/core/widgets/interactive_text_link.dart';
import 'package:get/get.dart';
import '../../controllers/auth/auth_controller.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthController());
    final googleController = Get.put(GoogleSignInController());

    return Scaffold(
        appBar: CustomAppBar(
          leadingIcon: IconButton(
            onPressed: () => Get.toNamed(AppRoutes.accountSelection),
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
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
                  Text("سعيدون بعودتك من جديد",
                      style: AppTextStyles.meduimstyle),

                  SizedBox(height: AppSpaces.heightSmall),
                  Text("سجّل الدخول لنكمل العمل معًا",
                      style: AppTextStyles.body),

                  SizedBox(height: AppSpaces.heightMedium),

                  // EMAIL
                  CustomTextField(
                    hintText: "البريد الإلكتروني",
                    onChanged: (value) => controller.email.value = value,
                    validator: (value) => Validators.email(value ?? ""),
                  ),

                  // ERROR MESSAGE
                  Obx(() {
                    final error = Validators.email(controller.email.value);
                    return error == null
                        ? const SizedBox()
                        : Text(
                            error,
                            style: AppTextStyles.inputLabel.copyWith(
                              color: Colors.red,
                            ),
                          );
                  }),

                  SizedBox(height: AppSpaces.heightMedium),

                  // PASSWORD
                  CustomTextField(
                    hintText: "كلمة المرور",
                    obscureText: true,
                    onChanged: (value) => controller.password.value = value,
                    validator: (value) => Validators.password(value ?? ""),
                  ),

                  // ERROR MESSAGE
                  Obx(() {
                    final error =
                        Validators.password(controller.password.value);
                    return error == null
                        ? const SizedBox()
                        : Text(
                            error,
                            style: AppTextStyles.inputLabel.copyWith(
                              color: Colors.red,
                            ),
                          );
                  }),
                  SizedBox(height: AppSpaces.heightSmall),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InteractiveTextLink(
                      text: "نسيت كلمة المرور؟",
                      // onTap: () => Get.toNamed(AppRoutes.forgotPassword),
                      onTap: controller.resetPassword,
                      // onTap: ,
                    ),
                  ),

                  SizedBox(height: AppSpaces.heightLarge),

                  // LOGIN BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: "تسجيل الدخول",
                      onTap: controller.login,
                    ),
                  ),
                  SizedBox(height: AppSpaces.heightLarge),

                  // LOGIN BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                        text: "تسجيل الدخول باستخدام حساب جوجل",
                        onTap: () async {
                          await googleController.signInWithGoogle();
                          // هون لازم عيد توجيهه لصفحة الرئيسية حسب نوع المستخدم!!!!!!!!!!!!!!!!!!!!
                        }),
                  ),

                  SizedBox(height: AppSpaces.heightMedium),
                  SizedBox(
                    width: double.infinity,
                    // child: Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Text(
                    //       "ليس لديك حساب ؟",
                    //       style: AppTextStyles.link
                    //           .copyWith(color: AppColors.grey),
                    //     ),
                    //     InteractiveTextLink(
                    //       text: "إنشاء حساب",
                    //       onTap: () => Get.toNamed(AppRoutes.register),
                    //     ),
                    //   ],
                    // ),
                  ),
                ],
              ),
            ),
          ),
        )));
  }
}
