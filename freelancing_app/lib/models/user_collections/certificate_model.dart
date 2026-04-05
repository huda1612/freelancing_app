import 'package:cloud_firestore/cloud_firestore.dart';

class CertificateModel {
  final String id;
  final String title;
  final String source;
  final Timestamp? createdAt;
  final Timestamp? date;
  final String credentialURL;
  final String credentialID;
  final String description;
  final String imageURL;
  final List<String> skills; //هي يمكن لازم تتغير بس اعمل صف للمهارات
  final String projectID;

  CertificateModel({
    required this.id,
    required this.title,
    required this.source,
    this.createdAt,
    this.date,
    this.credentialURL = '',
    this.credentialID = '',
    this.description = '',
    this.imageURL = '',
    this.skills = const [],
    this.projectID = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'source': source,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'date': date,
      'credentialURL': credentialURL,
      'credentialID': credentialID,
      'description': description,
      'imageURL': imageURL,
      'skills': skills,
      'projectID': projectID,
    };
  }

  factory CertificateModel.fromMap(Map<String, dynamic> map, String docId) {
    return CertificateModel(
      id: docId,
      title: map['title'] ?? '',
      source: map['source'] ?? '',
      createdAt:
          map['createdAt'] is Timestamp ? map['createdAt'] as Timestamp : null,
      date: map['date'] is Timestamp ? map['date'] as Timestamp : null,
      credentialURL: map['credentialURL'] ?? '',
      credentialID: map['credentialID'] ?? '',
      description: map['description'] ?? '',
      imageURL: map['imageURL'] ?? '',
      skills: List<String>.from(map['skills'] ?? []),
      projectID: map['projectID'] ?? '',
    );
  }
}