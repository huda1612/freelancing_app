import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? leadingIcon;
  final VoidCallback? onLeadingPressed;
  final Widget? trailingIcon;
  final VoidCallback? onTrailingPressed;
  final Color? backgroundColor;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    this.title,
    this.leadingIcon,
    this.onLeadingPressed,
    this.trailingIcon,
    this.onTrailingPressed,
    this.backgroundColor,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: title != null
          ? Text(
              title!,
              style: AppTextStyles.subheading.copyWith(color: AppColors.black,)
            )
          : null,
      leading: leadingIcon != null
          ? IconButton(
              onPressed: onLeadingPressed ?? () {},
              icon: leadingIcon!,
              iconSize: 22.w,
            )
          : null,
      actions: trailingIcon != null
          ? [
              IconButton(
                onPressed: onTrailingPressed ?? () {},
                icon: trailingIcon!,
                iconSize: 22.w,
              ),
            ]
          : [],
      bottom: bottom,
    );
  }

  // @override
  // Size get preferredSize => Size.fromHeight(56.h);
  @override
  Size get preferredSize {
    double bottomHeight = bottom?.preferredSize.height ?? 0;
    return Size.fromHeight(56.h + bottomHeight);
  }
}
