import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_request_snapshot_model.dart';

enum RequestStatus { pending, approved, rejected }

class UserRequestModel {
  final String id;
  final String userId;
  final UserRequestSnapshotModel snapshot;
  final RequestStatus status;
  final Timestamp? createdAt;

  UserRequestModel({
    required this.id,
    required this.userId,
    required this.snapshot,
    this.status = RequestStatus.pending,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'snapshot': snapshot.toMap(),
      'status': status.name, // pending, approved, rejected
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  factory UserRequestModel.fromMap(Map<String, dynamic> map, String docId) {
    return UserRequestModel(
      id: docId,
      userId: map['userId'] ?? '',
      snapshot: UserRequestSnapshotModel.fromMap(map['snapshot'] ?? {}),
      status: map['status'] != null
          ? RequestStatus.values.firstWhere((e) => e.name == map['status'],
              orElse: () => RequestStatus.pending)
          : RequestStatus.pending,
      createdAt:
          map['createdAt'] is Timestamp ? map['createdAt'] as Timestamp : null,
    );
  }
}
