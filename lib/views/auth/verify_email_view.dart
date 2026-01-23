import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';
import 'package:freelancing_platform/core/widgets/custom_button.dart';
import 'package:get/get.dart';
import '../../controllers/auth/auth_controller.dart';

class VerifyEmailView extends StatelessWidget {
  const VerifyEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthController());

    return Scaffold(
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
                    "تحقق من بريدك الإلكتروني",
                    style: AppTextStyles.meduimstyle,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppSpaces.heightSmall),
                  Text(
                    "لقد أرسلنا رابط تفعيل إلى بريدك. يرجى فتح الرابط ثم العودة للتطبيق.",
                    style: AppTextStyles.body,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppSpaces.heightLarge),

                  // زر إعادة إرسال الرابط
                  CustomButton(
                    text: "إعادة إرسال رابط التفعيل",
                    onTap: () async {
                      await controller.sendVerificationEmail();
                      Get.snackbar(
                        "تم الإرسال",
                        "تم إرسال رابط التفعيل مرة أخرى",
                        backgroundColor: Colors.green,
                        colorText: const Color.fromARGB(255, 255, 255, 255),
                      );
                    },
                  ),

                  SizedBox(height: AppSpaces.heightMedium),

                  // زر تم التفعيل
                  CustomButton(
                    text: "تم التفعيل",
                    onTap: controller.login,
                    //هاد الاصلي بس حطيت الفوق ليشتغل الكود
                    //onTap: controller.goToHomeIfVerified,
                    color: AppColors.vividPurple,
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
