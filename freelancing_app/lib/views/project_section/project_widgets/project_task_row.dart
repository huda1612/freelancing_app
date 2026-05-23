import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_input_styles.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';
import 'package:freelancing_platform/models/project_collections/task_model.dart';

class ProjectTaskRow extends StatelessWidget {
  const ProjectTaskRow(
      {super.key,
      required this.task,
      required this.orderNumber,
      required this.controller,
      required this.canEdit,
      required this.onDescriptionChanged,
      required this.onDoneChanged,
      required this.isEditing});

  final TaskModel task;
  final int orderNumber;
  final TextEditingController? controller; //i add ?
  final bool canEdit;
  final bool isEditing;
  final ValueChanged<String> onDescriptionChanged;
  final ValueChanged<bool?> onDoneChanged;

  @override
  Widget build(BuildContext context) {
    // isEditing = canEdit ? isEditing : isEditing;
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Checkbox(
            value: task.isDone,
            activeColor: AppColors.vividPurple,
            onChanged: canEdit ? onDoneChanged : null,
          ),
          Text(
            "$orderNumber -",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15.sp,
              color: AppColors.purple,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
              child: isEditing
                  ? TextFormField(
                      controller: controller,
                      readOnly: !canEdit,
                      onChanged: canEdit ? onDescriptionChanged : null,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(fontSize: 14.sp),
                      decoration: unifiedDecoration('وصف المهمة').copyWith(
                        fillColor: Colors.grey.shade50,
                      ),
                    )
                  : Text(
                      task.description,
                      style:
                          AppTextStyles.body.copyWith(color: AppColors.black),
                    )),
        ],
      ),
    );
  }
}
