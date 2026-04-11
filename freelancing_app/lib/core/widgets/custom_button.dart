import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';

enum ButtonType { filled, outlined }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final double? width;
  final double height;
  final EdgeInsetsGeometry? padding;
  final Color color;
  final TextStyle? textStyle;
  final BorderRadiusGeometry? borderRadius;
  final ButtonType buttonType;
  final Widget? prefix;

  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.width = 396, // ← رقم التصميم
    this.height = 52, // ← رقم التصميم
    this.padding,
    this.color = AppColors.vividPurple,
    this.textStyle,
    this.borderRadius,
    this.buttonType = ButtonType.filled,
    this.prefix,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width != null ? width!.w : double.infinity,
        height: height.h,
        padding: padding ??
            EdgeInsets.symmetric(
              vertical: AppSpaces.smallVerticalSpacing.h,
              //14.h,
              horizontal: AppSpaces.smallHorizontalPadding.w,
            ),
        decoration: BoxDecoration(
          color: buttonType == ButtonType.filled ? color : AppColors.white,
          borderRadius:
              borderRadius ?? BorderRadius.circular(AppSpaces.radiusMedium),
          border: buttonType == ButtonType.outlined
              ? Border.all(color: color, width: 1.5.w)
              : null,

           boxShadow: [
      BoxShadow(
        color: AppColors.ovividPurple,
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
        ),
        alignment: Alignment.center,
        child: prefix == null
            ? Text(
                text,
                style: textStyle ?? AppTextStyles.button,
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  prefix!,
                  SizedBox(width: 10.w),
                  Text(
                    text,
                    style: textStyle ?? AppTextStyles.button,
                  ),
                ],
              ),
      ),
    );
  }
}
