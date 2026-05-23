import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/classes/app_date_formatter.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_notification_types.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/widgets/custom_app_bar.dart';
import 'package:freelancing_platform/core/widgets/get_rerponse_handler.dart';
import 'package:freelancing_platform/views/notifications_section/notifications_controllers/notifications_controller.dart';
import 'package:freelancing_platform/views/notifications_section/notifications_widgets/notification_card.dart';
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
        // init: Get.find<NotificationsController>(),
        () => RefreshIndicator(
          onRefresh: controller.loadNotifications,
          color: AppColors.vividPurple,
          child: UiStateHandler(
            status: controller.pageState.value,
            fetchDataFun: controller.loadNotifications,
            child: ListView.separated(
              padding: EdgeInsets.all(AppSpaces.paddingSmall),
              itemCount: controller.notifications.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpaces.mediumVerticalSpacing),
              itemBuilder: (context, index) {
                final notification = controller.notifications[index];
                final String? type = notification.data?["type"];
                final iconAndColor = _mapType(type);
                return GestureDetector(
                  onLongPress: () => controller.onLongPress(notification.id),
                  // onTap: () => controller.isSelectionMode.value ?controller.toggleSelect(notification.id)  :
                  onTap: () => controller.onNotificationClick(index),
                  child: NotificationCard(
                    icon: iconAndColor.icon,
                    iconColor: iconAndColor.color,
                    title: notification.title,
                    subtitle: notification.body,
                    time: AppDateFormatter.smartTime(notification.createdAt),
                    isRead: notification.isRead,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class IconAndColor {
  final IconData icon;
  final Color color;
  IconAndColor({required this.icon, required this.color});
}

IconAndColor _mapType(String? type) {
  switch (type) {
    case AppNotificationTypes.userRequest:
    case AppNotificationTypes.offerAccepted:
      return IconAndColor(icon: Icons.check_circle, color: AppColors.green);
    case AppNotificationTypes.offerRejected:
      return IconAndColor(icon: Icons.close, color: AppColors.red);
    case AppNotificationTypes.newOffer:
      return IconAndColor(icon: Icons.work, color: Colors.orange);

    case AppNotificationTypes.newMessage:
      return IconAndColor(icon: Icons.message, color: Colors.purple);
    default:
      return IconAndColor(
          icon: Icons.new_releases_rounded, color: Colors.purple);
  }
}
