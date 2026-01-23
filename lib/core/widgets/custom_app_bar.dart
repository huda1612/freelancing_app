import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? leadingIcon; // أيقونة على اليسار
  final VoidCallback? onLeadingPressed;
  final Widget? trailingIcon; // أيقونة على اليمين
  final VoidCallback? onTrailingPressed;

  const CustomAppBar({
    super.key,
    this.title,
    this.leadingIcon,
    this.onLeadingPressed,
    this.trailingIcon,
    this.onTrailingPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          backgroundColor: AppColors.veryLightGrey,
          elevation: 0,
          centerTitle: true,
          title: title != null
              ? Text(
                  title!,
                  style: AppTextStyles.inputLabel,
                )
              : null,

          // أيقونة يسار
          leading: leadingIcon != null
              ? IconButton(
                  onPressed: onLeadingPressed ?? () {},
                  icon: leadingIcon!,
                  iconSize: 22.w, // حجم الأيقونة متجاوب
                )
              : null,
          // أيقونة يمين
          actions: trailingIcon != null
              ? [
                  IconButton(
                    onPressed: onTrailingPressed ?? () {},
                    icon: trailingIcon!,
                    iconSize: 22.w, // حجم الأيقونة متجاوب
                  ),
                ]
              : [],
        ),
        Container(
          height: 1.h, // ارتفاع الخط الفاصل متجاوب
          width: double.infinity,
          color: Colors.grey.shade300,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60.h); // ارتفاع متجاوب
}
