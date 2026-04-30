import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/classes/user_session.dart';
import 'package:freelancing_platform/core/constants/collections_names.dart';
import 'package:freelancing_platform/core/utils/helper_function/handle_firebase_check.dart';
import 'package:freelancing_platform/core/utils/helper_function/validators.dart';
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
  final usernameController = TextEditingController();
  String oldUsername = '';

  final usernameError = RxnString();
  Timer? _timer;

  // Reactive fields
  final countryCode = RxnString();
  final gender = RxnString();
  final year = RxnString();
  final month = RxnString();
  final day = RxnString();

  final isErrorOccure = false.obs;

  // Form key
  final formKey = GlobalKey<FormState>();
  @override
  void onInit() async {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    infoIsLoading.value = true;
    isErrorOccure.value = false;
    update();
    if (!await handleFirebaseCheck()) {
      infoIsLoading.value = false;
      isErrorOccure.value = true;
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

    firstNameController.text = currentUser.fname;
    lastNameController.text = currentUser.lname;
    usernameController.text = currentUser.username;
    oldUsername = currentUser.username;

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
      UserModel? userModel = await _userService.fetchUserData(UserSession.uid!);
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
        final checkusername =
            await checkUsername(usernameController.text, true);
        if (checkusername != null) {
          Get.snackbar("خطأ", "اسم المستخدم مستخدم مسبقا");
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
          "username": usernameController.text,
          "gender": gender.value,
          "countryCode": countryCode.value,
          "birthDate": Timestamp.fromDate(DateTime(yearInt, monthInt, dayInt)),
        };

        await _userService.updateUserData(newDataMap, UserSession.uid!);
        if (oldUsername != usernameController.text) {
          await _userService.updateUsernameCollection(
              usernameController.text, oldUsername);
        }
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

  Future<String?> checkUsername(String value, bool afterSave) async {
    if (!afterSave) {
      //لان بتسجيل الدخول في تحقق من هالشي اصلا مافي داعي استخدمه هون بوقتها بس بعد التغيير للحقل بستخدمه
      if (Validators.username(value) != null) {
        return Validators.username(value);
      }
    }
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final doc =
        await firestore.collection(CollectionsNames.usernames).doc(value).get();

    //  إذا الاسم موجود
    if (!doc.exists) return null;

    //  إذا الاسم نفسه للمستخدم الحالي
    // if (value == oldUsername) return null;
    if (doc.data()?['uid'] == UserSession.uid) return null;

    return "اسم المستخدم هذا محجوز مسبقاً";
    // if (doc.exists && value != oldUsername) {
    //   return "اسم المستخدم هذا محجوز مسبقا";
    // } else {
    //   return null;
    // }
  }

  void onUsernameChanged(String value) async {
    update();
    usernameError.value = null; // reset أول شي
    _timer?.cancel();

    _timer = Timer(const Duration(milliseconds: 500), () async {
      usernameError.value =
          await checkUsername(value, false); // null = valid / string = error
    });
  }

  // Reactive validation
  bool get isFormValid {
    return firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        usernameController.text.isNotEmpty &&
        Validators.username(usernameController.text) == null &&
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
