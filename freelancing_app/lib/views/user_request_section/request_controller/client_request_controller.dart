// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dartz/dartz.dart';
// import 'package:flutter/material.dart';
// import 'package:freelancing_platform/core/classes/firebase_crud.dart';
// import 'package:freelancing_platform/core/classes/status_classes.dart';
// import 'package:freelancing_platform/core/classes/user_session.dart';
// import 'package:freelancing_platform/core/constants/app_routes.dart';
// import 'package:freelancing_platform/core/constants/collections_names.dart';
// import 'package:freelancing_platform/core/utils/helper_function/validators.dart';
// import 'package:freelancing_platform/data/services/specializations_skills_service.dart';
// import 'package:freelancing_platform/models/skill_collections/new_skill_model.dart';
// import 'package:freelancing_platform/models/skill_collections/specialization_model.dart';
// import 'package:freelancing_platform/models/user_collections/admission_questions.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/core/utils/helper_function/validators.dart';
import 'package:freelancing_platform/data/services/specializations_skills_service.dart';
import 'package:freelancing_platform/models/skill_collections/specialization_model.dart';
import 'package:get/get.dart';

class ClientRequestController extends GetxController {
  var pageState = StatusClasses.isloading;
  var allSpecializations = <SpecializationModel>[];
  final formKey = GlobalKey<FormState>();
  var selectedSpecial = RxnString();
  var jobTitle = RxnString();
  var bio = RxnString();
  var clientType = RxnString();

  final SpecialSkillsService specialSkillsService = SpecialSkillsService();

  @override
  void onInit() {
    super.onInit();

    //احضار البيانات من السيرفر وتجهيزها بالمتغيرات
    Future.wait([
      fetchSpecializations(),
    ]);
  }

  Future<void> fetchSpecializations() async {
    pageState = StatusClasses.isloading;
    update();

    Either<StatusClasses, List<SpecializationModel>> response =
        await specialSkillsService.getAllSpecializations();
    response.fold((left) {
      pageState = left;
      update();
    }, (right) {
      //التخصصات الكليةالموجوده
      allSpecializations = right;

      pageState = StatusClasses.success;
      update();
    });
  }

  bool get canSubmit =>
      (jobTitle.value?.isNotEmpty ?? false) &&
      (selectedSpecial.value?.isNotEmpty ?? false) &&
      (bio.value?.isNotEmpty ?? false) &&
      (clientType.value?.isNotEmpty ?? false);

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

  /// القيمة المعروضة في القائمة المنسدلة (null إذا غير موجودة في القائمة).
  String? get specializationDropdownValue {
    final v = selectedSpecial.value;
    if (v == null || v.isEmpty) return null;
    final ok = allSpecializations.any((o) => o.name == v);
    return ok ? v : null;
  }

  Future sendRequest() async {}
}
