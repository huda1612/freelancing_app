import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_input_styles.dart';

class CustomTextField extends StatefulWidget {
  final String? initialValue;
  final String? hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final double? width;
  // final double? height;
  final Function(String)? onChanged;
  final Color? fillColor;
  final BorderRadius? borderRadius;
  final TextInputAction? textInputAction;
  final String? prefixText;
  final TextStyle? prefixStyle;
  final bool readOnly;
  final bool enabled;
  final bool? filled;

  const CustomTextField({
    super.key,
    this.initialValue,
    this.hintText,
    this.controller,
    this.obscureText = false,
    this.prefixIcon,
    this.prefixText,
    this.prefixStyle,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
    this.width = 380,
    // this.height = 48,
    this.onChanged,
    this.fillColor,
    this.borderRadius,
    this.textInputAction,
    this.readOnly = false,
    this.enabled = true,
    this.filled,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  void _toggleVisibility() {
    setState(() {
      _obscure = !_obscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isMultiline = widget.keyboardType == TextInputType.multiline;
    final Widget? suffixIcon = widget.obscureText
        ? IconButton(
            icon: Icon(
              _obscure ? Icons.visibility_off : Icons.visibility,
              color: AppColors.vividPurple,
              size: 20.w,
            ),
            onPressed: _toggleVisibility,
          )
        : widget.suffixIcon;

    return SizedBox(
      width: widget.width!.w,
      // height: widget.height!.h,
      child: TextFormField(
        initialValue: widget.initialValue,
        controller: widget.controller,
        obscureText: _obscure,
        keyboardType: widget.keyboardType,
        validator: widget.validator,
        readOnly: widget.readOnly,
        enabled: widget.enabled,
        onChanged: widget.onChanged,
        maxLines: isMultiline ? null : 1,
        minLines: isMultiline ? 3 : 1,
        style: TextStyle(
          fontSize: 14.sp,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
        textDirection: TextDirection.rtl,
        decoration: unifiedDecoration(widget.hintText ?? "").copyWith(
          suffixIcon: suffixIcon,
          prefixIcon: widget.prefixIcon,
          prefixText: widget.prefixText,
          prefixStyle: widget.prefixStyle ??
              TextStyle(
                  fontSize: 15.sp,
                  color: AppColors.vividPurple,
                  fontWeight: FontWeight.w700),
          filled: widget.filled,
          fillColor: widget.fillColor,
          enabledBorder: widget.readOnly
              ? OutlineInputBorder(
                  borderRadius:
                      widget.borderRadius ?? BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: Colors.transparent),
                )
              : null,
          focusedBorder: widget.readOnly
              ? OutlineInputBorder(
                  borderRadius:
                      widget.borderRadius ?? BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: Colors.transparent),
                )
              : null,
        ),
        textInputAction: widget.textInputAction,
      ),
    );
  }
}
