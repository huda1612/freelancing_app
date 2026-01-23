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

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

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
                  Text(
                    "ابدأ رحلتك في العمل الحر بثقة",
                    style: AppTextStyles.meduimstyle,
                  ),

                  SizedBox(height: AppSpaces.heightSmall),
                  Text("أنشئ حسابك وحقق أهدافك", style: AppTextStyles.body),

                  SizedBox(height: AppSpaces.heightMedium),

                  // EMAIL
                  CustomTextField(
                    hintText: "البريد الإلكتروني",
                    keyboardType: TextInputType.emailAddress,
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
                    final error = Validators.password(
                      controller.password.value,
                    );
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

                  //confirm pass
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

                  // ERROR MESSAGE
                  Obx(() {
                    final error = Validators.confirmPassword(
                      controller.confirmPassword.value,
                      controller.password.value,
                    );
                    return error == null
                        ? const SizedBox()
                        : Text(
                            error,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          );
                  }),

                  SizedBox(height: AppSpaces.heightLarge),

                  // LOGIN BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: "إنشاء حساب",
                      onTap: controller.register,
                    ),
                  ),
                  SizedBox(height: AppSpaces.heightLarge),
                  // LOGIN BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: "الدخول باستخدام حساب جوجل",
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
                        Text(
                          "لديك حساب ؟",
                          style: AppTextStyles.link.copyWith(
                            color: AppColors.grey,
                          ),
                        ),
                        InteractiveTextLink(
                          text: "تسجيل الدخول",
                          onTap: () => Get.toNamed(AppRoutes.accountSelection),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
