import 'worksamples_model.dart'; // مودل الأعمال السابقة
import 'certificate_model.dart'; // مودل الشهادات

class UserRequestSnapshotModel {
  final String specialization;
  final String jobTitle;
  final String bio;
  final List<String>? skills; 
  final List<WorksampleModel> workSamples;
  final List<CertificateModel> certificates;

  UserRequestSnapshotModel({
    required this.specialization,
    required this.jobTitle,
    required this.bio,
     this.skills,
    required this.workSamples,
    this.certificates = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'specialization': specialization,
      'jobTitle': jobTitle,
      'bio': bio,
      'skills': skills,
      'workSamples': workSamples.map((e) => e.toMap()).toList(),
      'certificates': certificates.map((e) => e.toMap()).toList(),
    };
  }

  factory UserRequestSnapshotModel.fromMap(Map<String, dynamic> map) {
    return UserRequestSnapshotModel(
      specialization: map['specialization'] ?? '',
      jobTitle: map['jobTitle'] ?? '',
      bio: map['bio'] ?? '',
      skills:map['skills'] !=null ? List<String>.from(map['skills'] ) : null,
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
