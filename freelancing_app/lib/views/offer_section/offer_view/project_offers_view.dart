import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/offer_status.dart';
import 'package:freelancing_platform/core/widgets/custom_app_bar.dart';
import 'package:freelancing_platform/core/widgets/custom_empty_data_text.dart';
import 'package:freelancing_platform/core/widgets/get_rerponse_handler.dart';
import 'package:freelancing_platform/models/project_collections/offer_model.dart';
import 'package:freelancing_platform/views/offer_section/offer_controller/project_offers_controller.dart';
import 'package:freelancing_platform/views/offer_section/offer_widgets/project_offer_tile.dart';
import 'package:get/get.dart';

class ProjectOffersView extends StatelessWidget {
  ProjectOffersView({super.key});

  final ProjectOffersController controller =
      Get.find<ProjectOffersController>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: CustomAppBar(
          title: 'عروض المشروع',
          backgroundGradient: AppColors.gradientColor,
        ),
        body: SafeArea(
          top: false,
          child: Obx(
            () => UiStateHandler(
              status: controller.pageState.value,
              fetchDataFun: controller.loadOffers,
              child: Column(
                children: [
                  if (controller.showTabs) _tabsBar(),
                  Expanded(child: _buildOffersList(context)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _tabsBar() {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.grey,
              blurRadius: 2,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
        child: Row(
          children: [
            Expanded(
              child: _tabButton(
                label: 'معلقة',
                selected: controller.activeTabIndex.value == 0,
                onTap: () => controller.setTabIndex(0),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _tabButton(
                label: 'مرفوضة',
                selected: controller.activeTabIndex.value == 1,
                onTap: () => controller.setTabIndex(1),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _tabButton(
                label: 'مسحوبة',
                selected: controller.activeTabIndex.value == 2,
                onTap: () => controller.setTabIndex(2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabButton({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: const BoxDecoration(color: Colors.transparent),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12.sp,
                color: selected ? AppColors.vividPurple : AppColors.grey,
              ),
            ),
            const SizedBox(height: 7),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: 2.5,
              width: selected ? 56 : 0,
              decoration: BoxDecoration(
                color: AppColors.vividPurple,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOffersList(BuildContext context) {
    return Obx(() {
      final items = controller.offersForActiveTab();
      if (items.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: customEmptyMessage(
              message: controller.showTabs
                  ? _emptyMessageForTab(controller.activeTabIndex.value)
                  : 'لا توجد عروض معلقة على هذا المشروع.',
            ),
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 24.h),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final OfferModel offer = items[index];
          return GetBuilder<ProjectOffersController>(
            builder: (c) => ProjectOfferTile(
              offer: offer,
              isProjectOwner: c.isProjectOwner,
              isBusy: c.isBusy(offer.id),
              onProfileTap: () => c.openFreelancerProfile(offer.freelancerId),
              onAccept: c.isProjectOwner && offer.status == OfferStatus.pending
                  ? () => c.acceptOffer(offer)
                  : null,
              onReject: c.isProjectOwner && offer.status == OfferStatus.pending
                  ? () => c.rejectOffer(offer)
                  : null,
              onWithdraw:
                  c.isOfferOwner(offer) && offer.status == OfferStatus.pending
                      ? () => c.withdrawOffer(offer)
                      : null,
              onEdit:
                  c.isOfferOwner(offer) && offer.status == OfferStatus.pending
                      ? () => c.editOffer(offer)
                      : null,
            ),
          );
        },
      );
    });
  }

  String _emptyMessageForTab(int tab) {
    switch (tab) {
      case 0:
        return 'لا توجد عروض معلقة.';
      case 1:
        return 'لا توجد عروض مرفوضة.';
      case 2:
        return 'لا توجد عروض مسحوبة.';
      default:
        return 'لا توجد بيانات.';
    }
  }
}
