import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/widgets/custom_app_bar.dart';
import 'package:freelancing_platform/views/home_section/home_controller/notifications_controller.dart';
import 'package:get/get.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationsController>();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: CustomAppBar(
        title: "الإشعارات",
        backgroundGradient: AppColors.gradientColor,
      ),
      body: Obx(
        () => RefreshIndicator(
          onRefresh: () async {},
          color: AppColors.vividPurple,
          child: ListView.separated(
            padding: EdgeInsets.all(AppSpaces.paddingSmall),
            itemCount: controller.notifications.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: AppSpaces.mediumVerticalSpacing),
            itemBuilder: (context, index) {
              final item = controller.notifications[index];
              return GestureDetector(
                onTap: () => controller.markAsRead(index),
                child: _NotificationCard(
                  icon: item.icon,
                  iconColor: item.iconColor,
                  title: item.title,
                  subtitle: item.subtitle,
                  time: item.time,
                  isRead: item.isRead,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String time;
  final bool isRead;

  const _NotificationCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.isRead,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isRead ? AppColors.veryLightGrey : AppColors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: AppColors.oblack,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: iconColor,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.grey,
                      height: 1.5,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    time,
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      if (!isRead)
        Positioned(
          top: 8,
          left: 8,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.veryLightPurple,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              "NEW",
              style: TextStyle(
                color: AppColors.vividPurple,
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      // Positioned(
      //   top: 10,
      //   left: 10,
      //   child: Container(
      //     width: 10,
      //     height: 10,
      //     decoration: const BoxDecoration(
      //       color: Colors.red,
      //       shape: BoxShape.circle,
      //     ),
      //   ),
      // ),
    ]);
  }
}
