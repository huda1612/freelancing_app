import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/offer_status.dart';
import 'package:freelancing_platform/core/widgets/custom_app_bar.dart';
import 'package:freelancing_platform/core/widgets/custom_refreshable_empty_message.dart';
import 'package:freelancing_platform/core/widgets/get_rerponse_handler.dart';
import 'package:freelancing_platform/core/widgets/list_tab_bar.dart';
import 'package:freelancing_platform/models/project_collections/offer_model.dart';
import 'package:freelancing_platform/views/offer_section/offer_controller/project_offers_controller.dart';
import 'package:freelancing_platform/views/offer_section/offer_widgets/project_offer_tile.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ProjectOffersView extends StatelessWidget {
  ProjectOffersView({super.key});

  final ProjectOffersController controller =
      Get.find<ProjectOffersController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: 'عروض المشروع',
        backgroundGradient: AppColors.gradientColor,
      ),
      body: SafeArea(
        top: false,
        child:
            // controller.project == null || controller.projectId == null
            //     ? CustomErrorWidget(
            //         message: "تعذر تحميل العروض، معلومات المشروع ناقصة",
            //       )
            //     :
            Obx(
          () => ModalProgressHUD(
            inAsyncCall:
                controller.isAccepting.value == StatusClasses.isloading,
            child: UiStateHandler(
              status: controller.pageState.value,
              fetchDataFun: controller.loadOffers,
              child: Column(
                children: [
                  // if (controller.showAllTabs)
                  _tabsBar(),
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
        padding: const EdgeInsets.fromLTRB(12, 3, 12, 0),
        child: Row(
          children: [
            Expanded(
              child: ListTabButton(
                label: 'معلقة',
                selected: controller.activeTabIndex.value == 0,
                onTap: () => controller.setTabIndex(0),
                longerLine: true,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ListTabButton(
                label: 'مرفوضة',
                selected: controller.activeTabIndex.value == 1,
                onTap: () => controller.setTabIndex(1),
                longerLine: true,
              ),
            ),
            if (controller.showAllTabs) ...[
              const SizedBox(width: 8),
              Expanded(
                child: ListTabButton(
                  label: 'مسحوبة',
                  selected: controller.activeTabIndex.value == 2,
                  onTap: () => controller.setTabIndex(2),
                  longerLine: true,
                ),
              ),
              RichText(text: TextSpan(children: []))
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildOffersList(BuildContext context) {
    return Obx(() {
      final items = controller.offersForActiveTab();

      if (items.isEmpty) {
        return CustomRefreshableEmptyMessage(
          emptyMessage: controller.showAllTabs
              ? _emptyMessageForTab(
                  controller.activeTabIndex.value,
                )
              : 'لا توجد عروض معلقة على هذا المشروع.',
          onRefresh: controller.loadOffers,
        );
      }

      return RefreshIndicator(
        onRefresh: controller.loadOffers,
        child: ListView.builder(
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
                onAccept:
                    c.isProjectOwner && offer.status == OfferStatus.pending
                        ? () => c.acceptOffer(offer)
                        : null,
                onReject:
                    c.isProjectOwner && offer.status == OfferStatus.pending
                        ? () => c.rejectOffer(offer)
                        : null,
                onDelete:
                    c.isProjectOwner && offer.status == OfferStatus.withdrawn
                        ? () {}
                        : null,
              ),
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
        return 'لا توجد عروض مرفوضة.';
      case 2:
        return 'لا توجد عروض مسحوبة.';
      default:
        return 'لا توجد بيانات.';
    }
  }
}
