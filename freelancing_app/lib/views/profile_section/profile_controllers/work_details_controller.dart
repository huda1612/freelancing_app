import 'dart:io';
import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/classes/user_session.dart';
import 'package:freelancing_platform/core/constants/app_image_preset.dart';
import 'package:freelancing_platform/core/services/image_service.dart';
import 'package:freelancing_platform/core/widgets/custom_snackbar.dart';
import 'package:freelancing_platform/data/services/work_sample_service.dart';
import 'package:freelancing_platform/models/user_collections/worksamples_model.dart';
import 'package:freelancing_platform/views/profile_section/profile_controllers/profile_controller.dart';
import 'package:get/get.dart';

class WorkDetailsController extends GetxController {
  final WorkSampleService _workSampleService = WorkSampleService();
  WorksampleModel work = WorksampleModel(title: '', description: '');
  var isEditing = false;
  var isPageLoading = false;
  var isOwnProfile = false; // لازم تجي من البروفايل عشان اعرف اذا كان يقدر يعدل
  // var hasChanged = false;
  //القيم الجديده بعد التعديل
  TextEditingController titleC = TextEditingController();
  TextEditingController descC = TextEditingController();
  File? newImageFile;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;

    isOwnProfile = args['isOwnProfile'];

    final WorksampleModel workSample = args['work'];
    work = workSample;
    titleC.text = workSample.title;
    // imageC.text = workSample.imageUrl ?? '';
    descC.text = workSample.description;
  }

  void saveChange() async {
    //data did not changed
    if (titleC.text == work.title &&
        descC.text == work.description &&
        newImageFile == null) {
      customSnackbar(message: "لم يتم تغيير البيانات");
      isEditing = false;
      update();
      return;
    }
    isPageLoading = true;
    update();
    String? newUrl;
    //1 رفع الصورة اذا تغيرت
    if (newImageFile != null) {
      final uploadRes = await ImageService.uploadImage(
          AppImagePreset.workSamplesPreset, newImageFile!);
      uploadRes.fold((err) {
        Get.snackbar(err.type, err.message ?? "حدث خطأ اثناء رفع الصورة");
      }, (url) {
        newUrl = url;
      });
      if (newUrl == null) {
        isPageLoading = false;
        update();
        // customSnackbar(message: "فشل رفع الصورة");
        return;
      }
    }

    // تغيير بيانات العمل بالفاير ستور بس بشرط ان يكون في شي متغير اصلا عن العمل اللي معي ياه بالمتغير وورك
    // WorkSampleService workSampleService = WorkSampleService();
    Map<String, dynamic> newData = {};
    newData.addIf(
        titleC.text.trim() != work.title.trim(), 'title', titleC.text);
    newData.addIf(descC.text.trim() != work.description.trim(), 'description',
        descC.text);
    newData.addIf(newUrl != null, 'imageUrl', newUrl);

    if (newData.isEmpty) {
      isPageLoading = false;
      update();
      customSnackbar(message: "لم يتم تحديث البيانات");
      return;
    }
    final updateRes = await _workSampleService.updateWorkSample(
        newData: newData, uid: UserSession.uid!, wID: work.id!);
    if (updateRes != StatusClasses.success) {
      isPageLoading = false;
      update();
      Get.snackbar(
          updateRes.type, updateRes.message ?? "حدث خطأ اثناء تحديث البيانات");
      return;
    }
    //3 بغير متغييرات الوورك مشان يبنعرضوا بالصفحة وبحذف الصوره المحليه
    work = work.copyWith(
        title: titleC.text,
        description: descC.text,
        imageUrl: newUrl ?? work.imageUrl);
    newImageFile = null;
    isEditing = false;
    //
    isPageLoading = false;
    // hasChanged = true;

    update();
    customSnackbar(message: "تم حفظ التعديلات بنجاح");
    Get.find<ProfileController>().loadWorks(UserSession.uid!);
  }

  void selectNewImage() async {
    newImageFile = await ImageService.pickImage();
    if (newImageFile == null) {
      customSnackbar(message: "لم يتم اختيار صورة");
      return;
    }
    update();
  }

  void onSelectOption(value) {
    if (value == "edit") {
      isEditing = !isEditing;
      newImageFile = null;
      update();
    } else {
      deleteWork();
    }
  }

  void deleteWork() {
    Get.defaultDialog(
      title: "تأكيد الحذف",
      middleText: "هل أنت متأكد أنك تريد حذف العمل؟",
      textConfirm: "حذف",
      textCancel: "إلغاء",
      onConfirm: () async {
        Get.back(); //  سكر الديالوج
        isPageLoading = true;
        update();
        //delete
        final response = await _workSampleService.deleteWorkSample(
            uId: UserSession.uid!, wsId: work.id!);
        if (response != StatusClasses.success) {
          customSnackbar(
              message: "خطأ : ${response.message ?? "فشل حذف العمل"}");
          isPageLoading = false;
          update();
          return;
        } else {
          Get.find<ProfileController>()
              .works
              .removeWhere((w) => w.id == work.id);
          Get.find<ProfileController>().works.refresh();
          // await Get.find<ProfileController>().loadWorks(UserSession.uid!);
          Get.back(); // ارجع لصفحة البروفايل بعد الحذف
          customSnackbar(message: "تم حذف العمل بنجاح");
          // isPageLoading = false;
          // update();
        }
      },
    );
  }
}
