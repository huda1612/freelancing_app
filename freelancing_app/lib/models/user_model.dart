import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String fname;
  final String lname;
  final String email;
  final String role;
  final String photoUrl;
  final String bio;
  final List<String> skills; //هي لازم غيرها بس اعمل صف المهارات
  final double rating;
  final int completedProjects;
  final int points;
  final Timestamp? createdAt;

  UserModel({
    required this.uid,
    required this.fname,
    required this.lname,
    required this.email,
    required this.role,
    this.photoUrl = '',
    this.bio = '',
    this.skills = const [],
    this.rating = 0.0,
    this.completedProjects = 0,
    this.points = 0,
    this.createdAt,
  });

  // 🔹 تحويل من Object إلى Map (للتخزين)
  Map<String, dynamic> toMap() {
    return {
      'fname': fname,
      'lname': lname,
      'email': email,
      'role': role,
      'photoUrl': photoUrl,
      'bio': bio,
      'skills': skills,
      'rating': rating,
      'completed_projects': completedProjects,
      'points': points,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  // 🔹 تحويل من Firestore إلى Object
  factory UserModel.fromMap(Map<String, dynamic> map, String docId) {
    return UserModel(
      uid: docId,
      fname: map['fname'] ?? '',
      lname: map['lname'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      bio: map['bio'] ?? '',
      skills: List<String>.from(map['skills'] ?? []),
      rating: (map['rating'] ?? 0).toDouble(),
      completedProjects: map['completed_projects'] ?? 0,
      points: map['points'] ?? 0,
      createdAt: map['createdAt'] as Timestamp?,
    );
  }
}
