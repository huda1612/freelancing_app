import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freelancing_platform/core/constants/reuest_status.dart';
import 'package:freelancing_platform/core/constants/user_roles.dart';
import 'user_request_snapshot_model.dart';

// enum RequestStatus { pending, approved, rejected }

class UserRequestModel {
  final String id;
  final String uId;
  final String userType;
  final String? rejectComment;
  final UserRequestSnapshotModel snapshot;
  final String status;
  final Timestamp? createdAt;

  UserRequestModel({
    required this.id,
    required this.uId,
    required this.userType,
    this.rejectComment,
    required this.snapshot,
    this.status = RequestStatus.pending,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'userType': userType,
      'rejectComment': rejectComment,
      'snapshot': snapshot.toMap(),
      'status': status, // pending, approved, rejected
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  factory UserRequestModel.fromMap(Map<String, dynamic> map, String docId) {
    return UserRequestModel(
      id: docId,
      uId: map['userId'] ?? '',
      userType: map['userType'] ?? '',
      rejectComment: map['rejectComment'],
      snapshot: UserRequestSnapshotModel.fromMap(map['snapshot'] ?? {}),
      status: map['status'] ?? RequestStatus.pending,
      createdAt:
          map['createdAt'] is Timestamp ? map['createdAt'] as Timestamp : null,
    );
  }
}
