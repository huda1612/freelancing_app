import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';
import 'package:freelancing_platform/core/widgets/custom_bottom_sheet_container.dart';
import 'package:freelancing_platform/core/widgets/custom_button.dart';

class PaymentAccountCreateBottomSheet extends StatelessWidget {
  final VoidCallback onSetupPressed;
  final bool isLoading;

  const PaymentAccountCreateBottomSheet({
    super.key,
    required this.onSetupPressed,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheetContainer(
      children: [
        SizedBox(height: 8.h),

        /// Title
        Text(
          "حساب الدفع",
          style: AppTextStyles.heading.copyWith(
            color: AppColors.black,
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 12.h),

        /// Description
        Text(
          "لإمكانية استلام الدفعات من العملاء\nيجب إعداد حساب الدفع أولاً.",
          style: AppTextStyles.body.copyWith(
            color: AppColors.normalGrey,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 24.h),

        /// Icon / Illustration 
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

        SizedBox(height: 28.h),

        /// Button
        SizedBox(
            width: double.infinity,
            child: CustomButton(
              text: "إعداد الحساب",
              onTap: onSetupPressed,
              noShadow: true,
              isLoading: isLoading,
            )
      
            ),

        SizedBox(height: 10.h),
      ],
    );
  }
}
