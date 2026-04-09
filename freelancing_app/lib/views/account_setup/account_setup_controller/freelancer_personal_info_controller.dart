import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/constants/app_constant_data.dart';
import 'package:freelancing_platform/core/utils/helper_function/handle_firebase_check.dart';
import 'package:freelancing_platform/data/services/user_service.dart';
import 'package:freelancing_platform/models/user_collections/user_model.dart';
import 'package:get/get.dart';

class PersonalInfoController extends GetxController {
  final UserService _userService = Get.put<UserService>(UserService());
  final infoIsLoading = true.obs;
  final savingIsLoading = false.obs;

  // Text controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  // Reactive fields
  final countryCode = RxnString();
  final gender = RxnString();
  final year = RxnString();
  final month = RxnString();
  final day = RxnString();
  // final agreed = false.obs; //???

  // Form key
  final formKey = GlobalKey<FormState>();
  @override
  void onInit() async {
    super.onInit();
    _loadData();
  }

  Future<void> _loadData() async {
    if (!await handleFirebaseCheck()) {
      infoIsLoading.value = false;
      update();
      return;
    }

    //لازم جيب بيانات المستخدم  من قاعدة البيانات و عبي الحقول فيها
    UserModel? currentUser = await fetchUser();
    if (currentUser == null) {
      infoIsLoading.value = false;
      update();
      return;
    }

    firstNameController.text = currentUser.fname ;
    lastNameController.text = currentUser.lname;
  
    gender.value = currentUser.gender;
    countryCode.value = currentUser.countryCode;
    if (currentUser.birthDate != null) {
      year.value = currentUser.birthDate!.year.toString();
      month.value = currentUser.birthDate!.month.toString();
      day.value = currentUser.birthDate!.day.toString();
    }
    infoIsLoading.value = false;
    update();
  }

  //بدي تابعين تابع لجلب بيانات المستخدم وتابع لحفظ البيانات لما نضغط زر الحفظ

  Future<UserModel?> fetchUser() async {
    try {
      UserModel? userModel =
          await _userService.fetchUserData(AppConstantData.uid!);
      //لو المستخدم غير موجود
      if (userModel == null) {
        Get.snackbar("خطأ", "المستخدم غير موجود");
        return null;
      }

      return userModel;
    } catch (e) {
      //لو صار خطأ بتنفيذ الاستعلام
      Get.snackbar("خطأ", "فشل جلب بيانات المستخدم");
      return null;
    }
  }

  Future<void> saveUserPersonalData() async {
    try {
      //لو مافي نت او مستخدم ما بكمل بالتابع
      savingIsLoading.value = true;
      update();
      final canProgress = await handleFirebaseCheck();
      if (!canProgress) {
        savingIsLoading.value = false;
        update();
        return;
      }

      if (isFormValid) {
        if (!formKey.currentState!.validate()) {
          Get.snackbar(
              "! لم يتم حفظ البيانات", "البيانات التي ادخلتها غير صالحة");
          savingIsLoading.value = false;
          update();
          return;
        }
        //حفظ بيانات المستخدم بقاعدة البيانات
        int? yearInt = year.value != null ? int.tryParse(year.value!) : null;
        int? monthInt = month.value != null ? int.tryParse(month.value!) : null;
        int? dayInt = day.value != null ? int.tryParse(day.value!) : null;
        if (yearInt == null || monthInt == null || dayInt == null) {
          Get.snackbar("خطأ", "حقول تاريخ الميلاد يجب ان تكون ارقام");
          savingIsLoading.value = false;
          update();
          return;
        }

        savingIsLoading.value = true;
        update();
        Map<String, dynamic> newDataMap = {
          "fname": firstNameController.text,
          "lname": lastNameController.text,
          "gender": gender.value,
          "countryCode": countryCode.value,
          "birthDate": Timestamp.fromDate(DateTime(yearInt, monthInt, dayInt)),
        };

        await _userService.updateUserData(newDataMap, AppConstantData.uid!);
        savingIsLoading.value = false;
        update();
        Get.snackbar("تم الحفظ", "تم تعديل البيانات بنجاح");
      } else {
        savingIsLoading.value = false;
        update();
        Get.snackbar("خطأ في البيانات", "يرجى تعبئة جميع الحقول بشكل صحيح");
      }
    } catch (e) {
      savingIsLoading.value = false;
      update();
      Get.snackbar("خطأ في تحديث البيانات", "حدث خطأ في السيرفر $e");
    }
  }

  // Reactive validation
  bool get isFormValid {
    return firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        gender.value != null &&
        countryCode.value != null &&
        year.value != null &&
        month.value != null &&
        day.value != null;
    // && agreed.value;
  }

  // Trigger UI update
  void refreshForm() {
    update(); // For GetBuilder
  }

  //  changeCountry(CountryCode? cc) {
  //   countryCode.value = cc!.code;
  //   update(); // For GetBuilder
  // }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.onClose();
  }
}
