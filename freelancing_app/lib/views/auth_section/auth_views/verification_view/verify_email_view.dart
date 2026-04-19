import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';
import 'package:freelancing_platform/core/widgets/base_screen.dart';
import 'package:freelancing_platform/core/widgets/custom_button.dart';
import 'package:freelancing_platform/views/auth_section/auth_controller/sign_out_controller.dart';
import 'package:freelancing_platform/views/auth_section/auth_controller/verify_email_controller.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class VerifyEmailView extends StatelessWidget {
  const VerifyEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VerifyEmailController>(
        init: Get.put<VerifyEmailController>(VerifyEmailController()),
        builder: (controller) {
          return ModalProgressHUD(
            inAsyncCall: controller.state == StatusClasses.isloading,
            child: BaseScreen(
              body: Center(
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
                    Obx(() {
                      return SizedBox(
                        width: 380.w,
                        child: CustomButton(
                            isDisable: !controller.canResend.value,
                            text: controller.canResend.value
                                ? "إعادة إرسال رابط التفعيل"
                                : "انتظر ${controller.resendSeconds.value}s",
                            onTap:
                                // ?controller.canResend.value
                                () async {
                              await controller.sendVerificationEmail();
                            }
                            // : () {},
                            ),
                      );
                    }),
                    SizedBox(height: AppSpaces.heightMedium),

                    // زر تم التفعيل
                    SizedBox(
                      width: 380.w,
                      child: CustomButton(
                        text: "تم التفعيل",
                        onTap: controller.checkIfVerified,
                        color: AppColors.vividPurple,
                      ),
                    ),

                    SizedBox(height: AppSpaces.heightLarge),

                    // زر تسجيل الخروج
                    GetBuilder<SignOutController>(
                        init: Get.put<SignOutController>(SignOutController()),
                        builder: (signOutController) {
                          return SizedBox(
                            width: 380.w,
                            child:
                                // signOutController.signOutIsLoading
                                // ? CustomLoading():
                                CustomButton(
                              isLoading: signOutController.signOutIsLoading,
                              prefix: Icon(
                                Icons.logout,
                                color: AppColors.white,
                              ),
                              text: "تسجيل الخروج",
                              onTap: signOutController.signOut,
                              color: AppColors.vividPurple,
                            ),
                          );
                        })
                  ],
                ),
              ),
            ),
          );
        });
  }
}
