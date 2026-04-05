class SkillGroupModel {
  final String id;
  final String categoryName;
  final List<String> skills;

  SkillGroupModel({
    required this.id,
    required this.categoryName,
    this.skills = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'categoryName': categoryName,
      'skills': skills,
    };
  }

  factory SkillGroupModel.fromMap(Map<String, dynamic> map, String docId) {
    return SkillGroupModel(
      id: docId,
      categoryName: map['categoryName'] ?? '',
      skills: List<String>.from(map['skills'] ?? []),
    );
  }
}
