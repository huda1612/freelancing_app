import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';

class StatusContainer extends StatelessWidget {
  const StatusContainer(
      {super.key,
      required this.bgColor,
      required this.text,
      required this.textColor});
  final Color bgColor;
  final String text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpaces.paddingSmall - 3,
        vertical: AppSpaces.paddingSmall - 6,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSpaces.radiusSmall),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}
