import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/core/utils/helper_function/validators.dart';
import 'package:freelancing_platform/data/services/specializations_skills_service.dart';
import 'package:freelancing_platform/models/skill_collections/new_skill_model.dart';
import 'package:freelancing_platform/models/skill_collections/specialization_model.dart';
import 'package:get/get.dart';

class FreelancerRequestController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final SpecialSkillsService specialSkillsService = SpecialSkillsService();

  final allSpecializations = <SpecializationModel>[].obs;

  //حالة الصفحه قبل ما يدخلها
  var pageState = StatusClasses.isloading.obs;

  //معلومات الحساب
  var selectedSpecial = RxnString();
  var jobTitle = RxnString();
  var bio = RxnString();

  //****************البحث****************
  //المهارات الكليه مشان يبحث فيها
  RxList<String> totalSkills = <String>[].obs;
  //نص البحث
  var searchQuery = "".obs;
  //نتائج البحث
  RxList<String> filteredSubSkills = <String>[].obs;
  //****************************************

// المهارات المختارة
  RxList<SubspecialModel> sugustSubSpecials = <SubspecialModel>[].obs;
  RxList<String> selectedSkills = <String>[].obs;

  @override
  void onInit() {
    super.onInit();

    //احضار البيانات من السيرفر وتجهيزها بالمتغيرات
    Future.wait([
      fetchSpecializations(),
    ]);
    // fetchQuestions()]);
  }

  Future<void> fetchSpecializations() async {
    pageState.value = StatusClasses.isloading;

    Either<StatusClasses, List<SpecializationModel>> response =
        await specialSkillsService.getAllSpecializations();
    response.fold((left) {
      print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" + left.type);

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
      print("TOTAL SKILLS AFTER LOAD: ${totalSkills.length}");
      pageState.value = StatusClasses.success;
    });
  }

  //هلأ مشان المهارات المقترحه تنعرض من التخصصات الفرعيه من التخصص اللي هو اختاره
  void onSpecialChange(String? val) {
    selectedSpecial.value = val;
    //بدنا نغير المهارات المقترحه حسب التخصص المختار
    sugustSubSpecials.value = allSpecializations
        .where((s) => s.name == val)
        .toList()
        .first
        .subspecializations;
  }

  /// القيمة المعروضة في القائمة المنسدلة (null إذا غير موجودة في القائمة).
  String? get specializationDropdownValue {
    final v = selectedSpecial.value;
    if (v == null || v.isEmpty) return null;
    final ok = allSpecializations.any((o) => o.name == v);
    return ok ? v : null;
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

  void toggleSelectSubSkill(String sub) {
    if (selectedSkills.contains(sub)) {
      selectedSkills.remove(sub);
    } else {
      selectedSkills.add(sub);
    }
    _syncSelectedIntoSkillModels(sub);
    sugustSubSpecials.refresh();
  }

  /// يبقي نتائج البحث و SkillTile متسقة مع قائمة المهارات المختارة.
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

  void toggleSkill(int index) {
    sugustSubSpecials[index].expanded.value =
        !sugustSubSpecials[index].expanded.value;
    sugustSubSpecials.refresh();
  }

  void toggleSubSkill(int index, String subSkill) {
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

  void firstNextBottonOnPressed() {
    if (!formKey.currentState!.validate()) {
      var jobTitleError = Validators.validateJobTitle(jobTitle.value);
      var bioError = Validators.validateBio(bio.value);
      final msg = jobTitleError ?? bioError ?? 'يرجى تعبئة الحقول بشكل صحيح';
      Get.snackbar('خطأ', msg);
      return;
    }

    //   // 3) حفظ البيانات
    //   //  controller.saveProfileInfo();

    //   // 4) الانتقال للخطوة التالية
    Get.toNamed(AppRoutes.entryTest);
    // }
  }

  bool get canSubmit =>
      (jobTitle.value?.isNotEmpty ?? false) &&
      (selectedSpecial.value?.isNotEmpty ?? false) &&
      (bio.value?.isNotEmpty ?? false) &&
      _hasSelectedSkills;

  bool get _hasSelectedSkills =>
      selectedSkills.isNotEmpty ||
      sugustSubSpecials.any((s) => s.selectedSubSkills.isNotEmpty);

  Future sendRequest() async {}

  //**********************************************************توابع اسئلة الاختبار*********************************************************

  // Future<void> fetchQuestions() async {
  //   testPageState = StatusClasses.isloading;
  //   update();
  //   final query = FirebaseFirestore.instance
  //       .collection(CollectionsNames.admission_questions)
  //       .where("targetRole", isEqualTo: UserSession.role);
  //   final response = await FirebaseCrud.runGetQuery(
  //       query: query,
  //       fromMap: (data, id) => AdmissionQuestionModel.fromMap(data, id));
  //   response.fold((errorState) {
  //     testPageState = errorState;
  //     update();
  //   }, (data) {
  //     questions = data;
  //     testPageState = StatusClasses.success;
  //     update();
  //   });
  // }

  // void istestCorrect() async {
  //   for (int i = 0; i < questions.length; i++) {
  //     final selectedAnswer = answers[i];

  //     // إذا ما جاوب أصلاً أو الجواب غلط
  //     if (selectedAnswer == null ||
  //         selectedAnswer != questions[i].correctAnswerIndex) {
  //       Get.snackbar("اجابات خاطئة",
  //           "يوجد لديك اجابات خاطئة لايمكنك الاستمرار ، الرجاء تصحيح جميع الاجابات");
  //       return;
  //     }
  //   }
  //   //هون لازم يتم ارسال الطلب والانتقال لصفحة تم التقديم وتعديل الحاله للمستخدم
  //   await sendRequest();
  //   Get.offAllNamed(AppRoutes.pending);
  //   return; // كل الإجابات صحيح
  // }

  // void selectAnswer(int questionIndex, int answerIndex) {
  //   answers[questionIndex] = answerIndex;
  //   update(); // GetX
  // }
  //************************************************************************************************************************* */
}
