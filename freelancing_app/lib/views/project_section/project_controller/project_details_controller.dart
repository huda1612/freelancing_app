import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/classes/user_session.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/user_roles.dart';
import 'package:freelancing_platform/core/widgets/custom_snackbar.dart';
import 'package:freelancing_platform/data/services/project_service.dart';
import 'package:freelancing_platform/models/project_collections/project_model.dart';
import 'package:get/get.dart';

class ProjectDetailsController extends GetxController {
  //  ProjectModel? project =ProjectModel(id: "", clientId:"", title: "", description: "", category: SpecializationSnapshot(slug: "", name: ""), budget: 0, durationDays: 0) ;
  ProjectModel? project;
  // final String title = "تطوير تطبيق متجر إلكتروني";
  // final String status = ProjectStatus.newProject;

  // final String description =
  //     "أحتاج إلى تطوير تطبيق متجر إلكتروني احترافي باستخدام Flutter مع لوحة تحكم وإمكانية الدفع الإلكتروني وإدارة المنتجات.";

  // final String budget = "500\$ - 700\$";

  // final String duration = "14 يوم";

  // final String specialization = "تطوير تطبيقات Flutter";

  // final List<String> skills = [
  //   "Flutter",
  //   "Firebase",
  //   "API",
  //   "UI UX",
  //   "Dart",
  // ];

  // var clientId = "G63CQ2p5DheAmfph21A9tCAJyWJ3";
  bool get isOwnProject {
    if (project!.clientId == UserSession.uid) return true;
    return false;
  }

  bool get isFreelancer => UserSession.role == UserRole.freelancer;

  @override
  void onInit() {
    super.onInit();
    //Load project details
    project = Get.arguments?["project"];
    if (project == null || project is! ProjectModel) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        customSnackbar(
          message: "تعذر تحميل بيانات المشروع",
        );
        //هي لازم تكون صفحه ثانيه
        Get.offNamed(AppRoutes.profile);
        // Get.offNamed(AppRoutes.home); هيك لازم
        // await Future.delayed(const Duration(milliseconds: 1000));
        // Get.back();
      });

      return;
    }
  }

  void onOfferView() {
    // Get.toNamed(AppRoutes.offersList , arguments: {"projectId" : });
  }
  Future<void> onOfferSubmit() async {
    Get.toNamed(AppRoutes.submitOffer, arguments: {
      "projectBudget": project!.budget,
      "projectDurationDays": project!.durationDays
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
