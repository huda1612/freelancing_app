import 'package:dartz/dartz.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/data/services/specializations_skills_service.dart';
import 'package:freelancing_platform/models/skill_collections/new_skill_model.dart';
import 'package:freelancing_platform/models/skill_collections/specialization_model.dart';
import 'package:get/get.dart';

class SkillsSelectionController extends GetxController {
  var pageState = StatusClasses.isloading.obs;
  var submitLoading = false.obs;

  final allSpecializations = <SpecializationModel>[].obs;
  final SpecialSkillsService specialSkillsService = SpecialSkillsService();
  String _specailzation = '';
  RxList<SubspecialModel> sugustSubSpecials = <SubspecialModel>[].obs;
  RxList<String> selectedSkills = <String>[].obs;
  //المهارات الكليه مشان يبحث فيها
  RxList<String> totalSkills = <String>[].obs;
  //نص البحث
  var searchQuery = "".obs;
  //نتائج البحث
  RxList<String> filteredSubSkills = <String>[].obs;

  @override
  void onInit() async {
    super.onInit();

    await fetchPageData();
  }

  void onEnd() {
    Get.back(result: selectedSkills.toList());
  }

  Future<void> fetchPageData() async {
    pageState.value = StatusClasses.isloading;

    final arg = Get.arguments;
    selectedSkills.value = List<String>.from(arg['oldSkills'] ?? []);
    // selectedSkills.value = arg['oldSkills'] ?? [];
    _specailzation = arg['specailization'] ?? '';

    Either<StatusClasses, List<SpecializationModel>> response =
        await specialSkillsService.getAllSpecializations();
    response.fold((left) {
      pageState.value = left;
    }, (right) {
      //التخصصات الكليةالموجوده
      allSpecializations.value = right;

      //المهارات الكليه مشان يبحث فيها
      totalSkills.value = allSpecializations
          .expand((s) => s.subspecializations)
          .expand((sub) => sub.skills)
          .toSet()
          .toList();

      //المهارات المقترحه
      final found =
          allSpecializations.where((s) => s.slug == _specailzation).toList();
      if (found.isNotEmpty) {
        sugustSubSpecials.value = found.first.subspecializations;
      } else {
        sugustSubSpecials.clear();
      }
      for (SubspecialModel subSpecial in sugustSubSpecials) {
        subSpecial.selectedSubSkills.value = selectedSkills.toList();
        // for (String skill in subSpecial.skills) {
        //   if(slected)
        // }
      }

      // print("TOTAL SKILLS AFTER LOAD: ${totalSkills.length}");
      pageState.value = StatusClasses.success;
    });
  }

  void toggleSelectSkill(String sub) {
    if (selectedSkills.contains(sub)) {
      selectedSkills.remove(sub);
    } else {
      selectedSkills.add(sub);
    }
    _syncSelectedIntoSkillModels(sub);
    sugustSubSpecials.refresh();
  }

  void _syncSelectedIntoSkillModels(String sub) {
    final isOn = selectedSkills.contains(sub);
    for (final subSpecial in sugustSubSpecials) {
      if (!subSpecial.skills.contains(sub)) continue;
      if (isOn) {
        if (!subSpecial.selectedSubSkills.contains(sub)) {
          subSpecial.selectedSubSkills.add(sub);
        }
      } else {
        subSpecial.selectedSubSkills.remove(sub);
      }
    }
  }

  void onSearchChanged(String value) {
    //نسند القيمه لمتغير البحث
    searchQuery.value = value;
    //بحال كان البحث فاضي بمسح النتائج (وبترجع بتطلع الاقتراحات)
    if (value.trim().isEmpty) {
      filteredSubSkills.clear();
      return;
    }
    //تجهيز متغيرات البحث
    final lower = value.toLowerCase();
    final matches = <String>[];

    //البحث بصير داخل المهارات الكليه ما بس للتخصص اللي اختاره
    for (final skill in totalSkills) {
      if (skill.toLowerCase().contains(lower) && !matches.contains(skill)) {
        matches.add(skill);
      }
    }

    filteredSubSkills.assignAll(matches);
  }

  void toggleSubspecial(int index) {
    sugustSubSpecials[index].expanded.value =
        !sugustSubSpecials[index].expanded.value;
    sugustSubSpecials.refresh();
  }

  void toggleSkill(int index, String subSkill) {
    final skill = sugustSubSpecials[index];

    if (skill.selectedSubSkills.contains(subSkill)) {
      skill.selectedSubSkills.remove(subSkill);
      selectedSkills.remove(subSkill);
    } else {
      skill.selectedSubSkills.add(subSkill);
      if (!selectedSkills.contains(subSkill)) {
        selectedSkills.add(subSkill);
      }
    }

    sugustSubSpecials.refresh();
  }
}
