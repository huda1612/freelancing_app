import 'package:cloud_firestore/cloud_firestore.dart';

class PortfolioModel {
  final String title;
  final String description;
  final String imageUrl;
  final Timestamp? createdAt;

  PortfolioModel({
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
  factory PortfolioModel.fromMap(Map<String, dynamic> map) {
    return PortfolioModel(
      title: map['title'],
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      // createdAt: map['createdAt'],
      createdAt: map['createdAt'] as Timestamp?, //??
    );
  }
}
