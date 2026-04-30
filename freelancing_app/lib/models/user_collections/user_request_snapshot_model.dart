import 'package:freelancing_platform/models/skill_collections/specialization_model.dart';

import 'worksamples_model.dart'; // مودل الأعمال السابقة
import 'certificate_model.dart'; // مودل الشهادات

class UserRequestSnapshotModel {
  final SpecializationSnapshot? specialization;
  final String jobTitle;
  final String bio;
  final String? clientType;

  final List<String>? skills;
  final List<WorksampleModel> workSamples;
  final List<CertificateModel> certificates;

  UserRequestSnapshotModel({
    this.specialization,
    required this.jobTitle,
    required this.bio,
    this.clientType,
    this.skills,
    required this.workSamples,
    this.certificates = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'specialization': specialization?.toMap(),
      'jobTitle': jobTitle,
      'bio': bio,
      'clientType': clientType,
      'skills': skills,
      'workSamples': workSamples.map((e) => e.toMap()).toList(),
      'certificates': certificates.map((e) => e.toMap()).toList(),
    };
  }

  factory UserRequestSnapshotModel.fromMap(Map<String, dynamic> map) {
    final specializationData = map['specialization'];
    final specialization = specializationData != null
        ? specializationData is Map
            ? SpecializationSnapshot.fromMap(
                Map<String, dynamic>.from(specializationData))
            : SpecializationSnapshot(
                slug: specializationData?.toString() ?? '',
                name: '',
              )
        : null;

    return UserRequestSnapshotModel(
      specialization: specialization,
      jobTitle: map['jobTitle'] ?? '',
      bio: map['bio'] ?? '',
      clientType: map['clientType'],
      skills: map['skills'] != null ? List<String>.from(map['skills']) : null,
      workSamples: map['workSamples'] != null
          ? List<WorksampleModel>.from(map['workSamples']
              .map((x) => WorksampleModel.fromMap(x, x['id'] ?? '')))
          : [],
      certificates: map['certificates'] != null
          ? List<CertificateModel>.from(map['certificates']
              .map((x) => CertificateModel.fromMap(x, x['id'] ?? '')))
          : [],
    );
  }
}
