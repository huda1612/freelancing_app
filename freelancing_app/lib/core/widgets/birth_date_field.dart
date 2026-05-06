import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_input_styles.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';

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
        Text(
          " تاريخ الميلاد",
          style: AppTextStyles.button.copyWith(color: AppColors.black),
        ),
        SizedBox(height: AppSpaces.heightMedium),
        Row(
          children: [
            /// السنة
            SizedBox(
              width: 120.w,
              height: 55.h,
              child: DropdownButtonFormField<String>(
                // initialValue: year,
                initialValue: year,
                decoration: unifiedDecoration("السنة"),

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
            SizedBox(
              width: 120.w,
              height: 55.h,
              child: DropdownButtonFormField<String>(
                //  initialValue: month,
                initialValue: month,
                decoration: unifiedDecoration("الشهر"),

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
            SizedBox(
              width: 120.w,
              height: 55.h,
              child: DropdownButtonFormField<String>(
                // initialValue: day,
                initialValue: day,
                decoration: unifiedDecoration("اليوم"),

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
