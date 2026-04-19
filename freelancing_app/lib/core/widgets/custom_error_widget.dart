import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';
import 'package:freelancing_platform/core/widgets/custom_button.dart';

class CustomErrorWidget extends StatelessWidget {
  final String? message;
  final String? title;
  final VoidCallback? onRetry;
  const CustomErrorWidget({super.key, this.message, this.title, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(color: Colors.black, blurRadius: 10),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.veryLightGrey,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error,
                size: 50.w,
                color: Colors.red,
              ),
            ),
            SizedBox(height: AppSpaces.heightMedium),
            Text(
              title ?? "حدث خطأ",
              style: AppTextStyles.heading.copyWith(
                fontSize: 20.sp,
                color: AppColors.darkGrey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message ?? "حدث خطأ غير متوقع",
              style: AppTextStyles.body.copyWith(
                color: AppColors.darkGrey,
                // fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpaces.heightLarge),
            CustomButton(
                width: 150.w,
                // color: AppColors.veryLightGrey,
                prefix: Icon(
                  Icons.replay_outlined,
                  color: AppColors.white,
                ),
                text: "اعادة المحاولة",
                onTap: onRetry ?? () {}),
          ],
        ),
      ),
    );
  }
}
