import 'package:cloud_firestore/cloud_firestore.dart';

class WorksampleModel {
  final String? id;
  final String title;
  final String description;
  final String imageUrl;
  final Timestamp? createdAt;

  WorksampleModel({
    this.id,
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
      'createdAt': createdAt ?? Timestamp.now(),
    };
  }

  // 🔹 تحويل من Firestore إلى Object
  factory WorksampleModel.fromMap(Map<String, dynamic> map, String docId) {
    return WorksampleModel(
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
