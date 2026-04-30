import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';
import 'package:freelancing_platform/core/constants/user_roles.dart';
import 'package:freelancing_platform/core/widgets/CustomEmptyDataText.dart';
import 'package:freelancing_platform/core/widgets/custom_bottom_nav_bar.dart';
import 'package:freelancing_platform/core/widgets/custom_button.dart';
import 'package:freelancing_platform/core/widgets/custom_loading.dart';
import 'package:freelancing_platform/core/widgets/get_rerponse_handler.dart';
import 'package:freelancing_platform/views/profile_section/profile_controllers/profile_controller.dart';
import 'package:freelancing_platform/views/profile_section/profile_widgets/card_container.dart';
import 'package:freelancing_platform/core/widgets/profile_certificate_tile.dart';
import 'package:freelancing_platform/views/profile_section/profile_widgets/profile_review_card.dart';
import 'package:freelancing_platform/views/profile_section/profile_widgets/profile_skill_chip.dart';
import 'package:freelancing_platform/core/widgets/profile_work_card.dart';
import 'package:get/get.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            backgroundColor: AppColors.white,
            // appBar: CustomAppBar(
            //   title: 'الملف الشخصي',
            //   leadingIcon: Builder(
            //     builder: (context) => IconButton(
            //       icon: const Icon(Icons.menu_rounded, color: AppColors.black),
            //       onPressed: () => Scaffold.of(context).openDrawer(),
            //     ),
            //   ),
            // ),
            // drawer: _buildSideDrawer(),
            body: Obx(() =>
                // GetBuilder<ProfileController>(builder: (_) {
                UiStateHandler(
                  status: controller.pageState.value,
                  fetchDataFun: controller.loadProfile,
                  child: Column(
                    children: [
                      _buildHeader(),
                      _tabsBar(),
                      Expanded(
                        child: IndexedStack(
                          index: controller.activeTabIndex.value,
                          children: [
                            _buildProfileTab(),
                            _buildWorksTab(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ))
            // })
            // }
            // ),
            // ),
            // bottomNavigationBar: Obx(
            //   () => CustomBottomNavBar(
            //       currentIndex: controller.temp.value,
            //       onTap: (i) {
            //         controller.temp.value = i;
            //       },
            //       isClient: false),
            // )
            ));
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            height: 140.h,
            decoration: BoxDecoration(
              gradient: AppColors.gradientColor,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
            ),
          ),
          //للصورة
          Transform.translate(
            offset: const Offset(0, -48),
            child: Container(
              width: 98.w,
              height: 98.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.gradientColor,
              ),
              padding: const EdgeInsets.all(3),
              child: GestureDetector(
                onTap: controller.isOwnProfile ? () {} : null,
                child: CircleAvatar(
                  backgroundColor: AppColors.owhite,
                  child: controller.user.value != null
                      ? (controller.user.value!.photoUrl.trim().isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: controller.user.value!.photoUrl,
                              placeholder: (context, url) =>
                                  const CustomLoading(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              fit: BoxFit.cover,
                            )
                          : Icon(Icons.person,
                              size: 54, color: AppColors.lightPurple))
                      : Icon(Icons.person,
                          size: 54, color: AppColors.veryLightPurple),
                ),
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -34),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //الاسم الكامل هون
                    Text(controller.fullName,
                        style: AppTextStyles.body
                            .copyWith(color: AppColors.black)),
                    //اسم المستخدم لازم يكون هون
                    Text(
                      '(${controller.username})',
                      style: AppTextStyles.button.copyWith(
                        color: AppColors.darkGrey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  '(${controller.subTitle})',
                  style: AppTextStyles.link.copyWith(
                    color: AppColors.black,
                  ),
                ),
                SizedBox(height: 12.h),
                _buildActionButtons(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    if (controller.isOwnProfile) {
      return Wrap(
        alignment: WrapAlignment.center,
        spacing: 10,
        runSpacing: 8,
        children: [
          CustomButton(
            text: 'تعديل المعلومات',
            textStyle: AppTextStyles.link,
            color: AppColors.owhite,
            onTap: () => Get.toNamed(AppRoutes.personalInfo),
            width: 150.w,
          ),
          CustomButton(
            text: 'لوحة التحكم',
            textStyle: AppTextStyles.link.copyWith(color: AppColors.white),
            onTap: () {},
            width: 150.w,
          ),
        ],
      );
    }

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      runSpacing: 8.h,
      children: [
        CustomButton(
          text: 'تواصل معي',
          textStyle: AppTextStyles.link,
          color: AppColors.owhite,
          onTap: () {},
          width: 150.w,
        ),
        CustomButton(
          text: 'وظفني',
          textStyle: AppTextStyles.link.copyWith(color: AppColors.white),
          onTap: () {},
          width: 150.w,
        ),
      ],
    );
  }

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          controller.role == UserRole.freelancer
              ? _titleText('الاختصاص')
              : SizedBox.shrink(),
          controller.role == UserRole.freelancer
              ? cardContainer(
                  child: Text(
                  controller.specializationLabel,
                  style: AppTextStyles.body.copyWith(color: AppColors.black),
                ))
              : SizedBox.shrink(),
          SizedBox(height: 14.h),
          _titleText('النبذة'),
          cardContainer(
            child: Text(
              controller.user.value?.bio.isNotEmpty == true
                  ? controller.user.value!.bio
                  : 'لا يوجد نبذة حالياً.',
              style: AppTextStyles.body.copyWith(color: AppColors.black),
            ),
          ),
          SizedBox(height: 14.h),
          _titleText('التقييمات'),
          SizedBox(
              height: 116.h,
              child: controller.reviews.isNotEmpty
                  ? ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.reviews.take(5).length,
                      separatorBuilder: (_, __) => SizedBox(width: 10.w),
                      itemBuilder: (context, index) {
                        final review = controller.reviews[index];
                        return ProfileReviewCard(
                          rating: review.rating,
                          title: review.comment,
                        );
                      },
                    )
                  : customEmptyMessage(message: "لا يوجد تقييمات بعد")
              // : Center(
              //     child: Text(
              //       "لا يوجد تقييمات بعد",
              //       style: AppTextStyles.blacksubheading
              //           .copyWith(color: AppColors.grey),
              //     ),
              //   ),
              ),
          const SizedBox(height: 14),
          _titleText('المهارات'),
          SizedBox(
            height: 50.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: controller.skills.length,
              separatorBuilder: (_, __) => SizedBox(width: 8.h),
              itemBuilder: (context, index) => ProfileSkillChip(
                skill: controller.skills[index],
              ),
            ),
          ),
          SizedBox(height: 14.h),
          _titleText('الشهادات'),
          Column(
            children: controller.certificates
                .map(
                  (certificate) => ProfileCertificateTile(
                    certificate: certificate,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _titleText(String t) {
    return Text(
      t,
      style: AppTextStyles.subheading.copyWith(color: AppColors.darkPurple),
    );
  }

  Widget _buildWorksTab() {
    return
        // Obx(
        // () =>
        SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 20),
      child: Column(
        children: [
          ...controller.works.map((work) => ProfileWorkCard(work: work)),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: AppColors.gradientColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, color: AppColors.white),
                label: Text('إضافة عمل', style: AppTextStyles.button),
              ),
            ),
          ),
        ],
      ),
    );
    // );
  }

  Widget _tabsBar() {
    return Obx(
      () => Container(
        decoration: BoxDecoration(color: AppColors.white, boxShadow: [
          BoxShadow(
            color: AppColors.grey,
            blurRadius: 2,
            offset: Offset(0, 3),
          ),
        ]),
        // color: AppColors.white,
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
        child: Row(
          children: [
            Expanded(
              child: _tabButton(
                label: 'الملف الشخصي',
                selected: controller.activeTabIndex.value == 0,
                onTap: () => controller.setTabIndex(0),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _tabButton(
                label: 'معرض الأعمال',
                selected: controller.activeTabIndex.value == 1,
                onTap: () => controller.setTabIndex(1),
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
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: selected ? AppColors.vividPurple : AppColors.grey,
              ),
            ),
            const SizedBox(height: 7),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: 2.5,
              width: selected ? 84 : 0,
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
}
