import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/project_status.dart';
import 'package:freelancing_platform/models/project_collections/project_model.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({
    super.key,
    required this.project,
    this.onTap,
    this.tasksDone,
    this.tasksTotal,
    this.footer,
    this.marginBottom = true,
  });

  final ProjectModel project;
  final VoidCallback? onTap;
  final int? tasksDone;
  final int? tasksTotal;
  final Widget? footer;
  final bool marginBottom;

  bool get _showTaskProgress =>
      project.status == ProjectStatus.inProgress &&
      tasksDone != null &&
      tasksTotal != null;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: marginBottom
          ? EdgeInsets.only(bottom: AppSpaces.heightMedium)
          : EdgeInsets.zero,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpaces.radiusMedium),
        boxShadow: const [
          BoxShadow(
            color: AppColors.oblack,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: EdgeInsets.all(AppSpaces.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.blacksubheading.copyWith(
                        fontSize: 18.sp,
                        color: AppColors.darkPurple,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    _InfoRow(
                      icon: Icons.category_outlined,
                      label: 'التخصص',
                      value: _specializationText,
                    ),
                    SizedBox(height: 8.h),
                    _InfoRow(
                      icon: Icons.attach_money,
                      label: 'الميزانية',
                      value: '${project.budget.toStringAsFixed(0)} \$',
                    ),
                    SizedBox(height: 8.h),
                    _InfoRow(
                      icon: Icons.schedule_outlined,
                      label: 'المدة المطلوبة',
                      value: '${project.durationDays} يوم',
                    ),
                    if (_showTaskProgress) ...[
                      SizedBox(height: 8.h),
                      _InfoRow(
                        icon: Icons.task_alt_outlined,
                        label: 'المهام المنجزة',
                        value: '$tasksDone / $tasksTotal',
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          if (footer != null) ...[
            Divider(height: 1, color: Colors.grey.shade200),
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 12.h),
              child: footer!,
            ),
          ],
        ],
      ),
    );
  }

  String get _specializationText {
    if (project.category.name.trim().isNotEmpty) {
      return project.category.name;
    }
    if (project.skillsRequired.isNotEmpty) {
      return project.skillsRequired.first;
    }
    return 'غير محدد';
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18.sp, color: AppColors.vividPurple),
        SizedBox(width: 8.w),
        Text(
          '$label : ',
          style: AppTextStyles.link.copyWith(fontSize: 14.sp),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body.copyWith(
              color: AppColors.darkGrey,
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }
}
