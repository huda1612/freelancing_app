import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_input_styles.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/utils/helper_function/validators.dart';
import 'package:freelancing_platform/core/widgets/base_screen.dart';
import 'package:freelancing_platform/core/widgets/custom_app_bar.dart';
import 'package:freelancing_platform/core/widgets/custom_text_field.dart';
import 'package:freelancing_platform/core/widgets/get_rerponse_handler.dart';
import 'package:freelancing_platform/core/widgets/search_field.dart';
import 'package:freelancing_platform/views/auth_section/auth_controller/sign_out_controller.dart';
import 'package:freelancing_platform/views/user_request_section/request_controller/freelancer_request_controller.dart';
import 'package:freelancing_platform/views/user_request_section/request_widgets/selected_skills_box.dart';
import 'package:freelancing_platform/views/user_request_section/request_widgets/skill_tile.dart';
import 'package:freelancing_platform/views/user_request_section/request_widgets/sub_skill_result_item.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class FreelancerAccountInfoView extends StatelessWidget {
  FreelancerAccountInfoView({super.key});

  final FreelancerRequestController controller =
      Get.find<FreelancerRequestController>();
  // final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: GetBuilder<SignOutController>(
          init: Get.find<SignOutController>(),
          builder: (signOutController) {
            return ModalProgressHUD(
              inAsyncCall: signOutController.signOutIsLoading,
              child: BaseScreen(
                appBar: CustomAppBar(
                  leadingIcon: IconButton(
                      onPressed: signOutController.signOut,
                      icon: Icon(
                        Icons.output_rounded,
                        color: AppColors.white,
                      )),
                  title: "معلومات الحساب ",
                  bottom: const TabBar(
                    labelColor: AppColors.white,
                    unselectedLabelColor: AppColors.grey,
                    indicatorColor: AppColors.white,
                    tabs: [
                      Tab(text: "المعلومات"),
                      Tab(text: "المهارات"),
                    ],
                  ),
                ),
                body: Obx(() {
                  return UiStateHandler(
                    status: controller.pageState.value,
                    fetchDataFun: controller.fetchPageData,
                    child: Column(
                      children: [
                        Expanded(
                          child: TabBarView(
                            children: [
                              // ---------------------- Tab 1 ----------------------
                              Padding(
                                padding: EdgeInsets.all(
                                    AppSpaces.mediumHorizontalPadding),
                                child: Form(
                                  key: controller.formKey,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                            height: AppSpaces.heightMedium),

                                        // التخصص الجديد الاختيار
                                        SizedBox(
                                          width: 380.w,

                                          //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! يمكن هالObx كلها مالها داعي لو عملنا وحده كلل الصفحه وقت تحميل الصفحه
                                          child: Obx(() {
                                            if (controller
                                                .allSpecializations.isEmpty) {
                                              return Text(
                                                'لا توجد تخصصات. تأكد من اتصالك بالانترنت ',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 13.sp,
                                                  color: AppColors.black,
                                                ),
                                              );
                                            }

                                            return DropdownButtonFormField<
                                                String>(
                                              key: ValueKey(
                                                '${controller.specializationDropdownValue}_${controller.allSpecializations.length}',
                                              ),
                                              initialValue: controller
                                                  .specializationDropdownValue,
                                              isExpanded: true,
                                              decoration:
                                                  unifiedDecoration('التخصص'),
                                              hint: Text(
                                                'اختر التخصص',
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                              icon: Icon(
                                                Icons.keyboard_arrow_down,
                                                color: AppColors.vividPurple,
                                              ),
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              items: controller
                                                  .allSpecializations
                                                  .map(
                                                    (o) => DropdownMenuItem<
                                                        String>(
                                                      value: o.name,
                                                      child: Text(
                                                        o.name,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textDirection:
                                                            TextDirection.rtl,
                                                      ),

                                                    ),
                                                  ),
                                                  icon: Icon(
                                                    Icons.keyboard_arrow_down,
                                                    color:
                                                        AppColors.vividPurple,
                                                  ),
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  items: controller
                                                      .allSpecializations
                                                      .map(
                                                        (o) => DropdownMenuItem<
                                                            String>(
                                                          value: o.slug,
                                                          child: Text(
                                                            o.name,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textDirection:
                                                                TextDirection
                                                                    .rtl,
                                                          ),
                                                        ),
                                                      )
                                                      .toList(),
                                                  onChanged: controller
                                                          .allSpecializations
                                                          .isEmpty
                                                      ? null
                                                      : controller
                                                          .onSpecialChange,
                                                  validator: Validators
                                                      .validateSpecialization,
                                                ),
                                                // controller.elseSpecial.value
                                                //     ? CustomTextField(
                                                //         initialValue: controller
                                                //             .customSpecial
                                                //             .value,
                                                //         hintText:
                                                //             "ادخل اسم الاختصاص",
                                                //         keyboardType:
                                                //             TextInputType.name,
                                                //         validator: Validators
                                                //             .validateSpecialization,
                                                //         onChanged: (v) =>
                                                //             controller
                                                //                 .customSpecial
                                                //                 .value = v)
                                                //     : SizedBox.shrink()
                                              ],
                                            );
                                          }),
                                        ),
                                        SizedBox(
                                            height: AppSpaces.heightMedium2),
                                        CustomTextField(
                                          initialValue:
                                              controller.jobTitle.value,
                                          hintText: "المسمى الوظيفي",
                                          keyboardType: TextInputType.name,
                                          validator:
                                              Validators.validateJobTitle,
                                          onChanged: (v) =>
                                              controller.jobTitle.value = v,
                                        ),
                                        SizedBox(
                                            height: AppSpaces.heightMedium2),
                                        CustomTextField(
                                          initialValue: controller.bio.value,
                                          hintText: "نبذة",
                                          keyboardType: TextInputType.multiline,
                                          validator: Validators.validateBio,
                                          onChanged: (v) =>
                                              controller.bio.value = v,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // ---------------------- Tab 2 ----------------------
                              Padding(
                                padding: EdgeInsets.all(
                                    AppSpaces.mediumHorizontalPadding),
                                child: Column(
                                  children: [
                                    SearchField(
                                      hint: "ابحث عن مهارة...",
                                      onChanged: controller.onSearchChanged,
                                    ),
                                    SizedBox(height: 12.h),
                                    Expanded(
                                      child: Obx(() {
                                        if (controller
                                            .searchQuery.value.isNotEmpty) {
                                          return ListView(
                                            children: controller
                                                .filteredSubSkills
                                                .map((sub) {
                                              return SubSkillResultItem(
                                                title: sub,
                                                isSelected: controller
                                                    .selectedSkills
                                                    .contains(sub),
                                                onTap: () => controller
                                                    .toggleSelectSubSkill(sub),
                                              );
                                            }).toList(),
                                          );
                                        }

                                        return ListView.builder(
                                          itemCount: controller
                                              .sugustSubSpecials.length,
                                          itemBuilder: (context, index) {
                                            return Obx(() {
                                              final sugustSubSpecial =
                                                  controller
                                                      .sugustSubSpecials[index];

                                              return SkillTile(
                                                title: sugustSubSpecial.name,
                                                subSkills:
                                                    sugustSubSpecial.skills,
                                                isExpanded: sugustSubSpecial
                                                    .expanded.value,
                                                selectedSubSkills:
                                                    sugustSubSpecial
                                                        .selectedSubSkills,
                                                onToggle: () => controller
                                                    .toggleSkill(index),
                                                onSubSkillToggle: (sub) =>
                                                    controller.toggleSubSkill(
                                                        index, sub),
                                              );
                                            });
                                          },
                                        );
                                      }),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        _buildBottomSkillsBar(context),
                      ],
                    ),
                  );
                }),
              ),
            );
          }),
    );
  }

  /// شريط سفلي: المهارات المختارة (تظهر فقط عند الاختيار) بجانب زر التالي.
  Widget _buildBottomSkillsBar(BuildContext context) {
    return Obx(() {
      final hasSkills = controller.selectedSkills.isNotEmpty;
      return SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpaces.mediumHorizontalPadding,
            8.h,
            AppSpaces.mediumHorizontalPadding,
            12.h,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            textDirection: TextDirection.rtl,
            mainAxisAlignment:
                hasSkills ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: [
              if (hasSkills) ...[
                Expanded(
                  child: SelectedSkillsBox(
                    skills: controller.selectedSkills.toList(),
                    onRemove: controller.toggleSelectSubSkill,
                    maxContentHeight: 80,
                  ),
                ),
                SizedBox(width: 10.w),
              ],
              ElevatedButton(
                onPressed: controller.canSubmit
                    ? () => controller.firstNextBottonOnPressed()
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.vividPurple,
                  padding:
                      EdgeInsets.symmetric(horizontal: 40.w, vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'التالي',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:freelancing_platform/core/constants/app_colors.dart';
// import 'package:freelancing_platform/core/constants/app_input_styles.dart';
// import 'package:freelancing_platform/core/constants/app_spaces.dart';
// import 'package:freelancing_platform/core/utils/helper_function/validators.dart';
// import 'package:freelancing_platform/core/widgets/base_screen.dart';
// import 'package:freelancing_platform/core/widgets/custom_app_bar.dart';
// import 'package:freelancing_platform/core/widgets/custom_text_field.dart';
// import 'package:freelancing_platform/core/widgets/get_rerponse_handler.dart';
// import 'package:freelancing_platform/core/widgets/search_field.dart';
// import 'package:freelancing_platform/views/auth_section/auth_controller/sign_out_controller.dart';
// import 'package:freelancing_platform/views/user_request_section/request_controller/freelancer_request_controller.dart';
// import 'package:freelancing_platform/views/user_request_section/request_widgets/selected_skills_box.dart';
// import 'package:freelancing_platform/views/user_request_section/request_widgets/skill_tile.dart';
// import 'package:freelancing_platform/views/user_request_section/request_widgets/sub_skill_result_item.dart';
// import 'package:get/get.dart';
// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

// class FreelancerAccountInfoView extends StatelessWidget {
//   FreelancerAccountInfoView({super.key});

//   final FreelancerRequestController controller =
//       Get.find<FreelancerRequestController>();

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: GetBuilder<SignOutController>(
//           init: Get.find<SignOutController>(),
//           builder: (signOutController) {
//             return ModalProgressHUD(
//               inAsyncCall: signOutController.signOutIsLoading,
//               child: BaseScreen(
//                 appBar: CustomAppBar(
//                   leadingIcon: IconButton(
//                       onPressed: signOutController.signOut,
//                       icon: Icon(
//                         Icons.output_rounded,
//                         color: AppColors.white,
//                       )),
//                   title: "معلومات الحساب ",
//                   bottom: const TabBar(
//                     labelColor: AppColors.white,
//                     unselectedLabelColor: AppColors.grey,
//                     indicatorColor: AppColors.white,
//                     tabs: [
//                       Tab(text: "المعلومات"),
//                       Tab(text: "المهارات"),
//                     ],
//                   ),
//                 ),
//                 body: Obx(() {
//                   return UiStateHandler(
//                     status: controller.pageState.value,
//                     fetchDataFun: controller.fetchSpecializations,
//                     child: Column(
//                       children: [
//                         Expanded(
//                           child: TabBarView(
//                             children: [
//                               // ---------------------- Tab 1 ----------------------
//                               Padding(
//                                 padding: EdgeInsets.all(
//                                     AppSpaces.mediumHorizontalPadding),
//                                 child: Form(
//                                   key: controller.formKey,
//                                   child: SingleChildScrollView(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.center,
//                                       children: [
//                                         SizedBox(
//                                             height: AppSpaces.heightMedium),

//                                         // التخصص الجديد الاختيار
//                                         SizedBox(
//                                           width: 380.w,

//                                           //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! يمكن هالObx كلها مالها داعي لو عملنا وحده كلل الصفحه وقت تحميل الصفحه
//                                           child: Obx(() {
//                                             if (controller
//                                                 .allSpecializations.isEmpty) {
//                                               return Text(
//                                                 'لا توجد تخصصات. تأكد من اتصالك بالانترنت ',
//                                                 textAlign: TextAlign.center,
//                                                 style: TextStyle(
//                                                   fontSize: 13.sp,
//                                                   color: AppColors.black,
//                                                 ),
//                                               );
//                                             }else{
//                                             return DropdownButtonFormField<String>(
//                                               key: ValueKey(
//                                                 '${controller.specializationDropdownValue}_${controller.allSpecializations.length}',
//                                               ),
//                                               value: controller
//                                                   .specializationDropdownValue,
//                                               isExpanded: true,
//                                               decoration:
//                                                   unifiedDecoration('التخصص'),
//                                               hint: Text(
//                                                 'اختر التخصص',
//                                                 style: TextStyle(
//                                                   fontSize: 14.sp,
//                                                   color: Colors.black54,
//                                                 ),
//                                               ),
//                                               icon: Icon(
//                                                 Icons.keyboard_arrow_down,
//                                                 color: AppColors.vividPurple,
//                                               ),
//                                               style: TextStyle(
//                                                 fontSize: 14.sp,
//                                                 color: Colors.black87,
//                                                 fontWeight: FontWeight.w500,
//                                               ),
//                                               items: controller
//                                                   .allSpecializations
//                                                   .map(
//                                                     (o) => DropdownMenuItem<
//                                                         String>(
//                                                       value: o.name,
//                                                       child: Text(
//                                                         o.name,
//                                                         overflow: TextOverflow
//                                                             .ellipsis,
//                                                         textDirection:
//                                                             TextDirection.rtl,
//                                                       ),
//                                                     ),
//                                                   )
//                                                   .toList(),
//                                               onChanged: controller
//                                                       .allSpecializations
//                                                       .isEmpty
//                                                   ? null
//                                                   : controller.onSpecialChange,
//                                               // : (v) =>
//                                               //     controller.selectedSpecial.value = v,
//                                               validator: Validators
//                                                   .validateSpecialization,
//                                             );
//                                             }
//                                           }),
//                                         ),
//                                         SizedBox(height: AppSpaces.heightMedium2),

//                                         CustomTextField(
//                                           hintText: "المسمى الوظيفي",
//                                           keyboardType: TextInputType.name,
//                                           validator:
//                                               Validators.validateJobTitle,
//                                           onChanged: (v) =>
//                                               controller.jobTitle.value = v,
//                                       ),
//                                       ]
//                                     // }
//                                     // return
//                                     //  DropdownButtonFormField<String>(
//                                     //   key: ValueKey(
//                                     //     '${controller.specializationDropdownValue}_${controller.allSpecializations.length}',
//                                     //   ),
//                                     //   initialValue: controller
//                                     //       .specializationDropdownValue,
//                                     //   isExpanded: true,
//                                     //   decoration: unifiedDecoration('التخصص'),
//                                     //   hint: Text(
//                                     //     'اختر التخصص',
//                                     //     style: TextStyle(
//                                     //       fontSize: 14.sp,
//                                     //       color: Colors.black54,
//                                     //     ),)
//                                     //     SizedBox(
//                                     //         height: AppSpaces.heightMedium2),
//                                     //     CustomTextField(
//                                     //       hintText: "نبذة",
//                                     //       keyboardType: TextInputType.multiline,
//                                     //       validator: Validators.validateBio,
//                                     //       onChanged: (v) =>
//                                     //           controller.bio.value = v,
//                                     //     ),

//                                     // ),
//                                   ),
//                                 ),
//                               ),

//                               // ---------------------- Tab 2 ----------------------
//                               Padding(
//                                 padding: EdgeInsets.all(
//                                     AppSpaces.mediumHorizontalPadding),
//                                 child: Column(
//                                   children: [
//                                     SearchField(
//                                       hint: "ابحث عن مهارة...",
//                                       onChanged: controller.onSearchChanged,
//                                     ),
//                                     SizedBox(height: 12.h),
//                                     Expanded(
//                                       child: Obx(() {
//                                         if (controller
//                                             .searchQuery.value.isNotEmpty) {
//                                           return ListView(
//                                             children: controller
//                                                 .filteredSubSkills
//                                                 .map((sub) {
//                                               return SubSkillResultItem(
//                                                 title: sub,
//                                                 isSelected: controller
//                                                     .selectedSkills
//                                                     .contains(sub),
//                                                 onTap: () => controller
//                                                     .toggleSelectSubSkill(sub),
//                                               );
//                                             }).toList(),
//                                           );
//                                         }

//                                         return ListView.builder(
//                                           itemCount: controller
//                                               .sugustSubSpecials.length,
//                                           itemBuilder: (context, index) {
//                                             return Obx(() {
//                                               final sugustSubSpecial =
//                                                   controller
//                                                       .sugustSubSpecials[index];

//                                               return SkillTile(
//                                                 title: sugustSubSpecial.name,
//                                                 subSkills:
//                                                     sugustSubSpecial.skills,
//                                                 isExpanded: sugustSubSpecial
//                                                     .expanded.value,
//                                                 selectedSubSkills:
//                                                     sugustSubSpecial
//                                                         .selectedSubSkills,
//                                                 onToggle: () => controller
//                                                     .toggleSkill(index),
//                                                 onSubSkillToggle: (sub) =>
//                                                     controller.toggleSubSkill(
//                                                         index, sub),
//                                               );
//                                             });
//                                           },
//                                         );
//                                       }),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ]),
//                           ),
//                         ),
//                         _buildBottomSkillsBar(context),
//                       ],
//                     ),
//                   );
//                 }),
//               ),
//             );
//           }),
//     );
//   }

//   /// شريط سفلي: المهارات المختارة (تظهر فقط عند الاختيار) بجانب زر التالي.
//   Widget _buildBottomSkillsBar(BuildContext context) {
//     return Obx(() {
//       final hasSkills = controller.selectedSkills.isNotEmpty;
//       return SafeArea(
//         top: false,
//         child: Padding(
//           padding: EdgeInsets.fromLTRB(
//             AppSpaces.mediumHorizontalPadding,
//             8.h,
//             AppSpaces.mediumHorizontalPadding,
//             12.h,
//           ),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             textDirection: TextDirection.rtl,
//             mainAxisAlignment:
//                 hasSkills ? MainAxisAlignment.start : MainAxisAlignment.end,
//             children: [
//               if (hasSkills) ...[
//                 Expanded(
//                   child: SelectedSkillsBox(
//                     skills: controller.selectedSkills.toList(),
//                     onRemove: controller.toggleSelectSubSkill,
//                     maxContentHeight: 80,
//                   ),
//                 ),
//                 SizedBox(width: 10.w),
//               ],
//               ElevatedButton(
//                 onPressed: controller.canSubmit
//                     ? () => controller.firstNextBottonOnPressed()
//                     : null,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.vividPurple,
//                   padding:
//                       EdgeInsets.symmetric(horizontal: 40.w, vertical: 14.h),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: Text(
//                   'التالي',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     });
//   }
// }
