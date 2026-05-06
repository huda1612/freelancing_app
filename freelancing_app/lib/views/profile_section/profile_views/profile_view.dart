import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';
import 'package:freelancing_platform/core/constants/user_roles.dart';
import 'package:freelancing_platform/core/general_controllers.dart/image_upload_controller.dart';
import 'package:freelancing_platform/core/services/image_service.dart';
import 'package:freelancing_platform/core/widgets/custom_empty_data_text.dart';
import 'package:freelancing_platform/core/widgets/custom_button.dart';

import 'package:freelancing_platform/core/widgets/custom_loading.dart';
import 'package:freelancing_platform/core/widgets/custom_text_field.dart';
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

  final ProfileController controller = Get.find<ProfileController>();

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
            // }) }),),
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

  Widget _buildBasicInfo() {
    String? cName;
    if (controller.user.value?.countryCode != null) {
      final country =
          CountryCode.fromCountryCode(controller.user.value?.countryCode ?? "");
      cName = country.name;
    }
    final String? gender =
        controller.user.value?.gender == 'female' ? "انثى" : "ذكر";

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      runSpacing: 6,
      children: [
        _infoItem(Icons.location_on, cName ?? "غير محدد"),
        _infoItem(Icons.person, gender ?? "غير محدد"),
        _infoItem(
            Icons.cake,
            controller.user.value?.birthDate != null
                ? controller.user.value!.birthDate.toString().split(" ").first
                : "غير محدد"),
      ],
    );
  }

  Widget _infoItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.grey),
        SizedBox(width: 4),
        Text(
          text,
          style: AppTextStyles.link.copyWith(color: AppColors.darkGrey),
        ),
      ],
    );
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
              child: GetBuilder<ImageUploadController>(builder: (c) {
                return GestureDetector(
                  onLongPress: controller.isOwnProfile
                      ? controller.changeProfileImage
                      : null,
                  child: CircleAvatar(
                    backgroundColor: AppColors.owhite,
                    // child: ClipOval(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (c.localImage != null)
                          ClipOval(
                              child:
                                  Image.file(c.localImage!, fit: BoxFit.cover))
                        else if (controller.profileImage.value.isNotEmpty)
                          ClipOval(
                            child: Obx(() => CachedNetworkImage(
                                  imageUrl: controller.profileImage.value,
                                  placeholder: (context, url) =>
                                      const CustomLoading(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                  fit: BoxFit.cover,
                                )),
                          )
                        else
                          Icon(Icons.person,
                              size: 54, color: AppColors.lightPurple),
                        if (c.isUploading)
                          const Center(child: CircularProgressIndicator()),
                        controller.isOwnProfile
                            ? Align(
                                alignment: Alignment.bottomRight,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: AppColors.lightPurple,
                                ),
                              )
                            : SizedBox.shrink()
                      ],
                    ),
                  ),
                );
              }),
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
                SizedBox(height: 6.h),
                _buildBasicInfo(),
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
            onTap: () {
              // customSnackbar();
            },
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
          //specailization
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

          //Bio
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _titleText('النبذة'),
              controller.isOwnProfile
                  ? Row(
                      children: [
                        TextButton(
                            onPressed: controller.editBio.value
                                ? controller.saveNewBio
                                : controller.toggleEditBio,
                            child: Text(
                              controller.editBio.value
                                  ? "حفظ التعديل"
                                  : "تعديل",
                              style: AppTextStyles.link,
                            )),
                        controller.editBio.value
                            ? TextButton(
                                onPressed: controller.toggleEditBio,
                                child: Text(
                                  "إلغاء",
                                  style: AppTextStyles.link,
                                ))
                            : SizedBox.shrink(),
                      ],
                    )
                  : SizedBox.shrink(),
            ],
          ),
          controller.updatingBioLoading.value
              ? CustomLoading()
              : cardContainer(
                  child: controller.editBio.value
                      ? CustomTextField(
                          controller: controller.bioController,
                        )
                      : Text(
                          controller.user.value?.bio.isNotEmpty == true
                              ? controller.user.value!.bio
                              : 'لا يوجد نبذة حالياً.',
                          style: AppTextStyles.body
                              .copyWith(color: AppColors.black),
                        ),
                ),
          SizedBox(height: 14.h),

          //reviews
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
                : customEmptyMessage(message: "لا يوجد تقييمات بعد"),
          ),

          controller.isFreelancer
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 14),

                    //skills
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _titleText('المهارات'),
                        controller.isOwnProfile
                            ? TextButton(
                                onPressed: controller.editSkills,
                                child: Text(
                                  "تعديل المهارات",
                                  style: AppTextStyles.link,
                                ))
                            : SizedBox.shrink()
                      ],
                    ),
                    Obx(() {
                      if (controller.isLoadingSkills.value) {
                        return CustomLoading();
                      }
                      return
                          //  SizedBox(
                          //   height: 100.h, // تقريباً سطرين
                          //   child: SingleChildScrollView(
                          //     child: Wrap(
                          //       spacing: 8.w,
                          //       runSpacing: 8.h,
                          //       children: controller.skills
                          //           .map((skill) => ProfileSkillChip(skill: skill))
                          //           .toList(),
                          //     ),
                          //   ),
                          // );

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
                      );
                    }),
                    SizedBox(height: 14.h),

                    //certificates
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _titleText('الشهادات'),
                        TextButton(
                            onPressed: controller.newCertificate.value == null
                                ? controller.addCertificate
                                : controller.cencelAddCertificate,
                            child: Text(
                              controller.newCertificate.value == null
                                  ? "اضافة شهادة"
                                  : "إلغاء الاضافة",
                              style: AppTextStyles.link,
                            ))
                      ],
                    ),
                    Obx(() {
                      return controller.newCertificate.value != null
                          ? ProfileCertificateTile(
                              isLoading: controller.addingCerLoading.value,
                              isNewCertificate: true,
                              certificate: controller.newCertificate.value!,
                              allSkills: controller.user.value != null
                                  ? controller.user.value!.skills
                                  : [],
                              onPickImage: ImageService.pickImage,
                              onSave: (map) =>
                                  controller.saveCertificate(null, map, "add"),
                              isOwnProfile: controller.isOwnProfile,
                            )
                          : SizedBox.shrink();
                    }),
                    Obx(() {
                      return Column(
                        children: controller.loadCertificates.value
                            ? [const CustomLoading()]
                            : controller.certificates
                                .map(
                                  (certificate) => ProfileCertificateTile(
                                    isLoading: controller.loadingCertIds
                                        .contains(certificate.id),
                                    certificate: certificate,
                                    allSkills: controller.user.value != null
                                        ? controller.user.value!.skills
                                        : [],
                                    onPickImage: ImageService.pickImage,
                                    onDelete: () => controller
                                        .deleteCertificate(certificate.id!),
                                    onSave: (map) => controller.saveCertificate(
                                        certificate.id!, map, "update"),
                                    isOwnProfile: controller.isOwnProfile,
                                  ),
                                )
                                .toList(),
                      );
                    }),

                    // controller.isOwnProfile
                    //     ? Center(
                    //         child: SizedBox(
                    //           width: double.infinity,
                    //           child: DecoratedBox(
                    //             decoration: BoxDecoration(
                    //               gradient: AppColors.gradientColor,
                    //               borderRadius: BorderRadius.circular(16),
                    //             ),
                    //             child: TextButton.icon(
                    //               onPressed: controller.addWork,
                    //               icon: const Icon(Icons.add,
                    //                   color: AppColors.white),
                    //               label: Text('إضافة شهادة',
                    //                   style: AppTextStyles.button),
                    //             ),
                    //           ),
                    //         ),
                    //       )
                    //     : const SizedBox.shrink(),
                  ],
                )
              : const SizedBox.shrink(),
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
    return Obx(() => SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 20),
          child: Column(children: [
            ...List.generate(controller.works.length, (index) {
              final work = controller.works[index];
              // print(work.imageUrl);
              return GestureDetector(
                onTap: () async {
                  Get.toNamed(
                    AppRoutes.workDetails,
                    arguments: {
                      "work": work,
                      "isOwnProfile": controller.isOwnProfile,
                    },
                  );
                },
                child: ProfileWorkCard(work: work),
              );
            }),
            // ...List.generate(controller.newWorks.length, (index) {
            //   // return
            // }),
            controller.isOwnProfile
                ? SizedBox(
                    width: double.infinity,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: AppColors.gradientColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextButton.icon(
                        onPressed: controller.addWork,
                        icon: const Icon(Icons.add, color: AppColors.white),
                        label: Text('إضافة عمل', style: AppTextStyles.button),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ]),
        ));
    //  Obx(() => SingleChildScrollView(
    //       padding: const EdgeInsets.fromLTRB(14, 14, 14, 20),
    //       child: Column(
    //         children: [
    //           // ListView.builder(
    //           //   physics: NeverScrollableScrollPhysics(),
    //           //   itemCount: controller.works.length,
    //           //   itemBuilder: (context, index) {
    //           //     final work = controller.works[index];

    //           //     return GestureDetector(
    //           //       onTap: () async {
    //           //         final result = await Get.toNamed(
    //           //           AppRoutes.workDetails,
    //           //           arguments: {
    //           //             "work": work,
    //           //             "isOwnProfile": controller.isOwnProfile,
    //           //           },
    //           //         );
    //           //         if (result != null) {
    //           //           controller.works[index] = result;
    //           //         }
    //           //       },
    //           //       child: ProfileWorkCard(work: work),
    //           //     );
    //           //   },
    //           // ),
    //           ...controller.works.map((work) => GestureDetector(
    //               onTap: () async {
    //                 final result = await Get.toNamed(AppRoutes.workDetails,
    //                     arguments: {
    //                       "work": work,
    //                       "isOwnProfile": controller.isOwnProfile
    //                     });

    //                 if (result != null) {
    //                   // controller.loadWorks(controller.userId);
    //                   print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!$result");
    //                   final index =
    //                       controller.works.indexWhere((w) => w.id == result.id);
    //                   if (index != -1) {
    //                     controller.works[index] = result;
    //                     controller.works.refresh();
    //                   }
    //                 }
    //               },
    //               child: ProfileWorkCard(work: work))),
    //           SizedBox(height: 16.h),
    //           controller.isOwnProfile
    //               ? SizedBox(
    //                   width: double.infinity,
    //                   child: DecoratedBox(
    //                     decoration: BoxDecoration(
    //                       gradient: AppColors.gradientColor,
    //                       borderRadius: BorderRadius.circular(16),
    //                     ),
    //                     child: TextButton.icon(
    //                       onPressed: () {},
    //                       icon: const Icon(Icons.add, color: AppColors.white),
    //                       label: Text('إضافة عمل', style: AppTextStyles.button),
    //                     ),
    //                   ),
    //                 )
    //               : const SizedBox.shrink(),
    //         ],
    //       ),
    //     ));
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
