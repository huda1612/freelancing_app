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
      String projectTitle, String projectId, String? freelancerFullName) {
    return AppNotification(
      title: "لديك عرض جديد",
      body:
          "لديك عرض جديد على مشروعك $projectTitle ${freelancerFullName != null ? "من $freelancerFullName" : ''}",
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

  ///اشعار وظفني
  factory AppNotification.hireMe(
      {required String projectId, String? projectTitle, String? clientName}) {
    return AppNotification(
      title: "طلب توظيف",
      body:
          "لقد قام صاحب المشروع ${clientName ?? ''} بارسال طلب توظيف لك على مشروعه ${projectTitle ?? ''}",
      data: {"type": AppNotificationTypes.hireMe, "id": projectId},
    );
  }

  ///اشعار ارسال المهام لمشروع الى عميل
  factory AppNotification.sendTasks(
      {required String projectId, String? projectTitle}) {
    return AppNotification(
      title: "لقد تم تحديد مهام المشروع",
      body:
          "لقد قام القائم على المشروع باعداد المهام على مشروع ${projectTitle ?? ''}",
      data: {"type": AppNotificationTypes.sendTasks, "id": projectId},
    );
  }

  ///اشعار رفض المهام للمشروع
  factory AppNotification.rejectTasks(
      {required String projectId, String? projectTitle}) {
    return AppNotification(
      title: "لقد تم رفض مهام المشروع",
      body: "لقد قام صاحب المشروع برفض المهام على مشروع ${projectTitle ?? ''}",
      data: {"type": AppNotificationTypes.rejectTasks, "id": projectId},
    );
  }

  ///اشعار قبول المهام للمشروع
  factory AppNotification.approveTasks(
      {required String projectId, String? projectTitle}) {
    return AppNotification(
      title: "لقد تم قبول مهام المشروع",
      body: "لقد قام صاحب المشروع بقبول المهام على مشروع ${projectTitle ?? ''}",
      data: {"type": AppNotificationTypes.approveTasks, "id": projectId},
    );
  }

  ///اشعار انهاء مهمه في مشروع
  factory AppNotification.endTask(
      {required String projectId, String? projectTitle, int? taskNumber}) {
    return AppNotification(
      title: "تم انهاء مهمة",
      body:
          "لقد تم انهاء المهمة ${taskNumber != null ? "رقم $taskNumber" : ""} في مشروعك ${projectTitle ?? ''}",
      data: {"type": AppNotificationTypes.endTask, "id": projectId},
    );
  }

  ///اشعار رفض انهاء مهمه في مشروع
  factory AppNotification.rejectTask(
      {required String projectId,
      String? projectTitle,
      int? taskNumber,
      String? rejectionReason}) {
    return AppNotification(
      title: "لقد تم رفض انهاء مهمة",
      body:
          "لقد تم رفض انهاء المهمة ${taskNumber != null ? "رقم $taskNumber" : ""} في المشروع ${projectTitle ?? ''} ${rejectionReason != null ? "بسبب : $rejectionReason" : ''}",
      data: {"type": AppNotificationTypes.rejectTask, "id": projectId},
    );
  }

  ///اشعار الموفقة على انهاء مهمه في مشروع
  factory AppNotification.approveTask({
    required String projectId,
    String? projectTitle,
    int? taskNumber,
  }) {
    return AppNotification(
      title: "لقد تمت الموافقة على انهاء مهمة",
      body:
          "لقد تمت الموافقة على انهاء المهمة ${taskNumber != null ? "رقم $taskNumber" : ""} في المشروع ${projectTitle ?? ''}",
      data: {"type": AppNotificationTypes.approveTask, "id": projectId},
    );
  }

  ///اشعار طلب مهمة اضافية
  factory AppNotification.requestExtraTask({
    required String projectId,
    String? projectTitle,
    String? extraTaskDescription,
  }) {
    return AppNotification(
      title: "لديك طلب لمهمة إضافية",
      body:
          "لقد تم طلب مهمة اضافية على المشروع ${projectTitle ?? ''} ${extraTaskDescription != null ? "وهي : $extraTaskDescription" : ''}",
      data: {"type": AppNotificationTypes.requestExtraTask, "id": projectId},
    );
  }

  factory AppNotification.cancelRequestExtraTask({
    required String projectId,
    String? projectTitle,
    String? extraTaskDescription,
  }) {
    return AppNotification(
      title: "تم إلغاء طلب المهمة الإضافية",
      body:
          "لقد تم إلغاء طلب المهمة الاضافية على المشروع ${projectTitle ?? ''} ${extraTaskDescription != null ? "وهي : $extraTaskDescription" : ''}",
      data: {
        "type": AppNotificationTypes.cancelRequestExtraTask,
        "id": projectId
      },
    );
  }

  ///اشعار رفض مهمة اضافية
  factory AppNotification.rejectRequestedExtraTask({
    required String projectId,
    String? projectTitle,
    String? extraTaskDescription,
  }) {
    return AppNotification(
      title: "تم رفض طلب المهمة الإضافية",
      body:
          "لقد تم رفض طلب المهمة الاضافية على المشروع ${projectTitle ?? ''} ${extraTaskDescription != null ? "وهي : $extraTaskDescription" : ''}",
      data: {
        "type": AppNotificationTypes.rejectRequestedExtraTask,
        "id": projectId
      },
    );
  }

  ///اشعار الموافقة على مهمة اضافية
  factory AppNotification.approveRequestExtraTask({
    required String projectId,
    String? projectTitle,
    String? extraTaskDescription,
  }) {
    return AppNotification(
      title: "تمت الموافقة على طلب المهمة الإضافية",
      body:
          "لقد تمت الموافقة على طلبك لمهمة اضافية على المشروع ${projectTitle ?? ''} ${extraTaskDescription != null ? "وهي : $extraTaskDescription" : ''}",
      data: {
        "type": AppNotificationTypes.approveRequestExtraTask,
        "id": projectId
      },
    );
  }

  factory AppNotification.completeProject({
    required String projectId,
    String? projectTitle,
  }) {
    return AppNotification(
      title: "تم انهاء المشروع",
      body: "لقد قام صاحب المشروع ${projectTitle ?? ''} بانهاءه",
      data: {"type": AppNotificationTypes.completeProject, "id": projectId},
    );
  }

  factory AppNotification.cancelProject(
      {required String projectId, String? projectTitle, String? cancelReason}) {
    return AppNotification(
      title: "تم إلغاء المشروع",
      body:
          "لقد قام صاحب المشروع ${projectTitle ?? ''} بإلغاءه ${cancelReason != null ? "بسبب : $cancelReason" : ''}",
      data: {"type": AppNotificationTypes.cancelProject, "id": projectId},
    );
  }

  factory AppNotification.newRating({
    required String projectId,
    String? projectTitle,
    required bool isClient,
  }) {
    return AppNotification(
      title: "تقييم جديد",
      body:
          "لديك تقييم جديد في مشروع ${projectTitle != null ? '"$projectTitle"' : ''}.\n لا تنسى تقييم الطرف الآخر !",
      // body:"لقد قام ${isClient ? "الفريلانسر" : "صاحب المشروع"} بتقييمك على مشروع ${projectTitle !=null ? '"$projectTitle"' : ''}\nيمكنك ا",
      data: {"type": AppNotificationTypes.newRating, "id": projectId},
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
