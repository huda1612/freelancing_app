class ProjectStatus {
  static const String newProject = "newProject";
  static const String setup = "setup";
  static const String waitingTasksApproval = "waitingTasksApproval";
  static const String inProgress = "inProgress";
  static const String readyToComplete = "readyToComplete";
  static const String cancelled = "cancelled";
  static const String completed = "completed";

  // static const Map<String, String> statusAr = {
  //   newProject: 'جديد',
  //   setup: 'إعداد المشروع',
  //   waitingTasksApproval: 'بانتظار اعتماد المهام',
  //   inProgress: 'قيد التقدم',
  //   readyToComplete: 'جاهز للإغلاق',
  //   cancelled: 'ملغي',
  //   completed: 'مكتمل',
  // };

  // static String getStatusLabel(String status) {
  //   return statusAr[status] ?? 'غير معروف';
  // }

  //اضافات جديدة
  /// تسميات التبويبات في صفحة مشاريعي (للعميل).
  static const List<String> clientTabStatuses = [
    newProject,
    inProgress,
    completed,
    cancelled,
  ];

  static const List<String> clientTabLabels = [
    'جديدة',
    'قيد التقدم',
    'مكتملة',
    'غير مكتملة',
  ];

  //اضافات جديدة
  /// تسميات التبويبات في صفحة مشاريعي (للمستقل).
  static const List<String> freelancerTabStatuses = [
    inProgress,
    completed,
    cancelled,
  ];

  static const List<String> freelancerTabLabels = [
    'قيد التقدم',
    'مكتملة',
    'غير مكتملة',
  ];
}
