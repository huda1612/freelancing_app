import 'package:cloud_firestore/cloud_firestore.dart';

class ActivitiesModel {
  final String id;
  final String action;
  final int points;
  final Timestamp? createdAt;

  ActivitiesModel({
    required this.id,
    required this.action,
    required this.points,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'action': action,
      'points': points,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  factory ActivitiesModel.fromMap(Map<String, dynamic> map, String docId) {
    return ActivitiesModel(
      id: docId,
      action: map['action'] ?? '',
      points: map['points'] ?? 0,
      createdAt:
          map['createdAt'] is Timestamp ? map['createdAt'] as Timestamp : null,
    );
  }
}