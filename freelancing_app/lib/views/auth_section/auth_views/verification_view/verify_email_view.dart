import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';
import 'package:freelancing_platform/core/widgets/base_screen.dart';
import 'package:freelancing_platform/core/widgets/custom_button.dart';
import 'package:freelancing_platform/views/auth_section/auth_controller/auth_controller.dart';
import 'package:get/get.dart';

class VerifyEmailView extends StatelessWidget {
  const VerifyEmailView({super.key});

  @override
  Widget build(BuildContext context) {
 final controller = Get.find<AuthController>();

    return BaseScreen( 
       body: Center( child: Column(
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
                  SizedBox(
                width: 380.w,
                  child:  CustomButton(
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
                  ),
                  SizedBox(height: AppSpaces.heightMedium),

                  // زر تم التفعيل
                  SizedBox(
                width: 380.w,
                  child:                  CustomButton(
                    text: "تم التفعيل",
                    onTap: controller.checkIfVerified,
                    color: AppColors.vividPurple,
                  ),),
                ],
              ),
            ),
          );
  }
}
