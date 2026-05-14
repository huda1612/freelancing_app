import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/classes/user_session.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/offer_status.dart';
import 'package:freelancing_platform/core/widgets/custom_snackbar.dart';
import 'package:freelancing_platform/data/services/offer_service.dart';
import 'package:freelancing_platform/models/project_collections/offer_model.dart';
import 'package:freelancing_platform/models/project_collections/project_model.dart';
import 'package:get/get.dart';

class ProjectOffersController extends GetxController {
  final OfferService _offerService = OfferService();

  var pageState = StatusClasses.isloading.obs;

  ProjectModel? project;
  String? projectId;

  final offers = <OfferModel>[].obs;

  final activeTabIndex = 0.obs;

  String? actionOfferId;

  bool get showTabs =>
      project != null &&
      UserSession.uid != null &&
      UserSession.uid == project!.clientId;

  bool get isProjectOwner => showTabs;

  @override
  void onInit() {
    super.onInit();
    project = Get.arguments?['project'] as ProjectModel?;
    projectId = Get.arguments?['projectId'] as String? ?? project?.id;

    if (projectId == null || projectId!.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        customSnackbar(message: "تعذر تحميل العروض، معلومات المشروع ناقصة");
        Get.back();
      });
      return;
    }

    loadOffers().catchError((err, stack) {
      debugPrint('loadOffers error: $err');
      debugPrint('$stack');
    });
  }

  Future<void> loadOffers() async {
    pageState.value = StatusClasses.isloading;

    final res =
        await _offerService.getProjectOffers(projectId: projectId!);

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

  /// للزوار: يعرض فقط العروض المعلقة.
  List<OfferModel> get visitorPendingOffers => pendingOffers;

  List<OfferModel> offersForActiveTab() {
    if (!showTabs) {
      return visitorPendingOffers;
    }
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

  Future<void> openFreelancerProfile(String freelancerId) async {
    await Get.toNamed(
      AppRoutes.profile,
      arguments: {'userId': freelancerId},
    );
  }

  Future<void> acceptOffer(OfferModel offer) async {
    _startAction(offer.id);
    final res = await _offerService.acceptOfferAndRejectOthers(
      projectId: projectId!,
      acceptedOfferId: offer.id,
    );
    _endAction();
    if (res != StatusClasses.success) {
      customSnackbar(message: "خطأ : ${res.type} / ${res.message}");
      return;
    }
    customSnackbar(message: "تم قبول العرض ورفض الباقي تلقائياً");
    await loadOffers();
  }

  Future<void> rejectOffer(OfferModel offer) async {
    _startAction(offer.id);
    final res = await _offerService.setOfferStatus(
      offerId: offer.id,
      status: OfferStatus.rejected,
    );
    _endAction();
    if (res != StatusClasses.success) {
      customSnackbar(message: "خطأ : ${res.type} / ${res.message}");
      return;
    }
    customSnackbar(message: "تم رفض العرض");
    await loadOffers();
  }

  Future<void> withdrawOffer(OfferModel offer) async {
    _startAction(offer.id);
    final res = await _offerService.setOfferStatus(
      offerId: offer.id,
      status: OfferStatus.withdrawn,
    );
    _endAction();
    if (res != StatusClasses.success) {
      customSnackbar(message: "خطأ : ${res.type} / ${res.message}");
      return;
    }
    customSnackbar(message: "تم سحب العرض");
    await loadOffers();
  }

  Future<void> editOffer(OfferModel offer) async {
    if (project == null) {
      customSnackbar(message: "بيانات المشروع غير متوفرة للتعديل");
      return;
    }
    final result = await Get.toNamed(
      AppRoutes.submitOffer,
      arguments: {
        'offer': offer,
        'projectBudget': project!.budget,
        'projectDurationDays': project!.durationDays,
        'projectId': project!.id,
        'clientId': project!.clientId,
      },
    );
    if (result == true) {
      await loadOffers();
    }
  }

  void _startAction(String offerId) {
    actionOfferId = offerId;
    update();
  }

  void _endAction() {
    actionOfferId = null;
    update();
  }

  bool isOfferOwner(OfferModel offer) =>
      UserSession.uid != null && UserSession.uid == offer.freelancerId;

  bool isBusy(String offerId) => actionOfferId == offerId;
}
