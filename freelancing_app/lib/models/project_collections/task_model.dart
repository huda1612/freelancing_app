import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String id;
  final String description;
  final bool isDone;
  final bool isApproved;
  final Timestamp? createdAt;

  TaskModel({
    required this.id,
    required this.description,
    this.isDone = false,
    this.isApproved = false,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'isDone': isDone,
      'isApproved': isApproved,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map, String docId) {
    return TaskModel(
      id: docId,
      description: map['description'] ?? map['name'] ?? '',
      isDone: map['isDone'] ?? false,
      isApproved: map['isApproved'] ?? false,
      createdAt:
          map['createdAt'] is Timestamp ? map['createdAt'] as Timestamp : null,
    );
  }

  TaskModel copyWith(
      {String? description,
      bool? isDone,
      bool? isApproved,
      Timestamp? createdAt}) {
    return TaskModel(
      id: id,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
      isApproved: isApproved ?? this.isApproved,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
