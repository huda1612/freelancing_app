class ProjectStatus {
  static const String newProject = "newProject";
  static const String setup = "setup";
  static const String waitingTasksApproval = "waitingTasksApproval";
  static const String inProgress = "inProgress";
  static const String readyToComplete = "readyToComplete";
  static const String cancelled = "cancelled";
  // static const String delivered = "delivered";
  static const String completed = "completed";

  //اضافات جديدة
  /// تسميات التبويبات في صفحة مشاريعي (للعميل).
  static const List<String> clientTabStatuses = [
    newProject,
    inProgress,
    // delivered,
    completed,
    cancelled,
  ];

  static const List<String> clientTabLabels = [
    'جديدة',
    'قيد التقدم',
    // 'مستلمة',
    'مكتملة',
    'مسحوبة',
  ];

  //اضافات جديدة
  /// تسميات التبويبات في صفحة مشاريعي (للمستقل).
  static const List<String> freelancerTabStatuses = [
    inProgress,
    // delivered,
    completed,
    cancelled,
  ];

  static const List<String> freelancerTabLabels = [
    'قيد التقدم',
    // 'تم التسليم',
    'مكتملة',
    'مسحوبة',
  ];
}
