import 'package:get/get_rx/src/rx_types/rx_types.dart';

class SkillModel {
  final String name;
  final List<String> subSkills;
  RxBool expanded = false.obs;

  // قائمة المهارات الفرعية المختارة
  RxList<String> selectedSubSkills = <String>[].obs;
   SkillModel({
    required this.name,
    required this.subSkills,
    
  });

  factory SkillModel.fromMap(Map<String, dynamic> data) {
    return SkillModel(
      name: data['name'] ?? '',
      subSkills: List<String>.from(data['subSkills'] ?? []),
    );
  }
}
