import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';
import 'package:freelancing_platform/core/widgets/custom_button.dart';
import 'package:freelancing_platform/core/widgets/custom_bottom_sheet_container.dart';

class CompleteStripeSetupBottomSheet extends StatelessWidget {
  final VoidCallback onContinuePressed;
  final bool isLoading;

  const CompleteStripeSetupBottomSheet(
      {super.key, required this.onContinuePressed, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheetContainer(
      children: [
        Container(
          padding: EdgeInsets.all(18.w),
          decoration: BoxDecoration(
            color: AppColors.vividPurple.withOpacity(0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.account_balance_wallet_outlined,
            size: 42.sp,
            color: AppColors.vividPurple,
          ),
        ),
        SizedBox(height: AppSpaces.heightMedium),
        Text(
          'إكمال إعداد الحساب',
          textAlign: TextAlign.center,
          style: AppTextStyles.blacksubheading,
        ),
        SizedBox(height: AppSpaces.heightMedium),
        Text(
          'حساب الدفع الخاص بك لم يكتمل إعداده بعد.\nيرجى متابعة الإعداد لإمكانية استلام الدفعات من العملاء.',
          textAlign: TextAlign.center,
          style: AppTextStyles.body.copyWith(
            color: AppColors.normalGrey,
          ),
        ),
        SizedBox(height: AppSpaces.heightLarge),
        CustomButton(
          text: 'متابعة الإعداد',
          onTap: onContinuePressed,
          noShadow: true,
          isLoading: isLoading,
        ),
      ],
    );
  }
}
