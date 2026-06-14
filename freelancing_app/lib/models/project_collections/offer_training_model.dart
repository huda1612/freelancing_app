import 'package:cloud_firestore/cloud_firestore.dart';

class OfferTrainingModel {
  final String? id;

  // روابط التتبع (metadata)
  final String offerId;
  final String projectId;
  final String freelancerId;

  // Features (inputs for KNN)
  final double skillMatch;
  final double rating;
  final double completedProjects;

  // Label (output)
  final int label; // 1 accepted, 0 rejected

  final Timestamp? createdAt;

  OfferTrainingModel({
    this.id,
    required this.offerId,
    required this.projectId,
    required this.freelancerId,
    required this.skillMatch,
    required this.rating,
    required this.completedProjects,
    required this.label,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'offerId': offerId,
      'projectId': projectId,
      'freelancerId': freelancerId,
      'skillMatch': skillMatch,
      'rating': rating,
      'completedProjects': completedProjects,
      'label': label,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  factory OfferTrainingModel.fromMap(Map<String, dynamic> map, String id) {
    return OfferTrainingModel(
      id: id,
      offerId: map['offerId'] ?? '',
      projectId: map['projectId'] ?? '',
      freelancerId: map['freelancerId'] ?? '',
      skillMatch: (map['skillMatch'] as num?)?.toDouble() ?? 0.0,
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      completedProjects: (map['completedProjects'] as num?)?.toDouble() ?? 0.0,
      label: map['label'] ?? 0,
      createdAt:
          map['createdAt'] is Timestamp ? map['createdAt'] as Timestamp : null,
    );
  }
}
