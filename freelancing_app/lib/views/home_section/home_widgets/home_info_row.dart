import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';

class HomeInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const HomeInfoRow({super.key, 
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: AppColors.vividPurple),
        SizedBox(width: 6.w),
        Text(
          '$label: ',
          style: AppTextStyles.link.copyWith(fontSize: 12.sp),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.body.copyWith(
              color: AppColors.darkGrey,
              fontSize: 12.sp,
            ),
          ),
        ),
      ],
    );
  }
}