import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';
import 'package:freelancing_platform/core/services/navigation_service.dart';
import 'package:freelancing_platform/views/auth_section/auth_controller/sign_out_controller.dart';
import 'package:freelancing_platform/views/profile_section/profile_controllers/profile_controller.dart';
import 'package:get/get.dart';

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({
    super.key,
    required this.controller,
    required this.singoutController,
  });

  final ProfileController controller;
  final SignOutController singoutController;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(children: [
              Container(
                width: double.infinity,
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
                      style:
                          AppTextStyles.link.copyWith(color: AppColors.white),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 8.h,
                left: 8.w,
                child: IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.white,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ]),
            if ((controller.isClient || controller.isFreelancer) &&
                controller.isOwnProfile)
              _drawerTile(
                  icon: Icons.folder_outlined,
                  title: 'مشاريعي',
                  onTap: () {
                    NavigationService.toNamed(AppRoutes.myProjects);
                  }),
            if (controller.isFreelancer && controller.isOwnProfile)
              _drawerTile(
                  icon: Icons.description_outlined,
                  title: 'عروضي',
                  onTap: () {
                    NavigationService.toNamed(AppRoutes.freelancerOffers);
                  }),
            const Spacer(),
            Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  !controller.notificationsPermissioned.value
                      ? Text(
                          "  تنبيه : الرجاء السماح بالاشعارات من الاعدادات اولا",
                          style: AppTextStyles.link
                              .copyWith(color: AppColors.normalGrey))
                      : SizedBox.shrink(),
                  SwitchListTile(
                    secondary: Icon(
                      Icons.notifications_outlined,
                      color: controller.notificationsPermissioned.value
                          ? AppColors.vividPurple
                          : AppColors.normalGrey,
                    ),
                    title: Text(
                      'الإشعارات',
                      style: AppTextStyles.body.copyWith(
                        color: controller.notificationsPermissioned.value
                            ? AppColors.black
                            : AppColors.normalGrey,
                      ),
                    ),
                    value: controller.notificationsEnabled.value,
                    onChanged: controller.notificationsPermissioned.value
                        ? controller.toggleNotifications
                        : null,
                    activeThumbColor: AppColors.vividPurple,
                  ),
                ],
              ),
            ),
            _drawerTile(
              icon: Icons.output_rounded,
              onTap: singoutController.signOut,
              title: "تسجيل الخروج",
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color iconColor = AppColors.vividPurple,
    Color textColor = AppColors.black,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor,
      ),
      title: Text(
        title,
        style: AppTextStyles.body.copyWith(
          color: textColor,
        ),
      ),
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(14.r),
      // ),
      onTap: onTap,
    );
  }
}
