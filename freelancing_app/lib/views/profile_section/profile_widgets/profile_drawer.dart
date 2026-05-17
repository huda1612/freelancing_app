import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';
import 'package:freelancing_platform/core/services/navigation_service.dart';
import 'package:freelancing_platform/views/profile_section/profile_controllers/profile_controller.dart';

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({
    super.key,
    required this.controller,
  });

  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                gradient: AppColors.gradientColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.fullName,
                    style: AppTextStyles.subheading.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '@${controller.username}',
                    style: AppTextStyles.link.copyWith(color: AppColors.white),
                  ),
                ],
              ),
            ),
            if ((controller.isClient || controller.isFreelancer) &&
                controller.isOwnProfile)
              ListTile(
                leading: const Icon(Icons.folder_outlined,
                    color: AppColors.vividPurple),
                title: Text(
                  'مشاريعي',
                  style: AppTextStyles.body.copyWith(color: AppColors.black),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  NavigationService.toNamed(AppRoutes.myProjects);
                },
              ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.close, color: AppColors.grey),
              title: Text(
                'إغلاق',
                style: AppTextStyles.link.copyWith(color: AppColors.darkGrey),
              ),
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
