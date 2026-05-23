import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:get/get.dart';

class NotificationItem {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String time;
  final bool isRead;

  const NotificationItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.time,
    this.isRead = false,
  });

  NotificationItem copyWith({
    IconData? icon,
    Color? iconColor,
    String? title,
    String? subtitle,
    String? time,
    bool? isRead,
  }) {
    return NotificationItem(
      icon: icon ?? this.icon,
      iconColor: iconColor ?? this.iconColor,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      time: time ?? this.time,
      isRead: isRead ?? this.isRead,
    );
  }
}

class NotificationsController extends GetxController {
  final notifications = <NotificationItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  void loadNotifications() {
    notifications.assignAll(const [
      NotificationItem(
        icon: Icons.check_circle,
        iconColor: AppColors.green,
        title: "تم قبول طلبك",
        subtitle: "تمت مراجعة حسابك بنجاح.",
        time: "منذ 5 دقائق",
      ),
      NotificationItem(
        icon: Icons.message,
        iconColor: AppColors.purple,
        title: "رسالة جديدة",
        subtitle: "لديك رسالة من عميل جديد.",
        time: "منذ 10 دقائق",
      ),
      NotificationItem(
        icon: Icons.work,
        iconColor: Colors.orange,
        title: "مشروع جديد",
        subtitle: "تم نشر مشروع يناسب مهاراتك.",
        time: "منذ ساعة",
      ),
      NotificationItem(
        icon: Icons.star,
        iconColor: Colors.amber,
        title: "تقييم جديد",
        subtitle: "حصلت على تقييم 5 نجوم.",
        time: "منذ يوم",
      ),
    ]);
  }

  void markAsRead(int index) {
    if (index < 0 || index >= notifications.length) return;
    final current = notifications[index];
    notifications[index] = current.copyWith(isRead: true);
  }

  void markAllAsRead() {
    notifications.value =
        notifications.map((item) => item.copyWith(isRead: true)).toList();
  }
}
