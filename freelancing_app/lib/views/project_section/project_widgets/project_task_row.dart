import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_input_styles.dart';
import 'package:freelancing_platform/models/project_collections/task_model.dart';

class ProjectTaskRow extends StatelessWidget {
  const ProjectTaskRow({
    super.key,
    required this.task,
    required this.controller,
    required this.canEdit,
    required this.onDescriptionChanged,
    required this.onDoneChanged,
  });

  final TaskModel task;
  final TextEditingController controller;
  final bool canEdit;
  final ValueChanged<String> onDescriptionChanged;
  final ValueChanged<bool?> onDoneChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: task.isDone,
            activeColor: AppColors.vividPurple,
            onChanged: canEdit ? onDoneChanged : null,
          ),
          Padding(
            padding: EdgeInsets.only(top: 12.h),
            child: Text(
              '${task.orderNumber}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
                color: AppColors.purple,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: TextFormField(
              controller: controller,
              readOnly: !canEdit,
              onChanged: canEdit ? onDescriptionChanged : null,
              textDirection: TextDirection.rtl,
              style: TextStyle(fontSize: 14.sp),
              decoration: unifiedDecoration('وصف المهمة').copyWith(
                fillColor: Colors.grey.shade50,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

