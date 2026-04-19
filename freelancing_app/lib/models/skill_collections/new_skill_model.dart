import 'package:get/get_rx/src/rx_types/rx_types.dart';

class SubspecialModel {
  final String name;
  final List<String> skills;
  RxBool expanded = false.obs;

  // قائمة المهارات الفرعية المختارة
  RxList<String> selectedSubSkills = <String>[].obs;

  SubspecialModel({
    required this.name,
    this.skills = const [],
  });

  factory SubspecialModel.fromMap(Map<String, dynamic> map ) {
    return SubspecialModel(
      name: map['name'] ?? '',
      skills: List<String>.from(map['skills'] ?? []),
    );
  }
}
