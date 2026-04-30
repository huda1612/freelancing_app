import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/classes/user_session.dart';
import 'package:freelancing_platform/core/constants/app_image_cloud.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/core/constants/user_roles.dart';
import 'package:freelancing_platform/core/constants/user_status.dart';
import 'package:freelancing_platform/core/services/image_service.dart';
import 'package:freelancing_platform/core/utils/helper_function/validators.dart';
import 'package:freelancing_platform/data/services/certificate_service.dart';
import 'package:freelancing_platform/data/services/request_service.dart';
import 'package:freelancing_platform/data/services/specializations_skills_service.dart';
import 'package:freelancing_platform/data/services/user_service.dart';
import 'package:freelancing_platform/data/services/work_sample_service.dart';
import 'package:freelancing_platform/models/skill_collections/new_skill_model.dart';
import 'package:freelancing_platform/models/skill_collections/specialization_model.dart';
import 'package:freelancing_platform/models/user_collections/certificate_model.dart';
import 'package:freelancing_platform/models/user_collections/user_request_snapshot_model.dart';
import 'package:freelancing_platform/models/user_collections/users_requests_model.dart';
import 'package:freelancing_platform/models/user_collections/worksamples_model.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FreelancerRequestController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final SpecialSkillsService specialSkillsService = SpecialSkillsService();

  final allSpecializations = <SpecializationModel>[].obs;

  //حالة الصفحه قبل ما يدخلها
  var pageState = StatusClasses.isloading.obs;
  var fetchSpecialState = StatusClasses.isloading.obs;
  var fetchOldRequestState = StatusClasses.isloading.obs;

  //معلومات الحساب
  //التخصص :
  var selectedSpecial = RxnString();
  // var selectedSpecial = Rxn<SpecializationSnapshot>();
  //هدول بدهم شيل لو رجعت على القائمه الثابته***********************
  // var customSpecial = RxnString();
  // var elseSpecial = false.obs;

  //ليجيب التخصص الصح
  // String? get finalSpecialization {
  //   if (elseSpecial.value == true) {
  //     return customSpecial.value;
  //   }
  //   return selectedSpecial.value;
  // }
  //***************************************************************** */

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

    // احضار البيانات من السيرفر وتجهيزها بالمتغيرات
    fetchPageData().catchError((error, stack) {
      print('fetchPageData error: $error');
      print(stack);
    });
  }

  //تابع ارسال الطلب
  Future<void> sendRequest() async {
    final RequestService requestService = RequestService();
    final UserService userService = UserService();
    final WorkSampleService workSampleService = WorkSampleService();
    final CertificateService certificateService = CertificateService();

    if (UserSession.uid == null) {
      Get.snackbar("unathorized", "لا يمكنك ارسال طلب بدون تسجيل الدخول !");
      Get.offAllNamed(AppRoutes.login);
      return;
    }

    //منعمل السناب شوت للطلب
    final List<WorksampleModel> works = _getWorkSampelsModleList();
    final List<CertificateModel> certificates = _getCertificatesList();

    final selected = allSpecializations.firstWhereOrNull(
      (s) => s.slug == selectedSpecial.value,
    );
    if (selected == null) {
      Get.snackbar("خطأ", "التخصص غير موجود");
      return;
    }

    final UserRequestSnapshotModel snapshot = UserRequestSnapshotModel(
        // specialization: selectedSpecial.value!,
        specialization: SpecializationSnapshot(
          slug: selected.slug,
          name: selected.name,
        ),
        jobTitle: jobTitle.value!,
        bio: bio.value!,
        skills: selectedSkills,
        workSamples: works,
        certificates: certificates);

    final response = await requestService.addUserRequest(
        uId: UserSession.uid!,
        userType: UserRole.freelancer,
        snapshot: snapshot);
    if (response == StatusClasses.success) {
      Get.snackbar("نجاح", "لقد تم إرسال طلبك بنجاح");

      Map<String, dynamic> newUserData = {
        "status": UserStatus.pending,
        // "specialization": selectedSpecial.value!,
        "specialization": {
          "slug": selected.slug,
          "name": selected.name,
        },
        "bio": bio.value!,
        "skills": selectedSkills,
      };
      final userResponse =
          await userService.updateUserData2(newUserData, UserSession.uid!);
      if (userResponse != StatusClasses.success) {
        Get.snackbar("خطأ",
            userResponse.message ?? "حدث خطأ ما عند تحديث بيانات المستخدم");
      }
      //اسا لازم ضيف الاعمال لمجموعة اعماله والشهادات لمجموعه شهاداته  للمستخدم
      for (WorksampleModel w in works) {
        final workResponse = await workSampleService.addWorkSample(
            uid: UserSession.uid!, workSample: w);
        if (workResponse != StatusClasses.success) {
          Get.snackbar(
              "خطأ", workResponse.message ?? "حدث خطأ ما عند اضافة الاعمال");
        }
      }
      for (CertificateModel c in certificates) {
        final certificateResponse = await certificateService.addCertificate(
            uid: UserSession.uid!, certificate: c);
        if (certificateResponse != StatusClasses.success) {
          Get.snackbar("خطأ",
              certificateResponse.message ?? "حدث خطأ ما عند اضافة شهادة");
        }
      }

      Get.offAllNamed(AppRoutes.pending);
      return;
    } else {
      Get.snackbar("خطأ", response.message ?? "حدث خطأ ما");
    }
  }

  List<WorksampleModel> _getWorkSampelsModleList() {
    List<WorksampleModel> list = [];
    for (int i = 0; i < workItems.length; i++) {
      if (!validateWork(i)) {
        continue;
      }
      // for (Map<String, Object?> map in workItems) {
      String title = workItems[i]['title'] as String;
      String description = workItems[i]['description'] as String;
      String image = workItems[i]['image'] as String;

      list.add(WorksampleModel(
        title: title,
        description: description,
        imageUrl: image,
      ));
    }
    return list;
  }

  List<CertificateModel> _getCertificatesList() {
    List<CertificateModel> list = [];
    for (int i = 0; i < certItems.length; i++) {
      if (!validateCertificate(i)) {
        continue;
      }
      String title = certItems[i]['title'] as String;
      String description = certItems[i]['description'] as String;
      String image = certItems[i]['image'] as String;
      Timestamp? date = certItems[i]['date'] as Timestamp?;
      String? url = certItems[i]['url'] as String?;
      String? id = certItems[i]['id'] as String?;
      List<String>? skills = certItems[i]['skills'] as List<String>?;
      String? source = certItems[i]['source'] as String?;

      list.add(CertificateModel(
          title: title,
          description: description,
          imageURL: image,
          source: source,
          date: date,
          credentialURL: url,
          credentialID: id,
          skills: skills ?? []));
    }
    return list;
  }

  Future<void> fetchPageData() async {
    pageState.value = StatusClasses.isloading;
    await Future.wait([
      fetchOldRequestData(),
      fetchSpecializations(),
    ]);

    if (fetchOldRequestState != StatusClasses.success) {
      pageState.value = fetchOldRequestState.value;
      return;
    }
    if (fetchSpecialState != StatusClasses.success) {
      pageState.value = fetchSpecialState.value;
      return;
    }
    //مشان الاقتراحات لو كان اصلا عنده تخصص
    if (selectedSpecial.value != null && selectedSpecial.value!.isNotEmpty) {
      final found = allSpecializations
          .where((s) => s.slug == selectedSpecial.value)
          .toList();
      if (found.isNotEmpty) {
        sugustSubSpecials.value = found.first.subspecializations;
      } else {
        sugustSubSpecials.clear();
      }
    }
    pageState.value = StatusClasses.success;
  }

  Future<void> fetchOldRequestData() async {
    if (UserSession.uid == null) {
      fetchOldRequestState.value = StatusClasses.unauthorized;
      Get.offAllNamed(AppRoutes.login);
      Get.snackbar(
          fetchOldRequestState.value.type, fetchOldRequestState.value.message!);
      return;
    }

    fetchOldRequestState.value = StatusClasses.isloading;
    RequestService requestService = RequestService();

    Either<StatusClasses, UserRequestModel> response =
        await requestService.fetchRequest(UserSession.uid!);

    response.fold((left) {
      if (left == StatusClasses.notFound) {
        //بحال ما عنده طلب قديم عادي
        fetchOldRequestState.value = StatusClasses.success;
        return;
      }
      fetchOldRequestState.value = left;
    }, (oldRequest) {
      selectedSpecial.value = oldRequest.snapshot.specialization?.slug;
      jobTitle.value = oldRequest.snapshot.jobTitle;
      bio.value = oldRequest.snapshot.bio;

      selectedSkills.value = oldRequest.snapshot.skills ?? [];

      workItems.value = oldRequest.snapshot.workSamples
          .map((w) => {
                "title": w.title,
                "description": w.description,
                "image": w.imageUrl,
                "localImage": null,
                "valid": true,
                "uploading": false,
              })
          .toList();
      certItems.value = oldRequest.snapshot.certificates
          .map((c) => {
                "image": c.imageURL,
                "localImage": null,
                "uploading": false,
                "title": c.title,
                "description": c.description,
                "date": c.date,
                "source": c.source,
                "url": c.credentialURL,
                "id": c.credentialID,
                "skills": c.skills,
                "expanded": false,
                "valid": true,
              })
          .toList();

      fetchOldRequestState.value = StatusClasses.success;
    });
  }

  Future<void> fetchSpecializations() async {
    fetchSpecialState.value = StatusClasses.isloading;

    Either<StatusClasses, List<SpecializationModel>> response =
        await specialSkillsService.getAllSpecializations();
    response.fold((left) {
      fetchSpecialState.value = left;
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
      fetchSpecialState.value = StatusClasses.success;
    });
  }

  //هلأ مشان المهارات المقترحه تنعرض من التخصصات الفرعيه من التخصص اللي هو اختاره
  void onSpecialChange(String? slug) {
    //بدنا نغير المهارات المقترحه حسب التخصص المختار
    if (slug == null || slug.isEmpty) {
      selectedSpecial.value = null;
      sugustSubSpecials.clear();
      return;
    }
    selectedSpecial.value = slug;

    final found = allSpecializations.where((s) => s.slug == slug).toList();
    if (found.isNotEmpty) {
      sugustSubSpecials.value = found.first.subspecializations;
    } else {
      sugustSubSpecials.clear();
    }

    // if (val == "else") {
    //   elseSpecial.value = true;
    //   // customSpecial.value = null;
    // } else {
    //   elseSpecial.value = false;
    //   customSpecial.value = null;
    // }
  }

  /// القيمة المعروضة في القائمة المنسدلة (null إذا غير موجودة في القائمة).
  String? get specializationDropdownValue {
    final v = selectedSpecial.value;
    if (v == null || v.isEmpty) return null;
    final ok = allSpecializations.any((o) => o.slug == v);
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

// إذا الـ controller persistent (ما ينحذف بين الصفحات):

// ➡️ رح يحتفظ بـ formKey قديم مربوط بـ widget اختفى
// وهذا بحد ذاته يسبب:

// currentState == null
  void firstNextBottonOnPressed() {
    var specializationError =
        Validators.validateSpecialization(selectedSpecial.value);
    var jobTitleError = Validators.validateJobTitle(jobTitle.value);
    var bioError = Validators.validateBio(bio.value);
    if (jobTitleError != null ||
        bioError != null ||
        specializationError != null) {
      final msg = specializationError ??
          jobTitleError ??
          bioError ??
          'يرجى تعبئة الحقول بشكل صحيح';
      Get.snackbar('خطأ', msg);
      return;
    }

    // الانتقال للخطوة التالية
    Get.toNamed(AppRoutes.freelancerWorkAndCertificates);
  }

  bool get canSubmit =>
      (jobTitle.value?.isNotEmpty ?? false) &&
      (selectedSpecial.value?.isNotEmpty ?? false) &&
      (bio.value?.isNotEmpty ?? false) &&
      _hasSelectedSkills;

  bool get _hasSelectedSkills =>
      selectedSkills.isNotEmpty ||
      sugustSubSpecials.any((s) => s.selectedSubSkills.isNotEmpty);

  //**********************************************************توابع صفحة الاعمال و الشهادات***********************************
  RxList<Map<String, Object?>> workItems = [
    {
      "title": "",
      "description": "",
      "image": "",
      "localImage":
          null, //بس مشان اعرضله ياها مباشره ما يستنى رفع الصوره فبخزن مسارها بالجهاز
      "valid": false,
      "uploading": false,
    },
    {
      "title": "",
      "description": "",
      "image": "",
      "localImage": null,
      "valid": false,
      "uploading": false,
    },
  ].obs;

//الشهادات
  RxList<Map<String, Object?>> certItems = [
    {
      "image": "",
      "localImage": null,
      "uploading": false,
      "title": "",
      "description": "",
      "date": null,
      "source": "",
      "url": "",
      "id": "",
      "skills": <String>[],
      "expanded": false,
      "valid": false,
    },
    {
      "image": "",
      "localImage": null,
      "uploading": false,
      "title": "",
      "description": "",
      "date": null,
      "source": "",
      "url": "",
      "id": "",
      "skills": <String>[],
      "expanded": false,
      "valid": false,
    },
  ].obs;

  // ---------------- إضافة عمل ----------------
  void addWorkItem() {
    workItems.add(<String, Object?>{
      "image": "",
      "localImage": null,
      "title": "",
      "description": "",
      "valid": false,
      "uploading": false,
    });
  }

  // ---------------- حذف عمل ----------------
  void removeWorkItem(int index) {
    workItems.removeAt(index);
  }

  // ---------------- إضافة شهادة ----------------
  void addCertificateItem() {
    certItems.add(<String, Object?>{
      "image": "",
      "localImage": null,
      "uploading": false,
      "title": "",
      "description": "",
      "date": null,
      "source": "",
      "url": "",
      "id": "",
      "skills": <String>[],
      "expanded": false,
      "valid": false,
    });
  }

  // ---------------- حذف شهادة ----------------
  void removeCertificateItem(int index) {
    certItems.removeAt(index);
  }

  // ---------------- توسيع الشهادة ----------------
  void toggleExpand(int index) {
    final current = certItems[index]["expanded"] == true;
    certItems[index]["expanded"] = !current;
    certItems.refresh();
  }

  // ---------------- اختيار مهارة ----------------
  void toggleRelatedSkill(int certIndex, String skill) {
    final skills = (certItems[certIndex]["skills"] as List).cast<String>();

    if (skills.contains(skill)) {
      skills.remove(skill);
    } else {
      skills.add(skill);
    }
    certItems[certIndex]["skills"] = skills;
    certItems.refresh();
  }

  // ---------------- رفع صورة Firebase ----------------
  //هالتابع برد الصوره بالرابط
  Future<void> pickAndUploadImage(int index, String typeImage) async {
    File? file = await ImageService.pickImage();
    if (file == null) {
      Get.snackbar("تنبيه", "لم يتم اختيار صورة");
      return;
    }
    if (typeImage == "work") {
      // 🔥 عرض الصورة مباشرة
      workItems[index]["localImage"] = file;
      workItems[index]["uploading"] = true;
      workItems.refresh();

      //رفع الصورة
      final result = await ImageService.uploadImage(
          AppImagePreset.workSamplesPreset, file);
      result.fold(
        (error) {
          workItems[index]["uploading"] = false;
          workItems.refresh();
        },
        (url) {
          workItems[index]["image"] = url;
          workItems[index]["localImage"] = null;
          workItems[index]["uploading"] = false;
          validateWork(index);
          workItems.refresh();
        },
      );
    } else {
      // 🔥 عرض الصورة مباشرة
      certItems[index]["localImage"] = file;
      certItems[index]["uploading"] = true;
      certItems.refresh();

      //رفع الصورة
      final result = await ImageService.uploadImage(
          AppImagePreset.certificatePreset, file);
      result.fold(
        (error) {
          certItems[index]["uploading"] = false;
          certItems.refresh();
        },
        (url) {
          certItems[index]["image"] = url;
          certItems[index]["localImage"] = null;
          certItems[index]["uploading"] = false;
          validateCertificate(index);
          certItems.refresh();
        },
      );
    }
  }

  // ---------------- Validation ----------------
  bool validateWork(int index) {
    final item = workItems[index];
    item["valid"] = Validators.validateWork(item);
    workItems.refresh();
    return item["valid"] as bool? ?? false;
  }

  bool validateCertificate(int index) {
    final item = certItems[index];
    item["valid"] = Validators.validateCertificate(item);
    certItems.refresh();
    return item["valid"] as bool? ?? false;
  }

  //************************************************************************************************************************* */
}
