import 'package:cloud_firestore/cloud_firestore.dart';

class WorksamplesModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final Timestamp? createdAt;

  WorksamplesModel({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl = '',
    this.createdAt,
  });
  // 🔹 تحويل من Object إلى Map (للتخزين)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  // 🔹 تحويل من Firestore إلى Object
  factory WorksamplesModel.fromMap(Map<String, dynamic> map, String docId) {
    return WorksamplesModel(
      id: docId,
      title: map['title'],
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      // createdAt: map['createdAt'],
      createdAt:
          map['createdAt'] is Timestamp ? map['createdAt'] as Timestamp : null,
    );
  }
}
