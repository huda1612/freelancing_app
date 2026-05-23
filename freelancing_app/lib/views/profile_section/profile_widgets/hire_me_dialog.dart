import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';
import 'package:freelancing_platform/core/widgets/custom_empty_data_text.dart';
import 'package:freelancing_platform/core/widgets/custom_loading.dart';
import 'package:freelancing_platform/models/project_collections/project_model.dart';
import 'package:get/get.dart';

class HireMeDialog extends StatelessWidget {
  final List<ProjectModel> projects;
  final Function(ProjectModel) onProjectSelected;
  final VoidCallback onNoProjects;

  const HireMeDialog({
    super.key,
    required this.projects,
    required this.onProjectSelected,
    required this.onNoProjects,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: EdgeInsets.all(20.w),
        constraints: BoxConstraints(
          maxHeight: 500.h,
          minWidth: 300.w,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'اختر مشروعاً للتوظيف',
                  style: AppTextStyles.subheading.copyWith(
                    color: AppColors.darkPurple,
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
            SizedBox(height: 16.h),
            
            // Projects List
            Expanded(
              child: projects.isEmpty
                  ? Center(
                      child: customEmptyMessage(
                        message: 'لا توجد مشاريع جديدة متاحة',
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      itemCount: projects.length,
                      separatorBuilder: (_, __) => SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        final project = projects[index];
                        return _ProjectCard(
                          project: project,
                          onTap: () => onProjectSelected(project),
                        );
                      },
                    ),
            ),
            
            SizedBox(height: 16.h),
            
            // Cancel Button
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  'إلغاء',
                  style: AppTextStyles.button.copyWith(
                    color: AppColors.darkGrey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final ProjectModel project;
  final VoidCallback onTap;

  const _ProjectCard({
    required this.project,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.owhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.lightPurple.withOpacity(0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              project.title,
              style: AppTextStyles.body.copyWith(
                color: AppColors.black,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8.h),
            Text(
              project.description,
              style: AppTextStyles.link.copyWith(
                color: AppColors.darkGrey,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Icon(
                  Icons.attach_money,
                  size: 16,
                  color: AppColors.vividPurple,
                ),
                SizedBox(width: 4.w),
                Text(
                  '\$${project.budget.toStringAsFixed(0)}',
                  style: AppTextStyles.link.copyWith(
                    color: AppColors.vividPurple,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 16.w),
                Icon(
                  Icons.schedule,
                  size: 16,
                  color: AppColors.vividPurple,
                ),
                SizedBox(width: 4.w),
                Text(
                  '${project.durationDays} يوم',
                  style: AppTextStyles.link.copyWith(
                    color: AppColors.vividPurple,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
