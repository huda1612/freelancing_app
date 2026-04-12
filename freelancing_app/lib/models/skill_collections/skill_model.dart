class SkillModel {
  final String name;
  final List<String> subSkills;
  bool expanded;

  /// قائمة المهارات الفرعية المختارة
  List<String> selectedSubSkills;

  SkillModel({
    required this.name,
    required this.subSkills,
    this.expanded = false,
    this.selectedSubSkills = const [],
  });

  factory SkillModel.fromMap(Map<String, dynamic> data) {
    return SkillModel(
      name: data['name'] ?? '',
      subSkills: List<String>.from(data['subSkills'] ?? []),
    );
  }
}
