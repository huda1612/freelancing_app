import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/classes/user_session.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/offer_status.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/user_roles.dart';
import 'package:freelancing_platform/core/widgets/custom_snackbar.dart';
import 'package:freelancing_platform/data/services/offer_service.dart';
import 'package:freelancing_platform/data/services/project_service.dart';
import 'package:freelancing_platform/models/project_collections/project_model.dart';
import 'package:freelancing_platform/views/project_section/project_controller/browse_projects_controller.dart';
import 'package:get/get.dart';

class ProjectDetailsController extends GetxController {
  //  ProjectModel? project =ProjectModel(id: "", clientId:"", title: "", description: "", category: SpecializationSnapshot(slug: "", name: ""), budget: 0, durationDays: 0) ;
  ProjectModel? project;

  // var clientId = "G63CQ2p5DheAmfph21A9tCAJyWJ3";
  bool get isOwnProject {
    if (project!.clientId == UserSession.uid) return true;
    return false;
  }

  bool hasOffer = false;

  bool get isFreelancer => UserSession.role == UserRole.freelancer;

  @override
  void onInit() {
    super.onInit();
    //Load project details
    // project = Get.arguments?["project"];

    //جديدة 
   // project = Get.find<BrowseProjectsController>().selectedProject;
final argProject = Get.arguments?['project'];
    if (argProject is ProjectModel) {
      project = argProject;
    } else if (Get.isRegistered<BrowseProjectsController>()) {
      project = Get.find<BrowseProjectsController>().selectedProject;
    }
   //لهون
    if (project == null || project is! ProjectModel) {
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
    final hasOfferRes = await OfferService().freelancerOfferOnProject(
      projectId: project!.id,
      freelancerId: UserSession.uid!,
    );
    return hasOfferRes.fold((err) {
      customSnackbar(message: "${err.type} / ${err.message}");
      hasOffer = false;
    }, (offer) {
      if (offer.isNotEmpty && offer.first.status == OfferStatus.pending) {
        customSnackbar(message: "لديك عرض مسبق على هذا المشروع");
        hasOffer = true;
        update();
      }
    });
  }

  void onOfferView() {
    Get.toNamed(AppRoutes.projectOffers, arguments: {
      'project': project,
      'projectId': project!.id,
    });
  }

  Future<void> onOfferSubmit() async {
    Get.toNamed(AppRoutes.submitOffer, arguments: {
      "projectBudget": project!.budget,
      "projectDurationDays": project!.durationDays,
      "projectId": project!.id,
      "clientId": project!.clientId
    });
  }

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
    final response = await ProjectService().deleteProject(project!);
    if (response != StatusClasses.success) {
      customSnackbar(message: "خطأ :  ${response.type} / ${response.message}");
      return;
    }
    customSnackbar(message: "تم حذف المشروع بنجاح");
    return;
  }

  //
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
