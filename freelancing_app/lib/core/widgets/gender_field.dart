import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_input_styles.dart';

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
    return SizedBox(
        width: 380.w,
        height: 55.h,
        child: DropdownButtonFormField<String>(
            initialValue: value,
          //value: value,
          decoration: unifiedDecoration(label),

          items: const [
            DropdownMenuItem(value: "male", child: Text("ذكر")),
            DropdownMenuItem(value: "female", child: Text("أنثى")),
          ],
          onChanged: onChanged,
          validator: (v) => v == null ? "هذا الحقل مطلوب" : null,
        ));
  }
}
