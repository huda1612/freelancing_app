import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/offer_status.dart';

class OfferModel {
  final String id;
  final String projectId;
  final String freelancerId;
  final String clientId;
  final double price;
  final int durationDays;
  final String proposalText;
  final String status;
  final UserSnapshotModel freelancerSnapshot;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;

  OfferModel({
    required this.id,
    required this.projectId,
    required this.freelancerId,
    required this.clientId,
    required this.price,
    required this.durationDays,
    this.status =OfferStatus.pending,
    required this.freelancerSnapshot,
    this.proposalText = '',
    this.createdAt,
    this.updatedAt,
  });

  // 🔹 تحويل من Object إلى Map
  Map<String, dynamic> toMap() {
    return {
      'projectId': projectId,
      'clientId': clientId,
      'freelancerId': freelancerId,
      'price': price,
      'duration_days': durationDays,
      'proposal_text': proposalText,
      'status': status,
      'freelancerSnapshot': freelancerSnapshot.toMap(),
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': updatedAt,
    };
  }

  // 🔹 تحويل من Map إلى Object
  factory OfferModel.fromMap(Map<String, dynamic> map, String docId) {
    return OfferModel(
      id: docId,
      projectId: map['projectId'],
      freelancerId: map['freelancerId'],
      clientId: map['clientId'],
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      durationDays: map['duration_days'] ?? 0,
      proposalText: map['proposal_text'] ?? '',
      status: map['status'],
      freelancerSnapshot: UserSnapshotModel.fromMap(
        Map<String, dynamic>.from(
          map['freelancerSnapshot'] ?? {},
        ),
      ),
      // freelancerSnapshot:
      //     Map<String, dynamic>.from(map['freelancerSnapshot'] ?? {}),
      createdAt:
          map['createdAt'] is Timestamp ? map['createdAt'] as Timestamp : null,
      updatedAt:
          map['updatedAt'] is Timestamp ? map['updatedAt'] as Timestamp : null,
    );
  }
}

class UserSnapshotModel {
  final String fullName;
  final String username;
  final String jobTitle;
  final String specialization;
  final double rating;
  final int completedProjects;

  const UserSnapshotModel({
    required this.fullName,
    required this.username,
    required this.jobTitle,
    required this.specialization,
    required this.rating,
    required this.completedProjects,
  });

  Map<String, dynamic> toMap() {
    return {
      "fullName": fullName,
      "username": username,
      "jobTitle": jobTitle,
      "specialization": specialization,
      "rating": rating,
      "completedProjects": completedProjects,
    };
  }

  factory UserSnapshotModel.fromMap(Map<String, dynamic> map) {
    return UserSnapshotModel(
      fullName: map["fullName"] ?? "",
      username: map["username"] ?? "",
      jobTitle: map["jobTitle"] ?? "",
      specialization: map["specialization"] ?? "",
      rating: (map["rating"] ?? 0).toDouble(),
      completedProjects: map["completedProjects"] ?? 0,
    );
  }
  // factory UserSnapshotModel.fromUserModel(UserModel user) {
  //   return UserSnapshotModel(
  //     fullName: "${user.fname} ${user.lname}".trim(),
  //     username: user.username,
  //     jobTitle: user.jobTitle,
  //     specialization: user.specialization?.name ?? "",
  //     rating: user.rating,
  //     completedProjects: user.completedProjects,
  //   );
  // }
}
