import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/classes/user_session.dart';
import 'package:freelancing_platform/core/constants/app_image_preset.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/core/constants/user_roles.dart';
import 'package:freelancing_platform/core/constants/user_status.dart';
import 'package:freelancing_platform/core/services/image_service.dart';
import 'package:freelancing_platform/core/utils/helper_function/validators.dart';
import 'package:freelancing_platform/data/services/request_service.dart';
import 'package:freelancing_platform/data/services/specializations_skills_service.dart';
import 'package:freelancing_platform/data/services/user_service.dart';
import 'package:freelancing_platform/data/services/work_sample_service.dart';
import 'package:freelancing_platform/models/skill_collections/specialization_model.dart';
import 'package:freelancing_platform/models/user_collections/user_request_snapshot_model.dart';
import 'package:freelancing_platform/models/user_collections/users_requests_model.dart';
import 'package:freelancing_platform/models/user_collections/worksamples_model.dart';
import 'package:get/get.dart';

class ClientRequestController extends GetxController {
  //متغيرات الحالة
  var pageState = StatusClasses.isloading;
  // var fetchSpecialState = StatusClasses.isloading;
  // var fetchOldRequestState = StatusClasses.isloading;

  //متغيرات اول صفحة
  var allSpecializations = <SpecializationModel>[];
  final formKey = GlobalKey<FormState>();
  // var selectedSpecial = RxnString();
  var jobTitle = RxnString();
  var bio = RxnString();
  var clientType = RxnString();

  final SpecialSkillsService specialSkillsService = SpecialSkillsService();

  @override
  void onInit() async {
    super.onInit();

    //احضار البيانات من السيرفر وتجهيزها بالمتغيرات
    await Future.wait([fetchOldRequestData()]);
  }

  // Future<void> fetchPageData() async {
  //   pageState = StatusClasses.isloading;
  //   update();
  //   await fetchOldRequestData();

  //   // if (fetchOldRequestState != StatusClasses.success) {
  //   //   pageState = fetchOldRequestState;
  //   //   update();
  //   //   return;
  //   // }
  //   // if (fetchSpecialState != StatusClasses.success) {
  //   //   pageState = fetchSpecialState;
  //   //   update();
  //   //   return;
  //   // }

  //   pageState = StatusClasses.success;
  //   update();
  // }

  // Future<void> fetchSpecializations() async {
  //   fetchSpecialState = StatusClasses.isloading;
  //   // update();

  //   Either<StatusClasses, List<SpecializationModel>> response =
  //       await specialSkillsService.getAllSpecializations();
  //   response.fold((left) {
  //     fetchSpecialState = left;
  //     // update();
  //   }, (right) {
  //     //التخصصات الكليةالموجوده
  //     allSpecializations = right;

  //     fetchSpecialState = StatusClasses.success;
  //     // update();
  //   });
  // }

  Future<void> fetchOldRequestData() async {
    if (UserSession.uid == null) {
      // pageState = StatusClasses.unauthorized;
      // update();
      Get.offAllNamed(AppRoutes.login);
      Get.snackbar(pageState.type, pageState.message!);
      return;
    }

    pageState = StatusClasses.isloading;
    update();

    RequestService requestService = RequestService();

    Either<StatusClasses, UserRequestModel> response =
        await requestService.fetchRequest(UserSession.uid!);

    response.fold((left) {
      if (left == StatusClasses.notFound) {
        //بحال ما عنده طلب قديم عادي
        pageState = StatusClasses.success;
        print("not FOUND !!!!");
        update();
        return;
      }
      pageState = left;
      update();
      return;
    }, (oldRequest) {
      jobTitle.value = oldRequest.snapshot.jobTitle;
      bio.value = oldRequest.snapshot.bio;
      print("clientType :${oldRequest.snapshot.clientType}");
      clientType.value = oldRequest.snapshot.clientType;
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

      pageState = StatusClasses.success;
      update();
      return;
    });
  }

  bool get canSubmit =>
      (jobTitle.value?.isNotEmpty ?? false) &&
      // (selectedSpecial.value?.isNotEmpty ?? false) &&
      (bio.value?.isNotEmpty ?? false) &&
      (clientType.value?.isNotEmpty ?? false);

