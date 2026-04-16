import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/constants/app_assets.dart';
import 'package:freelancing_platform/core/constants/app_keys.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/models/onboarding/onboarding_model.dart';
import 'package:freelancing_platform/core/services/local_storage_service.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  final pages = <OnboardingModel>[
    OnboardingModel(
      assetPath: AppAssets.first,
      title: "وظف أفضل المبدعين",
      subtitle: "اعثر على محترفين موثوقين لتنفيذ مشروعك القادم بسهولة",
    ),
    OnboardingModel(
      assetPath: AppAssets.second,
      title: "ابحث عن الفرصة المناسبة",
      subtitle: "استعرض المشاريع المتاحة في أي وقت واختر ما يناسب  مهارتك",
    ),
    OnboardingModel(
      assetPath: AppAssets.third,
      title: "كل شيء على بُعد نقرة واحدة",
      subtitle: "أنجز مشروعك أو اعثر على عمل  أحلامك بنقرة واحدة فقط",
    ),
    OnboardingModel(
      assetPath: AppAssets.finaly,
      title: "ابدأ رحلتك المهنية الآن",
      subtitle:
          "انضم إلى المنصة و ابدأ بتوظيف المستقلين و اكتشاف فرص العمل التي تناسبك",
    ),
  ];

  var currentIndex = 0.obs;
  final pageController = PageController();

  void nextPage() {
    if (currentIndex.value < pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      finish();
    }
  }

  void skip() => finish();

  void finish() {
    //بدي خزن قيمه لاعرف اذا اول مره بيفتح التطبيق بعدين
    LocalStorageService.setStringValue(AppKeys.firstOpen, "1");
    LocalStorageService.setConstantFirstOpen();
    Get.offNamed(AppRoutes.join);
  }

  double get progressValue {
    switch (currentIndex.value) {
      case 0:
        return 0.25;
      case 1:
        return 0.5;
      case 2:
        return 0.75;
      case 3:
        return 1.0;
      default:
        return 0.0;
    }
  }
}
