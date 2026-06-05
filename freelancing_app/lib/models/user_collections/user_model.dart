import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/user_status.dart';
import 'package:freelancing_platform/models/skill_collections/specialization_model.dart';

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
  // final double rating;
  final int completedProjects;
  final int points;
  final Timestamp? createdAt;
  final List<String>? fcmTokens;

  //بحال كان عميل بس
  final String? clientType;

  // ⭐ Ratings aggregation
  final int ratingsCount;

  final double professionalismSum;
  final double communicationSum;
  final double punctualitySum;
  final double qualitySum;
  final double workAgainSum;

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
    // this.rating = 0.0,
    this.completedProjects = 0,
    this.points = 0,
    this.createdAt,
    this.fcmTokens = const [],
    //بحال كان عميل بس
    this.clientType,

    // ratings defaults
    this.ratingsCount = 0,
    this.professionalismSum = 0,
    this.communicationSum = 0,
    this.punctualitySum = 0,
    this.qualitySum = 0,
    this.workAgainSum = 0,
  });

  double get overallRating {
    if (ratingsCount == 0) return 0.0;

    final totalSum = professionalismSum +
        communicationSum +
        punctualitySum +
        qualitySum +
        workAgainSum;

    return totalSum / (ratingsCount * 5);
  }

  // double get overallRating {
  //   print("ratingsCount: ${ratingsCount}");
  //   print("prof: ${professionalismSum}");
  //   print("comm: ${communicationSum}");
  //   print("pun: ${punctualitySum}");
  //   print("qual: ${qualitySum}");
  //   print("work: ${workAgainSum}");
  //   if (ratingsCount == 0) return 0.0;
  //   final professionalismAvg = professionalismSum / ratingsCount;
  //   final communicationAvg = communicationSum / ratingsCount;
  //   final punctualityAvg = punctualitySum / ratingsCount;
  //   final qualityAvg = qualitySum / ratingsCount;
  //   final workAgainAvg = workAgainSum / ratingsCount;
  //   return (professionalismAvg +
  //           communicationAvg +
  //           punctualityAvg +
  //           qualityAvg +
  //           workAgainAvg) /
  //       5;
  // }

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
      // 'rating': rating,
      'completed_projects': completedProjects,
      'points': points,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'clientType': clientType,
      'fcmTokens': fcmTokens,

      // ⭐ ratings
      'ratingsCount': ratingsCount,
      'professionalismSum': professionalismSum,
      'communicationSum': communicationSum,
      'punctualitySum': punctualitySum,
      'qualitySum': qualitySum,
      'workAgainSum': workAgainSum,
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
      // rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      completedProjects: map['completed_projects'] ?? 0,
      points: map['points'] ?? 0,
      createdAt:
          map['createdAt'] is Timestamp ? map['createdAt'] as Timestamp : null,

      //بحال كان عميل بس
      clientType: map['clientType'],
      fcmTokens: (map['fcmTokens'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],

      // ⭐ ratings
      ratingsCount: map['ratingsCount'] ?? 0,
      professionalismSum:
          (map['professionalismSum'] as num?)?.toDouble() ?? 0.0,
      communicationSum: (map['communicationSum'] as num?)?.toDouble() ?? 0.0,
      punctualitySum: (map['punctualitySum'] as num?)?.toDouble() ?? 0.0,
      qualitySum: (map['qualitySum'] as num?)?.toDouble() ?? 0.0,
      workAgainSum: (map['workAgainSum'] as num?)?.toDouble() ?? 0.0,
    );
  }
  UserModel copyWith({
    String? uid,
    String? fname,
    String? lname,
    String? username,
    String? status,
    String? gender,
    String? countryCode,
    DateTime? birthDate,
    String? email,
    String? role,
    String? photoUrl,
    SpecializationSnapshot? specialization,
    String? bio,
    String? jobTitle,
    List<String>? skills,
    double? rating,
    int? completedProjects,
    int? points,
    Timestamp? createdAt,
    String? clientType,
    List<String>? fcmTokens,

    // ⭐ ratings
    int? ratingsCount,
    double? professionalismSum,
    double? communicationSum,
    double? punctualitySum,
    double? qualitySum,
    double? workAgainSum,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      fname: fname ?? this.fname,
      lname: lname ?? this.lname,
      username: username ?? this.username,
      status: status ?? this.status,
      gender: gender ?? this.gender,
      countryCode: countryCode ?? this.countryCode,
      birthDate: birthDate ?? this.birthDate,
      email: email ?? this.email,
      role: role ?? this.role,
      photoUrl: photoUrl ?? this.photoUrl,
      specialization: specialization ?? this.specialization,
      bio: bio ?? this.bio,
      jobTitle: jobTitle ?? this.jobTitle,
      skills: skills ?? this.skills,
      // rating: rating ?? this.rating,
      completedProjects: completedProjects ?? this.completedProjects,
      points: points ?? this.points,
      createdAt: createdAt ?? this.createdAt,
      clientType: clientType ?? this.clientType,
      fcmTokens: fcmTokens ?? this.fcmTokens,

      // ⭐ ratings
      ratingsCount: ratingsCount ?? this.ratingsCount,
      professionalismSum: professionalismSum ?? this.professionalismSum,
      communicationSum: communicationSum ?? this.communicationSum,
      punctualitySum: punctualitySum ?? this.punctualitySum,
      qualitySum: qualitySum ?? this.qualitySum,
      workAgainSum: workAgainSum ?? this.workAgainSum,
    );
  }
}
