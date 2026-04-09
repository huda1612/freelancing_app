import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GenderField extends StatelessWidget {
  final String? value;
  final Function(String?) onChanged;
  final String label;

  const GenderField({
    super.key,
    required this.value,
    required this.onChanged,
    this.label = "الجنس",
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      // initialValue: value,
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      ),
      items: const [
        DropdownMenuItem(value: "male", child: Text("ذكر")),
        DropdownMenuItem(value: "female", child: Text("أنثى")),
      ],
      onChanged: onChanged,
      validator: (v) => v == null ? "هذا الحقل مطلوب" : null,
    );
  }
}
