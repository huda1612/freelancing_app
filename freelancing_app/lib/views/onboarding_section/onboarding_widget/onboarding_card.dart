import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/widgets/custom_button.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class OnboardingCard extends StatelessWidget {
  final String assetPath;
  final String title;
  final String subtitle;
  final bool isLast;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final double progressValue;

  const OnboardingCard({
    super.key,
    required this.assetPath,
    required this.title,
    required this.subtitle,
    required this.isLast,
    required this.onNext,
    required this.onSkip,
    required this.progressValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.darkBackground,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 0.70.sh,
                width: double.infinity,

                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.softPurple, // بنفسجي
                      AppColors.softBlue, // أزرق
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(AppSpaces.radiusMedium),
                    bottomRight: Radius.circular(AppSpaces.radiusMedium),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpaces.paddingLarge,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: AppSpaces.heightSmall),
                      if (!isLast)
                        Align(
                          alignment: Alignment.topRight,
                          child: CustomButton(
                            text: "تخطي",
                            onTap: onSkip,
                            width: 75.w,
                            height: 52.h,
                            color: AppColors.veryLightGrey,
                            borderRadius: BorderRadius.all(
                              Radius.circular(AppSpaces.radiusMedium),
                            ),
                            textStyle: AppTextStyles.link.copyWith(fontSize:10.sp ),
                          ),
                        ),
                      SizedBox(height: AppSpaces.heightLarge),
                      SizedBox(
                        height: 300.h,
                        child: Image.asset(
                          assetPath,
                          width: 300.w,
                          height: 300.h,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: AppSpaces.heightLarge),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.meduimstyle,
              ),
              SizedBox(height: AppSpaces.heightMedium),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.body,
              ),

              SizedBox(height: AppSpaces.heightMedium),

              isLast
                  ? SizedBox(
                      width: 380.w,
                      child: CustomButton(text: "ابدأ", onTap: onNext),
                    )
                  : GestureDetector(
                      onTap: onNext,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Progress على الدائرة الخارجية
                          SizedBox(
                            height: 58.h,
                            width: 58.h,
                            child: CircularProgressIndicator(
                              value: progressValue, // 0.25 - 0.5 - 0.75 - 1.0
                              strokeWidth: 3.w,
                              backgroundColor: Colors.transparent,
                              valueColor: AlwaysStoppedAnimation(
                                AppColors.vividPurple,
                              ),
                            ),
                          ),

                          // الدائرة الوسطى
                          Container(
                            height: 54.h,
                            width: 54.h,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.darkBackground, // لون الخلفية
                            ),
                          ),

                          // الدائرة الداخلية
                          Container(
                            height: 46.h,
                            width: 46.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.white,
                              border: Border.all(
                                color: AppColors.white,
                                width: 2.w,
                              ),
                            ),
                            child: const Icon(
                              Icons.arrow_forward,
                              color: AppColors.black,
                            ),
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
