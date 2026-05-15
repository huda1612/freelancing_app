// enum ProjectStatus {newProject,inProgress,completed,}
class ProjectStatus {
  static const String newProject = "newProject";
  static const String inProgress = "inProgress";
  static const String cancelled = "cancelled";
  static const String delivered = "delivered";
  static const String completed = "completed";


  //اضافات جديدة 
  /// تسميات التبويبات في صفحة مشاريعي (للعميل).
  static const List<String> clientTabStatuses = [
    newProject,
    inProgress,
    delivered,
    completed,
    cancelled,
  ];

  static const List<String> clientTabLabels = [
    'جديدة',
    'قيد التقدم',
    'مستلمة',
    'مكتملة',
    'مسحوبة',
  ];
}
