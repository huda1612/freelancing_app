import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectedSkillsBox extends StatelessWidget {
  final List<String> skills;
  final Function(String) onRemove;

  /// أقصى ارتفاع للمحتوى (سطرين تقريباً ثم تمرير عمودي).
  final double maxContentHeight;

  const SelectedSkillsBox({
    super.key,
    required this.skills,
    required this.onRemove,
    this.maxContentHeight = 80,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
          ),
        ],
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxContentHeight.h),
        child: SingleChildScrollView(
          child: Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            alignment: WrapAlignment.end,
            textDirection: Directionality.of(context),
            children: skills.map((skill) {
              return Chip(
                label: Text(skill),
                deleteIcon: const Icon(Icons.close, size: 18),
                onDeleted: () => onRemove(skill),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
