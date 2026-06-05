import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/classes/app_date_formatter.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_notification_types.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/widgets/custom_app_bar.dart';
import 'package:freelancing_platform/core/widgets/custom_refreshable_empty_message.dart';
import 'package:freelancing_platform/core/widgets/get_rerponse_handler.dart';
import 'package:freelancing_platform/views/notifications_section/notifications_controllers/notifications_controller.dart';
import 'package:freelancing_platform/views/notifications_section/notifications_widgets/notification_card.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

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
        trailingIcon: Obx(() =>
            controller.isSelectionMode.value && !controller.isDeleting.value
                ? Row(
                    children: [
                      IconButton(
                        onPressed: controller.selectAll,
                        icon: const Icon(Icons.library_add_check),
                      ),
                      IconButton(
                        onPressed: controller.deleteSelected,
                        icon: const Icon(Icons.delete),
                      ),
                      IconButton(
                        onPressed: controller.clearSelection,
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  )
                : SizedBox.shrink()),
      ),
      body: Obx(
        // init: Get.find<NotificationsController>(),
        () => ModalProgressHUD(
          inAsyncCall: controller.isDeleting.value,
          child: RefreshIndicator(
              onRefresh: controller.loadNotifications,
              color: AppColors.vividPurple,
              child: UiStateHandler(
                  status: controller.pageState.value,
                  fetchDataFun: controller.loadNotifications,
                  child: controller.notifications.isNotEmpty
                      ? ListView.separated(
                          padding: EdgeInsets.all(AppSpaces.paddingSmall),
                          itemCount: controller.notifications.length,
                          separatorBuilder: (_, __) => const SizedBox(
                              height: AppSpaces.mediumVerticalSpacing),
                          itemBuilder: (context, index) {
                            final notification =
                                controller.notifications[index];
                            final String? type = notification.data?["type"];
                            final iconAndColor = _mapType(type);
                            // final isSelectionMode = controller.isSelectionMode.value;
                            return Obx(() {
                              final isSelectionMode =
                                  controller.isSelectionMode.value;
                              return GestureDetector(
                                  onLongPress: () =>
                                      controller.onLongPress(notification.id),
                                  onTap: () => isSelectionMode
                                      ? controller.toggleSelect(notification.id)
                                      : controller.onNotificationClick(index),
                                  child: NotificationCard(
                                    icon: iconAndColor.icon,
                                    iconColor: iconAndColor.color,
                                    title: notification.title,
                                    subtitle: notification.body,
                                    time: AppDateFormatter.smartTime(
                                        notification.createdAt),
                                    isRead: notification.isRead,
                                    isSelected:
                                        controller.isSelected(notification.id),
                                  ));
                            });
                          },
                        )
                      : CustomRefreshableEmptyMessage(
                          onRefresh: controller.loadNotifications,
                          emptyMessage: "لا يوجد اشعارات"))),
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
    case AppNotificationTypes.approveTasks:
      return IconAndColor(icon: Icons.check_circle, color: AppColors.green);

    case AppNotificationTypes.offerRejected:
    case AppNotificationTypes.rejectTasks:
      return IconAndColor(icon: Icons.highlight_off, color: AppColors.red);

    case AppNotificationTypes.newOffer:
      return IconAndColor(
          icon: Icons.person_add_alt_1_rounded, color: Colors.indigo);

    case AppNotificationTypes.newMessage:
      return IconAndColor(icon: Icons.message, color: Colors.orange);

    case AppNotificationTypes.hireMe:
      return IconAndColor(icon: Icons.work, color: AppColors.vividPurple);
    case AppNotificationTypes.sendTasks:
      return IconAndColor(
          icon: Icons.edit_document, color: AppColors.lightBlue);
    case AppNotificationTypes.endTask:
    case AppNotificationTypes.approveTask:
      return IconAndColor(icon: Icons.check_box, color: AppColors.green);
    case AppNotificationTypes.rejectTask:
      return IconAndColor(
          icon: Icons.indeterminate_check_box_rounded, color: AppColors.red);

    case AppNotificationTypes.requestExtraTask:
      return IconAndColor(
          icon: Icons.plus_one_rounded, color: AppColors.vividPurple);
    case AppNotificationTypes.cancelRequestExtraTask:
    case AppNotificationTypes.rejectRequestedExtraTask:
      return IconAndColor(
          icon: Icons.exposure_minus_1_rounded, color: AppColors.red);

    case AppNotificationTypes.approveRequestExtraTask:
      return IconAndColor(icon: Icons.plus_one_rounded, color: AppColors.green);

    case AppNotificationTypes.completeProject:
      return IconAndColor(icon: Icons.verified, color: AppColors.green);
    case AppNotificationTypes.cancelProject:
      return IconAndColor(icon: Icons.cancel, color: AppColors.red);
    case AppNotificationTypes.newRating:
      return IconAndColor(icon: Icons.star, color: Colors.orange);
    default:
      return IconAndColor(
          icon: Icons.new_releases_rounded, color: Colors.purple);
  }
}
