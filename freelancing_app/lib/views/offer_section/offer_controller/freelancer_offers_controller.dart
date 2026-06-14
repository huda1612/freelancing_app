import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/classes/user_session.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/offer_status.dart';
import 'package:freelancing_platform/core/services/navigation_service.dart';
import 'package:freelancing_platform/data/services/offer_service.dart';
import 'package:freelancing_platform/models/project_collections/offer_model.dart';
import 'package:get/get.dart';
//ok
class FreelancerOffersController extends GetxController {
  //service
  final OfferService _offerService = OfferService();

  // State 
  final pageState = StatusClasses.isloading.obs;
  final activeTabIndex = 0.obs;

  //data
  final offers = <OfferModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadOffers();
  }

  // Data Loading
  /// تحميل جميع عروض الفريلانسر من Firebase
  Future<void> loadOffers() async {
    pageState.value = StatusClasses.isloading;

    final res = await _offerService.getFreelancerOffers(
      freelancerId: UserSession.uid!,
    );
    res.fold(
      (err) => pageState.value = err,
      (list) async {
        offers.assignAll(list);
        pageState.value = StatusClasses.success;
      },
    );
  }

  // Tab Management
  /// تغيير التاب النشط
  void setTabIndex(int index) {
    activeTabIndex.value = index;
  }

  /// إرجاع العروض المناسبة للتاب النشط حالياً
  List<OfferModel> get offersForActiveTab {
    switch (activeTabIndex.value) {
      case 0:
        return offers.where((p) => p.status == OfferStatus.pending).toList();
      case 1:
        return offers.where((p) => p.status == OfferStatus.accepted).toList();
      case 2:
        return offers.where((p) => p.status == OfferStatus.rejected).toList();
      case 3:
        return offers.where((p) => p.status == OfferStatus.withdrawn).toList();
      default:
        return [];
    }
  }

  // Navigation
  void onOfferTab(OfferModel offer) async {
    final status = offer.status;
    if (status == OfferStatus.accepted) {
      openActiveProject(offer.projectId);
    } else {
      await openProjectDetails(offer.projectId);
    }
  }

  /// فتح صفحة تفاصيل المشروع (للعروض المعلقة)
  Future<void> openProjectDetails(String projectId) async {
    final result = await NavigationService.toNamed(AppRoutes.projectDetails,
        arguments: {"projectId": projectId});
    if (result == true) {
      await loadOffers();
    }
  }

  /// فتح صفحة المشروع النشط (للعروض المقبولة)
  void openActiveProject(String projectId) {
    Get.toNamed(
      AppRoutes.activeProject,
      arguments: {
        "projectId": projectId,
      },
    );
  }
}
