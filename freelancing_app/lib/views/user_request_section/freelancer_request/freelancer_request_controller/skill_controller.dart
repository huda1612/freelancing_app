import 'package:freelancing_platform/models/skill_collections/skill_model.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class SkillController extends GetxController {
  RxList<SkillModel> skills = <SkillModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    //fetchSkills();
skills.value = [
    SkillModel(
      name: "Programming",
      subSkills: ["Dart", "Flutter", "Firebase"],
    ),
    SkillModel(
      name: "Design",
      subSkills: ["UI", "UX", "Figma"],
    ),
  ];
  }

  Future<void> fetchSkills() async {
    final snapshot = await FirebaseFirestore.instance.collection('skills').get();

    skills.value = snapshot.docs
        .map((doc) => SkillModel.fromMap(doc.data()))
        .toList();
  }

  void toggleSkill(int index) {
    skills[index].expanded = !skills[index].expanded;
    skills.refresh();
  }

  /// اختيار / إلغاء اختيار مهارة فرعية
  void toggleSubSkill(int skillIndex, String subSkill) {
    final skill = skills[skillIndex];

    if (skill.selectedSubSkills.contains(subSkill)) {
      skill.selectedSubSkills.remove(subSkill);
    } else {
      skill.selectedSubSkills.add(subSkill);
    }

    skills.refresh();
  }
}
