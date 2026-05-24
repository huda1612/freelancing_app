import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/classes/app_notifications.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/classes/user_session.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/offer_status.dart';
import 'package:freelancing_platform/core/services/navigation_service.dart';
import 'package:freelancing_platform/core/services/notification_sender_services.dart';
import 'package:freelancing_platform/core/widgets/custom_snackbar.dart';
import 'package:freelancing_platform/data/services/offer_service.dart';
import 'package:freelancing_platform/data/services/project_service.dart';
import 'package:freelancing_platform/models/project_collections/offer_model.dart';
import 'package:freelancing_platform/models/project_collections/project_model.dart';
import 'package:freelancing_platform/views/project_section/project_controller/client_project_controller.dart';
import 'package:get/get.dart';

class ProjectOffersController extends GetxController {
  final OfferService _offerService = OfferService();

  var pageState = StatusClasses.isloading.obs;
  var isAccepting = StatusClasses.idle.obs;

  ProjectModel? project;
  String? projectId;

  final offers = <OfferModel>[].obs;

  final activeTabIndex = 0.obs;

//لازم جرب اذا بيمشي الحال اعمل تعديل عاكتر من عرض بنف الوقت لان هي كانت متغير وانا عملتها مصفوفه
  List<String> actionOfferId = [];

  bool get showTabs => isProjectOwner || isFreelancer;

  bool get isFreelancer =>
      UserSession.uid != null && UserSession.role == 'freelancer';

  bool get isProjectOwner =>
      project != null &&
      UserSession.uid != null &&
      UserSession.uid == project!.clientId;

  @override
  void onInit() {
    super.onInit();
    actionOfferId = [];
    project =
        NavigationService.routeArguments(AppRoutes.projectOffers)?["project"];
    projectId = project?.id;

    if (projectId == null || projectId!.isEmpty) {
      //لو ما مبعوت المشروع بتأكد لو مبعوت الرقم اله ( من الاشعار بينبعت رقم المشروع)
      projectId = NavigationService.routeArguments(
          AppRoutes.projectOffers)?["projectId"];
      print("!!!!!!!!!!!!! projId : $projectId");
      //لو حتى الاي دي ما مرسل
      if (projectId == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          customSnackbar(message: "تعذر تحميل العروض، معلومات المشروع ناقصة");
        });
        pageState.value = StatusClasses.customError(
            "تعذر تحميل العروض، معلومات المشروع ناقصة");
        return;
      }
      loadProjectAndOffers();
    } else {
      loadOffers();
    }
  }

  //هي بحال انا جايه من الاشعار
  Future<void> loadProjectAndOffers() async {
    pageState.value = StatusClasses.isloading;
    final projectRes = await ProjectService().getProject(projectId!);
    projectRes.fold((err) async {
      pageState.value = err;
    }, (p) async {
      project = p;
      final res = await _offerService.getProjectOffers(projectId: projectId!);

      res.fold(
        (err) {
          pageState.value = err;
        },
        (list) {
          offers.assignAll(list);
          pageState.value = StatusClasses.success;
        },
      );
    });
  }

  Future<void> loadOffers() async {
    pageState.value = StatusClasses.isloading;

    //لو دخل عالصفحه وهو ما صاحبها بكفي حمل العروض المعلقه بس ليش لحملهم كلهم
    final res = await _offerService.getProjectOffers(projectId: projectId!);

    res.fold(
      (err) {
        pageState.value = err;
      },
      (list) {
        offers.assignAll(list);
        pageState.value = StatusClasses.success;
      },
    );
  }

  List<OfferModel> get pendingOffers =>
      offers.where((o) => o.status == OfferStatus.pending).toList();

  List<OfferModel> get rejectedOffers =>
      offers.where((o) => o.status == OfferStatus.rejected).toList();

  List<OfferModel> get withdrawnOffers =>
      offers.where((o) => o.status == OfferStatus.withdrawn).toList();

  /// للزوار والمستقلين: يعرض فقط العروض الخاصة بالمستقل
  List<OfferModel> get visitorPendingOffers => isFreelancer
      ? offers.where((o) => o.freelancerId == UserSession.uid).toList()
      : pendingOffers;

  List<OfferModel> offersForActiveTab() {
    if (!showTabs) {
      return visitorPendingOffers;
    }

    // للمستقل: عرض عروضه فقط
    if (isFreelancer) {
      switch (activeTabIndex.value) {
        case 0:
          return pendingOffers
              .where((o) => o.freelancerId == UserSession.uid)
              .toList();
        case 1:
          return rejectedOffers
              .where((o) => o.freelancerId == UserSession.uid)
              .toList();
        case 2:
          return withdrawnOffers
              .where((o) => o.freelancerId == UserSession.uid)
              .toList();
        default:
          return pendingOffers
              .where((o) => o.freelancerId == UserSession.uid)
              .toList();
      }
    }

    // للعميل: عرض جميع العروض
    switch (activeTabIndex.value) {
      case 0:
        return pendingOffers;
      case 1:
        return rejectedOffers;
      case 2:
        return withdrawnOffers;
      default:
        return pendingOffers;
    }
  }

  void setTabIndex(int index) {
    activeTabIndex.value = index;
  }

  void openFreelancerProfile(String freelancerId) {
    Get.toNamed(
      AppRoutes.userProfile,
      arguments: {'userId': freelancerId},
    );
  }

