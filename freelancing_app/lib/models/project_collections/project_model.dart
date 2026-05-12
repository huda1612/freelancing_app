import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/project_status.dart';
import 'package:freelancing_platform/models/skill_collections/specialization_model.dart';

// enum ProjectStatus {
//   newProject,
//   inProgress,
//   completed,
// }

class ProjectModel {
  final String id;
  final String clientId;
  final String title;
  final String description;
  final SpecializationSnapshot category;
  final List<String> skillsRequired;
  final double budget;
  final int durationDays;
  final String status;
  final String? acceptedOfferId;
  final Timestamp? createdAt;

  ProjectModel({
    required this.id,
    required this.clientId,
    required this.title,
    required this.description,
    required this.category,
    this.skillsRequired = const [],
    required this.budget,
    required this.durationDays,
    this.status = ProjectStatus.newProject,
    this.acceptedOfferId,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'clientId': clientId,
      'title': title,
      'description': description,
      'category': category.toMap(),
      'skillsRequired': skillsRequired,
      'budget': budget,
      'durationDays': durationDays,
      'status': status,
      'acceptedOfferId': acceptedOfferId,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  factory ProjectModel.fromMap(Map<String, dynamic> map, String docId) {
    return ProjectModel(
      id: docId,
      clientId: map['clientId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: SpecializationSnapshot.fromMap(map['category'] ?? ''),
      skillsRequired: List<String>.from(map['skillsRequired'] ?? []),
      budget: (map['budget'] as num?)?.toDouble() ?? 0.0,
      durationDays: map['durationDays'] ?? 0,
      status: map['status'] ?? 'new',
      acceptedOfferId: map['acceptedOfferId'],
      createdAt:
          map['createdAt'] is Timestamp ? map['createdAt'] as Timestamp : null,
    );
  }
}




//   static String statusToString(ProjectStatus status) {
//   switch (status) {
//     case ProjectStatus.newProject:
//       return 'new';
//     case ProjectStatus.inProgress:
//       return 'in_progress';
//     case ProjectStatus.completed:
//       return 'completed';
//   }
// }

// static ProjectStatus stringToStatus(String status) {
//   switch (status) {
//     case 'in_progress':
//       return ProjectStatus.inProgress;
//     case 'completed':
//       return ProjectStatus.completed;
//     default:
//       return ProjectStatus.newProject;
//   }
// }
