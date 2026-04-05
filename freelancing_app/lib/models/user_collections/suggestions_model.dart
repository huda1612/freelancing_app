import 'package:cloud_firestore/cloud_firestore.dart';

class SuggestionsModel {
  final String id;
  final String type; // project | freelancer
  final String targetId;
  final double score;
  final Timestamp? createdAt;

  SuggestionsModel({
    required this.id,
    required this.type,
    required this.targetId,
    required this.score,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'targetId': targetId,
      'score': score,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  factory SuggestionsModel.fromMap(Map<String, dynamic> map, String docId) {
    return SuggestionsModel(
      id: docId,
      type: map['type'] ?? '',
      targetId: map['targetId'] ?? '',
      score: (map['score'] as num?)?.toDouble() ?? 0.0,
      createdAt:
          map['createdAt'] is Timestamp ? map['createdAt'] as Timestamp : null,
    );
  }
}