  void firstNextBottonOnPressed() {
    var clientTypeErro =
        clientType.value == null ? "يرجى اختيار نوع العميل" : null;

    if (!formKey.currentState!.validate() || clientTypeErro != null) {
      var jobTitleError = Validators.validateJobTitle(jobTitle.value);
      var bioError = Validators.validateBio(bio.value);
      final msg = jobTitleError ??
          bioError ??
          clientTypeErro ??
          'يرجى تعبئة الحقول بشكل صحيح';
      Get.snackbar('خطأ', msg);
      return;
    }

    //  الانتقال للخطوة التالية
    Get.toNamed(AppRoutes.clinetWork);
    // }
  }

  /// القيمة المعروضة في القائمة المنسدلة (null إذا غير موجودة في القائمة).
  // String? get specializationDropdownValue {
  //   final v = selectedSpecial.value;
  //   if (v == null || v.isEmpty) return null;
  //   final ok = allSpecializations.any((o) => o.slug == v);
  //   return ok ? v : null;
  // }

  Future sendRequest() async {
    final RequestService requestService = RequestService();
    final UserService userService = UserService();
    final WorkSampleService workSampleService = WorkSampleService();

    if (UserSession.uid == null) {
      Get.snackbar("unathorized", "لا يمكنك ارسال طلب بدون تسجيل الدخول !");
      Get.offAllNamed(AppRoutes.login);
      return;
    }

    //منعمل السناب شوت للطلب
    final List<WorksampleModel> works = _getWorkSampelsModleList();

    final UserRequestSnapshotModel snapshot = UserRequestSnapshotModel(
      jobTitle: jobTitle.value!,
      bio: bio.value!,
      clientType: clientType.value,
      workSamples: works,
    );

    final response = await requestService.addUserRequest(
        uId: UserSession.uid!, userType: UserRole.client, snapshot: snapshot);
    if (response == StatusClasses.success) {
      Get.snackbar("نجاح", "لقد تم إرسال طلبك بنجاح");

      //تحديث بيانات المستخدم
      Map<String, dynamic> newUserData = {
        "status": UserStatus.pending,
        "bio": bio.value!,
        "jobTitle": jobTitle.value!,
        "clientType": clientType.value
      };
      final userResponse =
          await userService.updateUserData2(newUserData, UserSession.uid!);
      if (userResponse != StatusClasses.success) {
        Get.snackbar("خطأ",
            userResponse.message ?? "حدث خطأ ما عند تحديث بيانات المستخدم");
      }
      //اضافة الاعمال
      for (WorksampleModel w in works) {
        final workResponse = await workSampleService.addWorkSample(
            uid: UserSession.uid!, workSample: w);
        if (workResponse != StatusClasses.success) {
          Get.snackbar(
              "خطأ", workResponse.message ?? "حدث خطأ ما عند اضافة الاعمال");
        }
      }
      Get.offAllNamed(AppRoutes.pending);
      return;
    } else {
      Get.snackbar("خطأ", response.message ?? "حدث خطأ ما عند ارسال الطلب");
      return;
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

  //**********************************************************توابع صفحة الاعمال ***********************************
  RxList<Map<String, Object?>> workItems = [
    {
      "title": "",
      "description": "",
      "image": "",
      //بس مشان اعرضله ياها مباشره ما يستنى رفع الصوره فبخزن مسارها بالجهاز
      "localImage": null,
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

  Future<void> pickAndUploadImage(int index, String typeImage) async {
    File? file = await ImageService.pickImage();
    if (file == null) {
      Get.snackbar("تنبيه", "لم يتم اختيار صورة");
      return;
    }

    // 🔥 عرض الصورة مباشرة
    workItems[index]["localImage"] = file;
    workItems[index]["uploading"] = true;
    workItems.refresh();

    //رفع الصورة
    final result =
        await ImageService.uploadImage(AppImagePreset.workSamplesPreset, file);
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
  }

  // ---------------- Validation ----------------
  bool validateWork(int index) {
    final item = workItems[index];
    item["valid"] = Validators.validateWork(item);
    workItems.refresh();
    return item["valid"] as bool? ?? false;
  }
}
