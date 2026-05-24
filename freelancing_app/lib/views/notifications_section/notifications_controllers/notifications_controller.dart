import 'dart:async';
import 'package:freelancing_platform/core/classes/route_handler.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/classes/user_session.dart';
import 'package:freelancing_platform/core/widgets/custom_snackbar.dart';
import 'package:freelancing_platform/data/services/user_notification_service.dart';
import 'package:freelancing_platform/models/user_collections/notification_model.dart';
import 'package:get/get.dart';

class NotificationsController extends GetxController {
  final notifications = <NotificationModel>[].obs;
  final pageState = StatusClasses.isloading.obs;
  final UserNotificationService _userNotificationService =
      UserNotificationService();

  final isSelectionMode = false.obs;
  final selectedIds = <String>{}.obs;
  final isDeleting = false.obs;

  // final RxList<String> selectedIds = <String>[].obs;
  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    pageState.value = StatusClasses.isloading;
    if (UserSession.uid == null) {
      pageState.value = StatusClasses.unauthorized;
      return;
    }
    final res = await _userNotificationService.getUserNotifications(
        uId: UserSession.uid!);
    res.fold((e) => pageState.value = e, (list) {
      notifications.value = list;
      pageState.value = StatusClasses.success;
    });
  }

  Future<void> onNotificationClick(int index) async {
    final noti = notifications[index];
    if (notifications[index].isRead == false) {
      markAsRead(index);
      final notiId = noti.id ?? noti.data?["notificationId"];
      if (UserSession.uid == null || notiId == null) return;
      unawaited(_userNotificationService.updateIsReade(
          uId: UserSession.uid!, notificationId: notiId));
    }

    if (noti.data != null) {
      await RouteHandler.notificationRouteHandler(noti.data!);
    }
  }

  // void onTap(String id) {
  //   if (isSelectionMode.value) {
  //     toggleSelect(id);
  //   } else {
  //     onNotificationClick(id);
  //   }
  // }
  void onLongPress(String? id) {
    isSelectionMode.value = true;
    if (id != null && !selectedIds.contains(id)) {
      selectedIds.add(id);
      // selectedIds.refresh();
    }
  }

  void clearSelection() {
    isSelectionMode.value = false;
    selectedIds.clear();
  }

  // void selectAll() {
  //   selectedIds.addAll(notifications
  //       .where((n) => !selectedIds.contains(n.id))
  //       .map((n) => n.id ?? ''));
  // }
  void selectAll() {
    selectedIds.addAll(
      notifications.map((n) => n.id).whereType<String>(),
    );
  }

  Future<void> deleteSelected() async {
    isDeleting.value = true;
    final ids = selectedIds.toList();
    final res = await _userNotificationService.deleteNotificationsBatch(
      uId: UserSession.uid!,
      notificationIds: ids,
    );

    if (res == StatusClasses.success) {
      notifications.removeWhere((n) => ids.contains(n.id));
      selectedIds.clear();
      isSelectionMode.value = false;
      // isDeleting.value = false;
      customSnackbar(message: "تم الحذف بنجاح");
    } else {
      customSnackbar(message: "فشل حذف الإشعارات :${res.message}");
      // isDeleting.value = false;
    }
    isDeleting.value = false;
  }

  void toggleSelect(String? id) {
    if (id == null) return;
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
    // selectedIds.refresh();
    if (selectedIds.isEmpty) {
      isSelectionMode.value = false;
    }
  }

  bool isSelected(String? id) {
    if (id == null) return false;
    return isSelectionMode.value && selectedIds.contains(id);
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
