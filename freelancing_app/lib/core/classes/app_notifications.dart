import 'package:freelancing_platform/core/constants/app_notification_types.dart';

class AppNotification {
  final String title;
  final String body;
  final Map<String, dynamic>? data;

  AppNotification({
    required this.title,
    required this.body,
    required this.data,
  });

  /// إشعار رسالة جديدة
  factory AppNotification.newMessage({
    required String senderId,
    required String senderName,
    // required String message,
    required String chatId,
  }) {
    return AppNotification(
      title: "يوجد لديك رسالة جديدة",
      body: "رسالة من المستخدم $senderName",
      data: {
        "type": AppNotificationTypes.newMessage,
        "senderId": senderId,
        "chatId": chatId,
      },
    );
  }

  /// إشعار رفض طلب
  factory AppNotification.requestRejected({
    required String rejectComment,
  }) {
    return AppNotification(
      title: "لقد تم رفض طلبك",
      body: "سبب الرفض : $rejectComment",
      data: {
        "type": AppNotificationTypes.userRequest,
      },
    );
  }

  /// إشعار قبول طلب
  factory AppNotification.requestAccepted() {
    return AppNotification(
      title: "لقد تم قبول طلبك",
      body: "مرحبا بك في المنصة !",
      data: {
        "type": AppNotificationTypes.userRequest,
      },
    );
  }

  ///اشعار ارسال عرض جديد لمشروع
  factory AppNotification.newOfferSubmit(
      String projectTitle, String projectId) {
    return AppNotification(
      title: "لديك عرض جديد",
      body: "لديك عرض جديد على مشروعك $projectTitle",
      data: {"type": AppNotificationTypes.newOffer, "id": projectId},
    );
  }

  ///اشعار قبول عرض على مشروع
  factory AppNotification.offerAccepted(String projectTitle, String projectId) {
    return AppNotification(
      title: "لقد تم قبول عرضك",
      body: "قام صاحب المشروع بقبول عرضك على المشروع $projectTitle",
      data: {"type": AppNotificationTypes.offerAccepted, "id": projectId},
    );
  }

  ///اشعار رفض عرض على مشروع
  factory AppNotification.offerRejected(String projectTitle, String projectId) {
    return AppNotification(
      title: "لقد تم رفض عرضك",
      body: "للاسف ! لقد قام صاحب المشروع برفض عرضك على مشروع $projectTitle",
      data: {"type": AppNotificationTypes.offerRejected, "id": projectId},
    );
  }

  /// إشعار دفعة مالية
  // factory AppNotification.paymentReceived({
  //   required String id,
  //   required double amount,
  //   required String transactionId,
  // }) {
  //   return AppNotification(
  //     id: id,
  //     type: NotificationType.paymentReceived,
  //     createdAt: DateTime.now(),
  //     data: {
  //       "amount": amount,
  //       "transactionId": transactionId,
  //     },
  //   );
  // }

  /// إشعار عرض جديد
  // factory AppNotification.offerReceived({
  //   required String id,
  //   required String freelancerName,
  //   required double price,
  // }) {
  //   return AppNotification(
  //     id: id,
  //     type: NotificationType.offerReceived,
  //     createdAt: DateTime.now(),
  //     data: {
  //       "freelancerName": freelancerName,
  //       "price": price,
  //     },
  //   );
  // }

  /// إشعار عام من النظام
  // factory AppNotification.systemAlert({
  //   required String id,
  //   required String title,
  //   required String body,
  // }) {
  //   return AppNotification(
  //     id: id,
  //     type: NotificationType.systemAlert,
  //     createdAt: DateTime.now(),
  //     data: {
  //       "title": title,
  //       "body": body,
  //     },
  //   );
  // }
}
