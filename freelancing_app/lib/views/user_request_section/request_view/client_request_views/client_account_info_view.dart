import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_input_styles.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';
import 'package:freelancing_platform/core/utils/helper_function/validators.dart';
import 'package:freelancing_platform/core/widgets/base_screen.dart';
import 'package:freelancing_platform/core/widgets/custom_app_bar.dart';
import 'package:freelancing_platform/core/widgets/custom_button.dart';
import 'package:freelancing_platform/core/widgets/custom_text_field.dart';
import 'package:freelancing_platform/core/widgets/get_rerponse_handler.dart';
import 'package:freelancing_platform/views/auth_section/auth_controller/sign_out_controller.dart';
import 'package:freelancing_platform/views/auth_section/widgets/role_option.dart';
import 'package:freelancing_platform/views/user_request_section/request_controller/client_request_controller.dart';

import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ClientAccountInfoView extends StatelessWidget {
  const ClientAccountInfoView({super.key});

  // final SignOutController signOutController =
  //     Get.find<SignOutController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignOutController>(
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
                ),
                body: GetBuilder<ClientRequestController>(
                    init: Get.find<ClientRequestController>(),
                    builder: (controller) {
                      return UiStateHandler(
                        status: controller.pageState,
                        fetchDataFun: controller.fetchSpecializations,
                        child: Column(children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(
                                  AppSpaces.mediumHorizontalPadding),
                              child: Form(
                                key: controller.formKey,
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(height: AppSpaces.heightMedium),

                                      // التخصص الجديد الاختيار
                                      SizedBox(
                                          width: 380.w,
                                          child: controller
                                                  .allSpecializations.isEmpty
                                              ? Text(
                                                  'لا توجد تخصصات. تأكد من اتصالك بالانترنت ',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 13.sp,
                                                    color: AppColors.black,
                                                  ),
                                                )
                                              : DropdownButtonFormField<String>(
                                                  key: ValueKey(
                                                    '${controller.specializationDropdownValue}_${controller.allSpecializations.length}',
                                                  ),
                                                  value: controller
                                                      .specializationDropdownValue,
                                                  isExpanded: true,
                                                  decoration: unifiedDecoration(
                                                      'مجال العمل'),
                                                  hint: Text(
                                                    'اختر مجال عملك',
                                                    style: TextStyle(
                                                      fontSize: 14.sp,
                                                      color: Colors.black54,
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
                                                          value: o.name,
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
                                                      : (v) => controller
                                                          .selectedSpecial
                                                          .value = v,
                                                  validator: Validators
                                                      .validateSpecialization,
                                                )),
                                      SizedBox(height: AppSpaces.heightMedium2),
                                      CustomTextField(
                                        hintText: "المسمى الوظيفي",
                                        keyboardType: TextInputType.name,
                                        validator: Validators.validateJobTitle,
                                        onChanged: (v) =>
                                            controller.jobTitle.value = v,
                                      ),
                                      SizedBox(height: AppSpaces.heightMedium2),
                                      CustomTextField(
                                        hintText: "نبذة",
                                        keyboardType: TextInputType.multiline,
                                        validator: Validators.validateBio,
                                        onChanged: (v) =>
                                            controller.bio.value = v,
                                      ),
                                      SizedBox(height: AppSpaces.heightMedium2),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          "هل أنت فرد أم شركة؟",
                                          style: AppTextStyles.body.copyWith(
                                              color: AppColors.darkBackground),
                                        ),
                                      ),

                                      SizedBox(height: 12),

                                      Obx(() => Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              // زر العميل
                                              RoleOption(
                                                label: "Company",
                                                icon: Icons.business,
                                                isSelected: controller
                                                        .clientType.value ==
                                                    "company",
                                                onTap: () => controller
                                                    .clientType
                                                    .value = "company",
                                              ),

                                              SizedBox(width: 16.w),

                                              // زر المستقل
                                              RoleOption(
                                                label: "Individual",
                                                icon: Icons.person,
                                                isSelected: controller
                                                        .clientType.value ==
                                                    "individual",
                                                onTap: () => controller
                                                    .clientType
                                                    .value = "individual",
                                              ),
                                            ],
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SafeArea(
                            top: false,
                            child: Padding(
                                padding: EdgeInsets.all(AppSpaces.paddingLarge),
                                child: Obx(() {
                                  return CustomButton(
                                    text: "التالي",
                                    onTap: controller.firstNextBottonOnPressed,
                                    isDisable: !controller.canSubmit,
                                  );
                                })),
                          ),
                        ]),
                      );
                    })),
          );
        });
  }
}
