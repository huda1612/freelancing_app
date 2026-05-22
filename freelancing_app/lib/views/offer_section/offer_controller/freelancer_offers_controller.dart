import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/models/project_collections/offer_model.dart';
import 'package:get/get.dart';

/// Controller لصفحة عروض الفريلانسر
/// يدير عرض العروض مقسمة إلى تابات: معلقة، مقبولة، مرفوضة، مسحوبة
class FreelancerOffersController extends GetxController {
  // ==================== State Variables ====================
  
  /// حالة الصفحة (loading, success, error, etc.)
  final pageState = StatusClasses.idle.obs;
  
  /// مؤشر التاب النشط (0: معلقة, 1: مقبولة, 2: مرفوضة, 3: مسحوبة)
  final activeTabIndex = 0.obs;
  
  /// قائمة العروض المعلقة
  final pendingOffers = <OfferModel>[].obs;
  
  /// قائمة العروض المقبولة
  final acceptedOffers = <OfferModel>[].obs;
  
  /// قائمة العروض المرفوضة
  final rejectedOffers = <OfferModel>[].obs;
  
  /// قائمة العروض المسحوبة
  final withdrawnOffers = <OfferModel>[].obs;

  // ==================== Initialization ====================
  
  @override
  void onInit() {
    super.onInit();
    loadOffers();
  }

  // ==================== Data Loading ====================

  /// تحميل جميع عروض الفريلانسر من Firebase
  /// يقوم بتصنيف العروض حسب حالتها وتخزينها في القوائم المناسبة
  Future<void> loadOffers() async {
    // TODO: Implement loading offers from Firebase
    pageState.value = StatusClasses.success;
  }

  // ==================== Tab Management ====================

  /// تغيير التاب النشط
  /// @param index مؤشر التاب الجديد (0-3)
  void setTabIndex(int index) {
    activeTabIndex.value = index;
  }

  /// إرجاع العروض المناسبة للتاب النشط حالياً
  /// @return قائمة العروض للتاب المحدد
  List<OfferModel> offersForActiveTab() {
    switch (activeTabIndex.value) {
      case 0:
        return pendingOffers;
      case 1:
        return acceptedOffers;
      case 2:
        return rejectedOffers;
      case 3:
        return withdrawnOffers;
      default:
        return [];
    }
  }

  // ==================== Navigation ====================

  /// فتح صفحة تفاصيل المشروع (للعروض المعلقة)
  /// @param projectId معرف المشروع
  void openProjectDetails(String projectId) {
    // TODO: Implement navigation to project details
  }

  /// فتح صفحة المشروع النشط (للعروض المقبولة)
  /// @param projectId معرف المشروع
  void openActiveProject(String projectId) {
    // TODO: Implement navigation to active project
  }
}
