import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';
import 'package:freelancing_platform/core/widgets/custom_bottom_sheet_container.dart';
import 'package:freelancing_platform/core/widgets/custom_button.dart';

class PaymentAccountReadyBottomSheet extends StatelessWidget {
  final VoidCallback onOpenStripePressed;
  final bool isLoading;

  const PaymentAccountReadyBottomSheet(
      {super.key, required this.onOpenStripePressed, this.isLoading = false});

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
            Icons.payments_outlined,
            size: 42.sp,
            color: AppColors.vividPurple,
          ),
        ),
        SizedBox(height: AppSpaces.heightMedium),
        Text(
          'إعدادات الدفع',
          textAlign: TextAlign.center,
          style: AppTextStyles.blacksubheading,
        ),
        SizedBox(height: AppSpaces.heightLarge),
        Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 22.sp,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                'حساب الدفع مفعل وجاهز لاستلام الدفعات.',
                style: AppTextStyles.body.copyWith(color: AppColors.green),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpaces.heightMedium),
        Text(
          'يمكنك إدارة بيانات الحساب البنكي ومراجعة عمليات الدفع من خلال لوحة Stripe.',
          textAlign: TextAlign.center,
          style: AppTextStyles.body.copyWith(
            color: AppColors.normalGrey,
          ),
        ),
        SizedBox(height: AppSpaces.heightLarge),
        CustomButton(
          text: 'فتح لوحة التحكم',
          prefix: Icon(
            Icons.open_in_new,
            color: AppColors.white,
          ),
          onTap: onOpenStripePressed,
          noShadow: true,
        ),
      ],
    );
  }
}
