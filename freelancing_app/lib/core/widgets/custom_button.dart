import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';

enum ButtonType { filled, outlined }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final double? width; // لو null، يمتد ليملأ المساحة المتاحة
  final double height;
  final EdgeInsetsGeometry padding;
  final Color color;                // اللون الأساسي للزر
  final TextStyle? textStyle;
final BorderRadiusGeometry? borderRadius;
  final ButtonType buttonType;

  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.width=396,
    this.height = 52,
    this.padding = const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    this.color = AppColors.vividPurple,       // اللون الافتراضي
    this.textStyle,
this.borderRadius,

    this.buttonType = ButtonType.filled,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width != null ? width!.w : double.infinity,
        height: height.h,
        padding: padding,
        decoration: BoxDecoration(
          color: buttonType == ButtonType.filled ? color : Colors.white,
          borderRadius:  borderRadius ??
    BorderRadius.all(
      Radius.circular(AppSpaces.radiusMedium),
    ),

          border: buttonType == ButtonType.outlined
              ? Border.all(color: color, width: 1.5.w)
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: textStyle ??
               AppTextStyles.button
        ),
      ),
    );
  }
}
