import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/task_status.dart';

class TaskModel {
  final String id;
  final String description;
  final double amount;
  final String status;
  final String? rejectionReason;
  //للمهام الاضافيه
  final bool isExtra;
  final String? requestedBy;

  final Timestamp? createdAt;

  TaskModel({
    required this.id,
    required this.description,
    required this.amount,
    this.status = TaskStatus.pending,
    this.rejectionReason,
    this.isExtra = false,
    this.requestedBy,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'amount': amount,
      'status': status,
      'rejectionReason': rejectionReason,
      'isExtra': isExtra,
      'requestedBy': requestedBy,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map, String docId) {
    return TaskModel(
      id: docId,
      description: map['description'] ?? map['name'] ?? '',
      amount: map['amount'] ?? 0,
      status: map['status'],
      // ?? TaskStatus.pending

      isExtra: map['isExtra'] ?? false,
      requestedBy: map['requestedBy'],
      rejectionReason: map['rejectionReason'],
      createdAt:
          map['createdAt'] is Timestamp ? map['createdAt'] as Timestamp : null,
    );
  }

  TaskModel copyWith(
      {String? description,
      double? amount,
      String? status,
      String? rejectionReason,
      bool? isExtra,
      String? requestedBy,
      Timestamp? createdAt}) {
    return TaskModel(
      id: id,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      isExtra: isExtra ?? this.isExtra,
      requestedBy: requestedBy ?? this.requestedBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
