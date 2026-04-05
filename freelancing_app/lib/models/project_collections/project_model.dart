import 'package:cloud_firestore/cloud_firestore.dart';

enum ProjectStatus {
  newProject,
  inProgress,
  completed,
}

class ProjectModel {
  final String id;
  final String clientId;
  final String title;
  final String description;
  final List<String> skillsRequired; //هي يمكن لازم تتغير بس اعمل صف للمهارات!!!
  final double budget;
  final int durationDays;
  final ProjectStatus status;
  final String? acceptedOfferId;
  final Timestamp? createdAt;

  ProjectModel({
    required this.id,
    required this.clientId,
    required this.title,
    required this.description,
    this.skillsRequired = const [],
    required this.budget,
    required this.durationDays,
    this.status = ProjectStatus.newProject,
    this.acceptedOfferId ,
    this.createdAt,
  });

  // 🔹 تحويل enum إلى String للتخزين
  // String _statusToString(ProjectStatus status) {
  //   switch (status) {
  //     case ProjectStatus.newProject:
  //       return 'new';
  //     case ProjectStatus.inProgress:
  //       return 'in_progress';
  //     case ProjectStatus.completed:
  //       return 'completed';
  //   }
  // }

  // // 🔹 تحويل String إلى enum
  // ProjectStatus _stringToStatus(String status) {
  //   switch (status) {
  //     case 'in_progress':
  //       return ProjectStatus.inProgress;
  //     case 'completed':
  //       return ProjectStatus.completed;
  //     default:
  //       return ProjectStatus.newProject;
  //   }
  // }

  static String statusToString(ProjectStatus status) {
  switch (status) {
    case ProjectStatus.newProject:
      return 'new';
    case ProjectStatus.inProgress:
      return 'in_progress';
    case ProjectStatus.completed:
      return 'completed';
  }
}

static ProjectStatus stringToStatus(String status) {
  switch (status) {
    case 'in_progress':
      return ProjectStatus.inProgress;
    case 'completed':
      return ProjectStatus.completed;
    default:
      return ProjectStatus.newProject;
  }
}

  // 🔹 إلى Map
  Map<String, dynamic> toMap() {
    return {
      'clientId': clientId,
      'title': title,
      'description': description,
      'skills_required': skillsRequired,
      'budget': budget,
      'duration_days': durationDays,
      'status': statusToString(status),
      'acceptedOfferId': acceptedOfferId,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  // 🔹 من Map
  factory ProjectModel.fromMap(Map<String, dynamic> map, String docId) {
  ProjectStatus status = stringToStatus(map['status'] ?? 'new') ;

  return ProjectModel(
    id: docId,
    clientId: map['clientId'] ?? '',
    title: map['title'] ?? '',
    description: map['description'] ?? '',
    skillsRequired: List<String>.from(map['skills_required'] ?? []),
    budget: (map['budget'] as num?)?.toDouble() ?? 0.0,
    durationDays: map['duration_days'] ?? 0,
    status: status, // 👈 مباشرة
    acceptedOfferId: map['acceptedOfferId'] ,
    createdAt:
        map['createdAt'] is Timestamp ? map['createdAt'] as Timestamp : null,
  );
}


}
