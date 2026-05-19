import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/classes/user_session.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/offer_status.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/user_roles.dart';
import 'package:freelancing_platform/core/services/navigation_service.dart';
import 'package:freelancing_platform/core/widgets/custom_snackbar.dart';
import 'package:freelancing_platform/data/services/offer_service.dart';
import 'package:freelancing_platform/data/services/project_service.dart';
import 'package:freelancing_platform/models/project_collections/offer_model.dart';
import 'package:freelancing_platform/models/project_collections/project_model.dart';
import 'package:get/get.dart';

class ProjectDetailsController extends GetxController {
  ProjectModel? project;

  bool get isOwnProject {
    if (project == null) return false;
    if (project!.clientId == UserSession.uid) return true;
    return false;
  }

  //هي لازم تكون بObx ما GetBuilder لان عم حدث القيم من صفحه ثانيه ما لازم يكون في update ما بأثر بعدين
  final hasOffer = false.obs;
  final loadingCheckOldOffer = true.obs;
  bool loadingDelete = false;

  OfferModel? oldOffer;

  bool get isFreelancer => UserSession.role == UserRole.freelancer;

  @override
  void onInit() {
    super.onInit();
    //Load project details
    //طريقه اشتغلت بس اختصرتها بالخدمه
    // final args = Get.find<Map<String, dynamic>>(
    //   tag: AppRoutes.projectDetails,
    // );
    // project = args["project"]!;

    final args = NavigationService.routeArguments(AppRoutes.projectDetails);
    project = args?["project"];

    if (project == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        customSnackbar(
          message: "تعذر تحميل بيانات المشروع",
        );
      });

      return;
    }
    if (UserSession.role == UserRole.freelancer) {
      hasOldOffer();
    }
  }

  Future<void> hasOldOffer() async {
    loadingCheckOldOffer.value = true;
    // update();

    final hasOfferRes = await OfferService().freelancerOfferOnProject(
      projectId: project!.id,
      freelancerId: UserSession.uid!,
    );
    return hasOfferRes.fold((err) {
      customSnackbar(message: "${err.type} / ${err.message}");
      hasOffer.value = false;
      loadingCheckOldOffer.value = false;
      // update();
    }, (offer) {
      if (offer.isNotEmpty && offer.first.status == OfferStatus.pending) {
        // customSnackbar(message: "لديك عرض مسبق على هذا المشروع");
        hasOffer.value = true;
        oldOffer = offer[0];
      }
      loadingCheckOldOffer.value = false;
      // update();
    });
  }

  Future<void> onOfferView() async {
    // final didSomething =
    await NavigationService.toNamed(AppRoutes.projectOffers, arguments: {
      'project': project,
      'projectId': project!.id,
    });
    // if (didSomething == true) {
    //   await hasOldOffer();
    // }
  }

  Future<void> onOfferSubmit() async {
    final didSomething = await Get.toNamed(AppRoutes.submitOffer, arguments: {
      "projectBudget": project!.budget,
      "projectDurationDays": project!.durationDays,
      "projectId": project!.id,
      "clientId": project!.clientId,
      "offer": oldOffer
    });
    if (didSomething == true) {
      await hasOldOffer();
    }
  }

  // void onOfferEdit() async {
  //   Get.toNamed(AppRoutes.submitOffer, arguments: {
  //     "projectBudget": project!.budget,
  //     "projectDurationDays": project!.durationDays,
  //     "projectId": project!.id,
  //     "clientId": project!.clientId,
  //     "offer" :
  //   });
  // }

  void onDeleteProject() {
    Get.defaultDialog(
      title: "تأكيد الحذف",
      middleText: "هل أنت متأكد أنك تريد حذف هذا المشروع؟",
      textCancel: "إلغاء",
      textConfirm: "حذف",
      // confirmTextColor: Colors.white,
      onConfirm: () async {
        Get.back(); // إغلاق
        // تنفيذ الحذف
        await deleteProject();
      },
    );
  }

  //لازم ضيف حاله للصفحه وقت تحميل الحذف
  Future<void> deleteProject() async {
    loadingDelete = true;
    update();
    final response = await ProjectService().deleteProject(project!);
    if (response != StatusClasses.success) {
      customSnackbar(message: "خطأ :  ${response.type} / ${response.message}");
      loadingDelete = false;
      update();
      return;
    }
    loadingDelete = false;
    update();
    NavigationService.back(result: true);

    customSnackbar(message: "تم حذف المشروع بنجاح");

    return;
  }

  //تحديث المشروع
  // void updateProject({
  //   required String newTitle,
  //   required String newDescription,
  //   required String newBudget,
  //   required String newDuration,
  //   required String newSpecialization,
  //   required List<String> newSkills,
  // }) {
  //   title.value = newTitle;

  //   description.value = newDescription;

  //   budget.value = newBudget;

  //   duration.value = newDuration;

  //   specialization.value = newSpecialization;

  //   skills.value = newSkills;
  // }

  // /// إضافة مهارة
  // void addSkill(String skill) {
  //   if (skill.isNotEmpty) {
  //     skills.add(skill);
  //   }
  // }

  // /// حذف مهارة
  // void removeSkill(String skill) {
  //   skills.remove(skill);
  // }
}
