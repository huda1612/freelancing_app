import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freelancing_platform/core/constants/user_status.dart';
import 'package:freelancing_platform/models/skill_collections/specialization_model.dart';

// enum UserStatus { incomplete, pending, approved, rejected }

// String statusToString(UserStatus status) {
//   switch (status) {
//     case UserStatus.incomplete:
//       return 'incomplete';
//     case UserStatus.pending:
//       return 'pending';
//     case UserStatus.approved:
//       return 'approved';
//     case UserStatus.rejected:
//       return 'rejected';
//   }
// }

class UserModel {
  final String uid;
  final String fname;
  final String lname;
  final String username;
  final String status;
  final String? gender;
  final String? countryCode;
  final DateTime? birthDate;
  final String email;
  final String role;
  final String photoUrl;
  final SpecializationSnapshot? specialization;
  final String bio;
  final String jobTitle;
  final List<String> skills; //هي لازم غيرها بس اعمل صف المهارات
  final double rating;
  final int completedProjects;
  final int points;
  final Timestamp? createdAt;

  //بحال كان عميل بس
  final String? clientType;

  UserModel({
    required this.uid,
    required this.fname,
    required this.lname,
    required this.username,
    this.status = UserStatus.incomplete,
    this.gender,
    this.countryCode,
    this.birthDate,
    required this.email,
    required this.role,
    this.photoUrl = '',
    this.specialization,
    this.bio = '',
    this.jobTitle = '',
    this.skills = const [],
    this.rating = 0.0,
    this.completedProjects = 0,
    this.points = 0,
    this.createdAt,

    //بحال كان عميل بس
    this.clientType,
  });

  // 🔹 تحويل من Object إلى Map (للتخزين)
  Map<String, dynamic> toMap() {
    return {
      'fname': fname,
      'lname': lname,
      'username': username,
      'status': status,
      'gender': gender,
      'countryCode': countryCode,
      'birthDate': birthDate != null ? Timestamp.fromDate(birthDate!) : null,
      'email': email,
      'role': role,
      'photoUrl': photoUrl,
      'specialization': specialization?.toMap(),
      'bio': bio,
      'jobTitle': jobTitle,
      'skills': skills,
      'rating': rating,
      'completed_projects': completedProjects,
      'points': points,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'clientType': clientType
    };
  }

  // 🔹 تحويل من Firestore إلى Object
  factory UserModel.fromMap(Map<String, dynamic> map, String docId) {
    final specializationData = map['specialization'];
    final specialization = specializationData is Map
        ? SpecializationSnapshot.fromMap(
            Map<String, dynamic>.from(specializationData))
        : SpecializationSnapshot(
            slug: specializationData?.toString() ?? '',
            name: '',
          );
    return UserModel(
      uid: docId,
      fname: map['fname'] ?? '',
      lname: map['lname'] ?? '',
      username: map['username'] ?? '',
      status: map['status'] ?? UserStatus.incomplete,
      gender: map['gender'], //?? null,

      countryCode: map['countryCode'],
      birthDate: map['birthDate'] != null
          ? (map['birthDate'] as Timestamp).toDate()
          : null,
      email: map['email'] ?? '',
      role: map['role'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      specialization: specialization,
      bio: map['bio'] ?? '',
      jobTitle: map['jobTitle'] ?? '',
      skills: List<String>.from(map['skills'] ?? []),
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      completedProjects: map['completed_projects'] ?? 0,
      points: map['points'] ?? 0,
      createdAt:
          map['createdAt'] is Timestamp ? map['createdAt'] as Timestamp : null,

      //بحال كان عميل بس
      clientType: map['clientType'],
    );
  }
}
