import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/project_status.dart';
import 'package:freelancing_platform/models/skill_collections/specialization_model.dart';

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
  final String? acceptedFreelancerId;
  final int? tasksCount;
  final int? completedTasksCount;
  final String? cancelReason;
  //rated
  final bool clientRated;
  final bool freelancerRated;
  //dates
  final Timestamp? createdAt;
  final Timestamp? startAt;
  final Timestamp? allTasksCompletedAt;
  final Timestamp? endAt;

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
    this.acceptedFreelancerId,
    this.tasksCount,
    this.completedTasksCount,
    this.cancelReason,
    this.clientRated = false,
    this.freelancerRated = false,
    this.createdAt,
    this.startAt,
    this.allTasksCompletedAt,
    this.endAt,
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
      'acceptedFreelancerId': acceptedFreelancerId,
      'tasksCount': tasksCount,
      'completedTasksCount': completedTasksCount,
      'cancelReason': cancelReason,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'startAt': startAt,
      'allTasksCompletedAt': allTasksCompletedAt,
      'endAt': endAt,
      'clientRated': clientRated,
      'freelancerRated': freelancerRated,
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
      acceptedFreelancerId: map['acceptedFreelancerId'],
      tasksCount: map['tasksCount'],
      completedTasksCount: map['completedTasksCount'],
      cancelReason: map['cancelReason'],
      createdAt:
          map['createdAt'] is Timestamp ? map['createdAt'] as Timestamp : null,
      startAt: map['startAt'],
      allTasksCompletedAt: map['allTasksCompletedAt'],
      endAt: map['endAt'],
      clientRated: map['clientRated'] ?? false,
      freelancerRated: map['freelancerRated'] ?? false,
    );
  }
  ProjectModel copyWith({
    String? id,
    String? clientId,
    String? title,
    String? description,
    SpecializationSnapshot? category,
    List<String>? skillsRequired,
    double? budget,
    int? durationDays,
    String? status,
    String? acceptedOfferId,
    String? acceptedFreelancerId,
    int? tasksCount,
    int? completedTasksCount,
    String? cancelReason,
    Timestamp? createdAt,
    Timestamp? startAt,
    Timestamp? allTasksCompletedAt,
    Timestamp? endAt,
    bool? clientRated,
    bool? freelancerRated,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      skillsRequired: skillsRequired ?? this.skillsRequired,
      budget: budget ?? this.budget,
      durationDays: durationDays ?? this.durationDays,
      status: status ?? this.status,
      acceptedOfferId: acceptedOfferId ?? this.acceptedOfferId,
      acceptedFreelancerId: acceptedFreelancerId ?? this.acceptedFreelancerId,
      tasksCount: tasksCount ?? this.tasksCount,
      completedTasksCount: completedTasksCount ?? this.completedTasksCount,
      cancelReason: cancelReason ?? this.cancelReason,
      createdAt: createdAt ?? this.createdAt,
      startAt: startAt ?? this.startAt,
      allTasksCompletedAt: allTasksCompletedAt ?? this.allTasksCompletedAt,
      endAt: endAt ?? this.endAt,
      clientRated: clientRated ?? this.clientRated,
      freelancerRated: freelancerRated ?? this.freelancerRated,
    );
  }
}
