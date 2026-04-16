// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/utils/helper_function/validators.dart';
import 'package:freelancing_platform/models/skill_collections/skill_model.dart';
import 'package:get/get.dart';

class FreelancerAccountInfoController extends GetxController {
  final formKey = GlobalKey<FormState>();

  RxList<SkillModel> skills = <SkillModel>[].obs;
  var specialization = RxnString();
  var jobTitle = RxnString();
  var bio = RxnString();
  @override
  void onInit() {
    super.onInit();
    //fetchSkills();
    skills.value = [
      SkillModel(
        id: '1',
        name: "Programming",
        subSkills: ["Dart", "Flutter", "Firebase"],
      ),
      SkillModel(
        id: '2',
        name: "Design",
        subSkills: ["UI", "UX", "Figma"],
      ),
    ];
  }

  // Future<void> fetchSkills() async {
  //   final snapshot =
  //       await FirebaseFirestore.instance.collection('skills').get();

  //   skills.value =
  //       snapshot.docs.map((doc) => SkillModel.fromMap(doc.data(),)).toList();
  // }

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

  void nextBottonOnPressed() {
    if (!formKey.currentState!.validate()) {
      var specializationError =
          Validators.validateSpecialization(specialization.value);
      var jobTitleError = Validators.validateJobTitle(jobTitle.value);
      var bioError = Validators.validateBio(bio.value);
      Get.snackbar("خطأ", specializationError ?? jobTitleError ?? bioError!);
      return;
    }

    //   // 3) حفظ البيانات
    //   //  controller.saveProfileInfo();

    //   // 4) الانتقال للخطوة التالية
    //   // Get.to(NextScreen());
    // }
  }

  bool get canSubmit =>
      (jobTitle.value?.isNotEmpty ?? false) &&
      (specialization.value?.isNotEmpty ?? false) &&
      (bio.value?.isNotEmpty ?? false) &&
      _hasSelectedSkills;

  bool get _hasSelectedSkills =>
      skills.any((s) => s.selectedSubSkills.isNotEmpty);
}
