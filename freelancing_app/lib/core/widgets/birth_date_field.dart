import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BirthDateField extends StatelessWidget {
  final String? year;
  final String? month;
  final String? day;

  final Function(String?) onYearChanged;
  final Function(String?) onMonthChanged;
  final Function(String?) onDayChanged;

  const BirthDateField({
    super.key,
    required this.year,
    required this.month,
    required this.day,
    required this.onYearChanged,
    required this.onMonthChanged,
    required this.onDayChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "تاريخ الميلاد",
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 6.h),

        Row(
          children: [
            /// السنة
            Expanded(
              child: DropdownButtonFormField<String>(
                initialValue: year,
                decoration: const InputDecoration(labelText: "السنة"),
                items: List.generate(
                  60,
                  (i) => DropdownMenuItem(
                    value: (1965 + i).toString(),
                    child: Text((1965 + i).toString()),
                  ),
                ),
                onChanged: onYearChanged,
                validator: (v) => v == null ? "مطلوب" : null,
              ),
            ),
            SizedBox(width: 8.w),

            /// الشهر
            Expanded(
              child: DropdownButtonFormField<String>(
                initialValue: month,
                decoration: const InputDecoration(labelText: "الشهر"),
                items: List.generate(
                  12,
                  (i) => DropdownMenuItem(
                    value: (i + 1).toString(),
                    child: Text((i + 1).toString()),
                  ),
                ),
                onChanged: onMonthChanged,
                validator: (v) => v == null ? "مطلوب" : null,
              ),
            ),
            SizedBox(width: 8.w),

            /// اليوم
            Expanded(
              child: DropdownButtonFormField<String>(
                initialValue: day,
                decoration: const InputDecoration(labelText: "اليوم"),
                items: List.generate(
                  31,
                  (i) => DropdownMenuItem(
                    value: (i + 1).toString(),
                    child: Text((i + 1).toString()),
                  ),
                ),
                onChanged: onDayChanged,
                validator: (v) => v == null ? "مطلوب" : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
