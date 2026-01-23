import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatefulWidget {
  final String? hintText;
  final TextEditingController? controller;
  final bool obscureText; // لإخفاء النص
  final Widget? prefixIcon; // أيقونة بداية الحقل
  final Widget? suffixIcon; // أيقونة نهاية الحقل
  final TextInputType? keyboardType;
  final String? Function(String?)? validator; // للتحقق من المدخلات
  final double? width;
  final double? height;
  final Function(String)? onChanged;


  const CustomTextField({
    super.key,
    this.hintText,
    this.controller,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
    this.width = 380,
    this.height = 48,
    this.onChanged,

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
    final bool isCommentField = widget.height == 107;

    final Widget? suffixIcon = widget.obscureText
        ? IconButton(
            icon: Icon(
              _obscure ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey.shade600,
              size: 20,
            ),
            onPressed: _toggleVisibility,
          )
        : widget.suffixIcon;

    TextDirection textDirection =
        Localizations.localeOf(context).languageCode == 'ar'
            ? TextDirection.rtl
            : TextDirection.ltr;

    return SizedBox(
      width: widget.width!.w,
      height: widget.height!.h,
      child: TextFormField(
        controller: widget.controller,
        obscureText: _obscure,
        keyboardType: widget.keyboardType,
        validator: widget.validator,
        onChanged: widget.onChanged,

        maxLines: isCommentField ? 5 : 1,
        minLines: isCommentField ? 3 : 1,
        style: TextStyle(
          fontSize: 14.sp,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
        textDirection: textDirection,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey.shade500,
          ),
          filled: true,
          fillColor: Colors.grey.shade200,
          prefixIcon: widget.prefixIcon,
          suffixIcon: suffixIcon,
          contentPadding:
              EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(color: Colors.blue, width: 1.5),
          ),
        ),
      ),
    );
  }
}
