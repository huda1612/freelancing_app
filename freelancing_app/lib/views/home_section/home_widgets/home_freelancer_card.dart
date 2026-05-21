import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';
import 'package:freelancing_platform/models/user_collections/user_model.dart';

class HomeFreelancerCard extends StatelessWidget {
  final UserModel freelancer;
  final bool showStats;
  final VoidCallback onTap;

  const HomeFreelancerCard({super.key, 
    required this.freelancer,
    required this.showStats,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final name = '${freelancer.fname} ${freelancer.lname}'.trim();
    final displayName = name.isEmpty ? freelancer.username : name;
    final specialization = freelancer.specialization?.name.isNotEmpty == true
        ? freelancer.specialization?.name
        : (freelancer.jobTitle.isNotEmpty ? freelancer.jobTitle : 'اختصاص غير محدد');

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
        child: Row(
          children: [
            const CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.veryLightPurple,
              child: Icon(Icons.person, color: AppColors.vividPurple),
            ),
            SizedBox(width: AppSpaces.width),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: AppTextStyles.blacksubheading.copyWith(
                      fontSize: 16.sp,
                      color: AppColors.darkPurple,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    specialization ?? 'اختصاص غير محدد',
                    style: AppTextStyles.link.copyWith(
                      color: AppColors.darkGrey,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
            if (showStats) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      SizedBox(width: 4.w),
                      Text(
                        freelancer.rating.toStringAsFixed(1),
                        style: AppTextStyles.link.copyWith(
                          color: AppColors.darkGrey,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${freelancer.completedProjects} مشروع',
                    style: AppTextStyles.link.copyWith(
                      color: AppColors.darkGrey,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