//ok
  Future<void> acceptOffer(OfferModel offer) async {
    isAccepting.value = StatusClasses.isloading;
    final res = await _offerService.acceptOfferAndRejectOthers(
        projectId: projectId!,
        acceptedOfferId: offer.id,
        acceptedFreelancerId: offer.freelancerId);
    //لازم حدث حاله المشروع و حط رقم الفريلانسر
    isAccepting.value = StatusClasses.idle;
    if (res != StatusClasses.success) {
      customSnackbar(message: "خطأ : ${res.type} / ${res.message}");
      return;
    }
    NavigationService.back(result: true);

    customSnackbar(message: "تم قبول العرض ورفض الباقي تلقائياً");
    await loadOffers();
    //لان حدثنا حاله المشروع فلازم نحدث المشاريع بصفحة مشاريعي للعميل
    if (Get.isRegistered<ClientProjectController>()) {
      Get.find<ClientProjectController>().loadProjects();
    }
    // if (Get.isRegistered<ProjectDetailsController>()) {
    //   final controller = Get.find<ProjectDetailsController>();

    //   controller.project =
    //       controller.project?.copyWith(status: ProjectStatus.inProgress);

    //   controller.update();
    // }
    final AppNotification acceptNotification =
        AppNotification.offerAccepted(project!.title, project!.id);
    NotificationSenderServices.sendNotificationToUser(
        uId: offer.freelancerId,
        title: acceptNotification.title,
        body: acceptNotification.body,
        data: acceptNotification.data);
  }

//ok
  Future<void> rejectOffer(OfferModel offer) async {
    _startAction(offer.id);
    final res = await _offerService.setOfferStatus(
      offerId: offer.id,
      status: OfferStatus.rejected,
    );
    _endAction(offer.id);
    if (res != StatusClasses.success) {
      customSnackbar(message: "خطأ : ${res.type} / ${res.message}");
      return;
    }
    customSnackbar(message: "تم رفض العرض");
    await loadOffers();
    final AppNotification rejectNotification =
        AppNotification.offerRejected(project!.title, project!.id);
    NotificationSenderServices.sendNotificationToUser(
        uId: offer.freelancerId,
        title: rejectNotification.title,
        body: rejectNotification.body,
        data: rejectNotification.data);
  }

//ok
  // Future<void> withdrawOffer(OfferModel offer) async {
  //   _startAction(offer.id);
  //   final res = await _offerService.setOfferStatus(
  //     offerId: offer.id,
  //     status: OfferStatus.withdrawn,
  //   );
  //   _endAction(offer.id);
  //   if (res != StatusClasses.success) {
  //     customSnackbar(message: "خطأ : ${res.type} / ${res.message}");
  //     return;
  //   }
  //   customSnackbar(message: "تم سحب العرض");
  //   await loadOffers();

  //   if (Get.isRegistered<ProjectDetailsController>()) {
  //     Get.find<ProjectDetailsController>().hasOffer.value = false;
  //     Get.find<ProjectDetailsController>().oldOffer = null;
  //   }
  // }

  //ok
  // Future<void> editOffer(OfferModel offer) async {
  //   if (project == null) {
  //     customSnackbar(message: "بيانات المشروع غير متوفرة للتعديل");
  //     return;
  //   }
  //   final result = await Get.toNamed(
  //     AppRoutes.submitOffer,
  //     arguments: {
  //       'offer': offer,
  //       'projectBudget': project!.budget,
  //       'projectDurationDays': project!.durationDays,
  //       'projectId': project!.id,
  //       'clientId': project!.clientId,
  //     },
  //   );
  //   if (result == true) {
  //     await loadOffers();
  //     if (Get.isRegistered<ProjectDetailsController>()) {
  //       await Get.find<ProjectDetailsController>().hasOldOffer();
  //     }
  //   }
  // }

  void _startAction(String offerId) {
    // actionOfferId = offerId;
    actionOfferId.add(offerId);
    update();
  }

  void _endAction(String offerId) {
    // actionOfferId = null;
    actionOfferId.remove(offerId);

    update();
  }

  bool isOfferOwner(OfferModel offer) =>
      UserSession.uid != null && UserSession.uid == offer.freelancerId;

  bool isBusy(String offerId) => actionOfferId.contains(offerId);
}
