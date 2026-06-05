import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/offer_status.dart';
import 'package:freelancing_platform/core/widgets/custom_app_bar.dart';
import 'package:freelancing_platform/core/widgets/custom_empty_data_text.dart';
import 'package:freelancing_platform/core/widgets/get_rerponse_handler.dart';
import 'package:freelancing_platform/views/offer_section/offer_controller/freelancer_offers_controller.dart';
import 'package:freelancing_platform/views/offer_section/offer_widgets/freelancer_offer_tile.dart';
import 'package:get/get.dart';

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
        padding: const EdgeInsets.fromLTRB(8, 3, 8, 0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children:
                List.generate(OfferStatus.freelancerTabLabels.length, (i) {
              return Padding(
                padding: EdgeInsets.only(left: i == 0 ? 0 : 6.w),
                child: _tabButton(
                  label: OfferStatus.freelancerTabLabels[i],
                  selected: controller.activeTabIndex.value == i,
                  onTap: () => controller.setTabIndex(i),
                ),
              );
            }),
          ),
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
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
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
              width: selected ? 48 : 0,
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

  Widget _buildOffersList() {
    return Obx(() {
      final items = controller.offersForActiveTab();
      if (items.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: customEmptyMessage(
              message: _emptyMessageForTab(controller.activeTabIndex.value),
            ),
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 24.h),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final offer = items[index];
          final status = offer.status;

          VoidCallback? onTap;
          if (status == OfferStatus.pending) {
            onTap = () => controller.openProjectDetails(offer.projectId);
          } else if (status == OfferStatus.accepted) {
            onTap = () => controller.openActiveProject(offer.projectId);
          }

          return FreelancerOfferTile(
            offer: offer,
            onTap: onTap,
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
