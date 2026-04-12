import 'package:freelancing_platform/models/skill_collections/skill_model.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class SkillController extends GetxController {
  RxList<SkillModel> skills = <SkillModel>[].obs;
 var specialization = ''.obs;
  var jobTitle = ''.obs;
  var bio = ''.obs;
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
  skills[index].expanded.value = !skills[index].expanded.value;
  skills.refresh();
}
void toggleSubSkill(int index, String subSkill) {
  final skill = skills[index];

  if (skill.selectedSubSkills.contains(subSkill)) {
    skill.selectedSubSkills.remove(subSkill);
  } else {
    skill.selectedSubSkills.add(subSkill);
  }

  skills.refresh();
}
bool get hasSelectedSkills =>
      skills.any((s) => s.selectedSubSkills.isNotEmpty);
}