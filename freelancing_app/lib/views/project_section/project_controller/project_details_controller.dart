import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/classes/user_session.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/offer_status.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/project_status.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/user_roles.dart';
import 'package:freelancing_platform/core/services/navigation_service.dart';
import 'package:freelancing_platform/core/widgets/custom_snackbar.dart';
import 'package:freelancing_platform/data/services/offer_service.dart';
import 'package:freelancing_platform/data/services/project_service.dart';
import 'package:freelancing_platform/models/project_collections/offer_model.dart';
import 'package:freelancing_platform/models/project_collections/project_model.dart';
import 'package:freelancing_platform/views/offer_section/offer_controller/freelancer_offers_controller.dart';
import 'package:get/get.dart';

class ProjectDetailsController extends GetxController {
  ProjectModel? project;
  String? projectId;

  bool get isOwnProject {
    if (project == null) return false;
    if (project!.clientId == UserSession.uid) return true;
    return false;
  }

  //هي لازم تكون بObx ما GetBuilder لان عم حدث القيم من صفحه ثانيه ما لازم يكون في update ما بأثر بعدين
  final hasOffer = false.obs;
  final loadingCheckOldOffer = true.obs;
  bool loadingDelete = false;
  StatusClasses pageState = StatusClasses.isloading;

  OfferModel? oldOffer;

  bool get isFreelancer => UserSession.role == UserRole.freelancer;

  @override
  void onInit() async {
    super.onInit();
    //Load project details
    final args = NavigationService.routeArguments(AppRoutes.projectDetails);
    project = args?["project"];

    if (project == null) {
      projectId = args?["projectId"];
      print("!!!!!!!!! id $projectId");

      if (projectId == null) {
        print("!!!!!!!!! id is null");
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          customSnackbar(
            message: "تعذر تحميل بيانات المشروع",
          );
        });
        pageState = StatusClasses.customError("تعذر تحميل بيانات المشروع");
        return;
      }
      await loadProject();
    } else {
      pageState = StatusClasses.success;
    }
    if (UserSession.role == UserRole.freelancer && project != null) {
      hasOldOffer();
    }
  }

  Future<void> loadProject() async {
    // if (projectId == null) {
    //   return;
    // }
    pageState = StatusClasses.isloading;
    update();
    final profectRes = await ProjectService().getProject(
      projectId!,
    );
    return profectRes.fold((err) {
      customSnackbar(message: "${err.type} / ${err.message}");
      pageState = err;
      update();
    }, (p) {
      print("Prrrrrrrrrooooject ${p.id}");
      project = p;
      pageState = StatusClasses.success;
      update();
    });
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
    final didSomething =
        await NavigationService.toNamed(AppRoutes.projectOffers, arguments: {
      'project': project,
      'projectId': project!.id,
    });
    //لو رجع من الصفحه بعد ما قبل واحد من العروض لازم اعمل هيك حتى ما يقدر يحذف المشروع
    if (didSomething == true) {
      // await hasOldOffer();
      project = project?.copyWith(status: ProjectStatus.setup);
      update();
    }
  }

  Future<void> onOfferSubmit() async {
    final didSomething = await Get.toNamed(AppRoutes.submitOffer, arguments: {
      "projectBudget": project!.budget,
      "projectDurationDays": project!.durationDays,
      "projectId": project!.id,
      "clientId": project!.clientId,
      "projectTitle": project!.title,
      "offer": oldOffer
    });
    if (didSomething == true) {
      await hasOldOffer();
      await _updateFreelancerOffersPage();
    }
  }

  Future<void> _updateFreelancerOffersPage() async {
    if (Get.isRegistered<FreelancerOffersController>()) {
      await Get.find<FreelancerOffersController>().loadOffers();
    }
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
    loadingDelete = true;
    update();
    final response = await ProjectService().deleteNewProject(project!);
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

  Future<void> withdrawOffer() async {
    // _startAction(offer.id);
    loadingDelete = true;
    update();
    final res = await OfferService().setOfferStatus(
      offerId: oldOffer!.id,
      status: OfferStatus.withdrawn,
    );
    loadingDelete = false;
    update();
    if (res != StatusClasses.success) {
      customSnackbar(message: "خطأ : ${res.type} / ${res.message}");
      return;
    }
    customSnackbar(message: "تم سحب العرض");
    // await hasOldOffer();
    hasOffer.value = false;
    oldOffer = null;
    await _updateFreelancerOffersPage();
  }
}
