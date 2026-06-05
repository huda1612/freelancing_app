import 'package:cloud_firestore/cloud_firestore.dart';

class RatingModel {
  final String id;

  /// من أعطى التقييم
  final String fromUserId;

  final String projectId;

  // ⭐ المعايير (كلها من 1 إلى 5 )
  /// الاحترافية بالتعامل
  final double professionalism;

  /// التواصل والمتابعة
  final double communication;

  /// الالتزام بالوقت
  final double punctuality;

  /// جودة العمل
  final double quality;

  /// التعامل معه مرة أخرى
  final double workAgain;

  final String? comment;

  final Timestamp? createdAt;

  // اسم المشروع (للعرض مباشرة)
  final String? projectName;
  // تصنيف/نوع المشروع
  final String? category;
  // حالة المشروع
  final String? projectStatus;

  RatingModel({
    required this.id,
    required this.fromUserId,
    required this.projectId,
    required this.professionalism,
    required this.communication,
    required this.punctuality,
    required this.quality,
    required this.workAgain,
    this.comment,
    this.createdAt,
    this.projectName,
    this.category,
    this.projectStatus,
  });

  /// متوسط التقييم
  double get averageRating {
    return (professionalism +
            communication +
            punctuality +
            quality +
            workAgain) /
        5;
  }

  Map<String, dynamic> toMap() {
    return {
      'fromUserId': fromUserId,
      'projectId': projectId,
      'professionalism': professionalism,
      'communication': communication,
      'punctuality': punctuality,
      'quality': quality,
      'workAgain': workAgain,
      'comment': comment,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'projectName': projectName,
      'category': category,
      'projectStatus': projectStatus,
    };
  }

  factory RatingModel.fromMap(Map<String, dynamic> map, String docId) {
    return RatingModel(
      id: docId,
      fromUserId: map['fromUserId'], //?? '',
      projectId: map['projectId'], //?? '',
      professionalism: (map['professionalism'] as num?)?.toDouble() ?? 0.0,
      communication: (map['communication'] as num?)?.toDouble() ?? 0.0,
      punctuality: (map['punctuality'] as num?)?.toDouble() ?? 0.0,
      quality: (map['quality'] as num?)?.toDouble() ?? 0.0,
      // workAgain: map['workAgain'] ?? false,
      workAgain: (map['workAgain'] as num?)?.toDouble() ?? 0.0,
      comment: map['comment'],
      createdAt:
          map['createdAt'] is Timestamp ? map['createdAt'] as Timestamp : null,
      projectName: map['projectName'],
      category: map['category'],
      projectStatus: map['projectStatus'],
    );
  }
}
