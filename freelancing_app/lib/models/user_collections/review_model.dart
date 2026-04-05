import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String id;
  final String fromUserId;
  final String projectId;
  final String comment;
  final double rating;
  final Timestamp? createdAt;

  ReviewModel({
    required this.id,
    required this.fromUserId,
    required this.projectId,
    this.comment = '',
    required this.rating,
    this.createdAt,
  });
  Map<String, dynamic> toMap() {
    return {
      'fromUserId': fromUserId,
      'projectId': projectId,
      'comment': comment,
      'rating': rating,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map, String docId) {
    return ReviewModel(
      id: docId,
      fromUserId: map['fromUserId'] ?? '',
      projectId: map['projectId'] ?? '',
      comment: map['comment'] ?? '',
      // rating: (map['rating'] ?? 0).toDouble(),
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      // createdAt: map['createdAt'] as Timestamp?, //??
      createdAt: map['createdAt'] is Timestamp
    ? map['createdAt'] as Timestamp
    : null,
    );
  }
}
