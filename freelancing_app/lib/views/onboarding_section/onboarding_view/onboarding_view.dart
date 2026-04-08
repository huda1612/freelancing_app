import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/views/onboarding_section/onboarding_controller/onboarding_controller.dart';
import 'package:freelancing_platform/views/onboarding_section/onboarding_widget/onboarding_card.dart';
import 'package:get/get.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
 final controller = Get.find<OnboardingController>();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: controller.pageController,
              itemCount: controller.pages.length,
              onPageChanged: (i) => controller.currentIndex.value = i,
              itemBuilder: (context, i) {
                final p = controller.pages[i];
                return Obx(() => OnboardingCard(
                  assetPath: p.assetPath,
                  title: p.title,
                  subtitle: p.subtitle,
                  isLast: i == controller.pages.length - 1,
                  onNext: controller.nextPage,
                  onSkip: controller.skip,
                  progressValue: controller.progressValue,
                ));
              },
            ),
          ),
        ],
      ),
    );
  }
}
