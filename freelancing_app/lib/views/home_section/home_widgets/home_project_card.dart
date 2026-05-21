

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';
import 'package:freelancing_platform/models/project_collections/project_model.dart';
import 'package:freelancing_platform/views/home_section/home_widgets/home_info_row.dart';

class HomeProjectCard extends StatelessWidget {
  final ProjectModel project;
  final bool showAcceptanceRate;
  final VoidCallback onTap;

 const HomeProjectCard({super.key, 
    required this.project,
    required this.showAcceptanceRate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppSpaces.paddingMedium),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSpaces.radiusMedium),
          boxShadow: const [
            BoxShadow(color: AppColors.oblack, blurRadius: 8, offset: Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              project.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.blacksubheading.copyWith(
                fontSize: 16.sp,
                color: AppColors.darkPurple,
              ),
            ),
            SizedBox(height: AppSpaces.heightSmall),
            HomeInfoRow(
              icon: Icons.schedule_outlined,
              label: 'المدة',
              value: '${project.durationDays} يوم',
            ),
            SizedBox(height: 4.h),
            HomeInfoRow(
              icon: Icons.attach_money,
              label: 'الميزانية',
              value: '${project.budget.toStringAsFixed(0)} \$',
            ),
            if (showAcceptanceRate) ...[
              SizedBox(height: 4.h),
              HomeInfoRow(
                icon: Icons.trending_up,
                label: 'نسبة القبول',
                value: '${(70 + (project.budget / 100)).toStringAsFixed(0)}%',
              ),
            ],
          ],
        ),
      ),
    );
  }
}