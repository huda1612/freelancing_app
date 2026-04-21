import 'package:get/get_rx/src/rx_types/rx_types.dart';

//هاد للحذف بس خليته هلأ مشان ما يصير خطأ بالمشروع
class SkillModel {
  final String id;
  final String name;
  final List<String> subSkills;
  RxBool expanded = false.obs;

  // قائمة المهارات الفرعية المختارة
  RxList<String> selectedSubSkills = <String>[].obs;

  SkillModel({
    required this.id,
    required this.name,
    this.subSkills = const [],
  });

  factory SkillModel.fromMap(Map<String, dynamic> map, String docId) {
    return SkillModel(
      id: docId,
      name: map['categoryName'] ?? '',
      subSkills: List<String>.from(map['skills'] ?? []),
    );
  }
}
