import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/offer_status.dart';
import 'package:freelancing_platform/core/widgets/custom_app_bar.dart';
import 'package:freelancing_platform/core/widgets/custom_refreshable_empty_message.dart';
import 'package:freelancing_platform/core/widgets/get_rerponse_handler.dart';
import 'package:freelancing_platform/views/offer_section/offer_controller/freelancer_offers_controller.dart';
import 'package:freelancing_platform/views/offer_section/offer_widgets/freelancer_offer_tile.dart';
import 'package:freelancing_platform/core/widgets/list_tab_bar.dart';
import 'package:get/get.dart';
//ok
class FreelancerOffersView extends StatelessWidget {
  final FreelancerOffersController controller =
      Get.find<FreelancerOffersController>();

  FreelancerOffersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: CustomAppBar(
          title: 'عروضي',
          backgroundGradient: AppColors.gradientColor,
        ),
        body: Obx(
          () => UiStateHandler(
            status: controller.pageState.value,
            fetchDataFun: controller.loadOffers,
            child: Column(
              children: [
                _tabsBar(),
                Expanded(child: _buildOffersList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _tabsBar() {
    return Obx(() {
      final selectedIndex =
          controller.activeTabIndex.value; //حتى تتغير بالواجهة بالObx
      return ListTabBar(
        tabsLength: OfferStatus.freelancerTabLabels.length,
        getLabel: (i) => OfferStatus.freelancerTabLabels[i],
        isSelected: (i) => selectedIndex == i,
        onLabelTab: (i) => controller.setTabIndex(i),
      );
    });
  }

  Widget _buildOffersList() {
    return Obx(() {
      final items = controller.offersForActiveTab;

      if (items.isEmpty) {
        return CustomRefreshableEmptyMessage(
          onRefresh: controller.loadOffers,
          emptyMessage: _emptyMessageForTab(controller.activeTabIndex.value),
        );
      }

      return RefreshIndicator(
        color: AppColors.vividPurple,
        onRefresh: controller.loadOffers,
        child: ListView.builder(
          padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 24.h),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final offer = items[index];
            return FreelancerOfferTile(
              offer: offer,
              onTap: () => controller.onOfferTab(offer),
            );
          },
        ),
      );
    });
  }

  String _emptyMessageForTab(int tab) {
    switch (tab) {
      case 0:
        return 'لا توجد عروض معلقة.';
      case 1:
        return 'لا توجد عروض مقبولة.';
      case 2:
        return 'لا توجد عروض مرفوضة.';
      case 3:
        return 'لا توجد عروض مسحوبة.';
      default:
        return 'لا توجد بيانات.';
    }
  }
}
