import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';
import 'package:freelancing_platform/core/constants/reuest_status.dart';
import 'package:freelancing_platform/core/constants/user_roles.dart';
import 'package:freelancing_platform/core/widgets/custom_bottom_sheet_container.dart';
import 'package:freelancing_platform/core/widgets/custom_button.dart';
import 'package:freelancing_platform/core/widgets/custom_text_field.dart';
import 'package:freelancing_platform/core/widgets/profile_work_card.dart';
import 'package:freelancing_platform/views/admin_section/admin_requests/admin_requests_controller/admin_request_datails_controller.dart';
import 'package:freelancing_platform/views/admin_section/admin_requests/widgets/request_type.dart';
import 'package:freelancing_platform/core/widgets/profile_certificate_tile.dart';
import 'package:freelancing_platform/views/profile_section/profile_widgets/certificate_skill_card.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AdimnRequestDetailView extends StatelessWidget {
  const AdimnRequestDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdminRequestDatailsController>(
        init: Get.find<AdminRequestDatailsController>(),
        builder: (controller) {
          return ModalProgressHUD(
            inAsyncCall: controller.sendingState == StatusClasses.isloading,
            child: Scaffold(
                backgroundColor: AppColors.veryLightGrey,
                appBar: AppBar(
                  backgroundColor: AppColors.white,
                  title: const Text("تفاصيل الطلب"),
                  leading: const BackButton(),
                  actions: [
                    Padding(
                      padding: EdgeInsets.only(left: AppSpaces.paddingMedium),
                      child: RequestType(controller.request.status),
                    )
                  ],
                ),
                body: SingleChildScrollView(
                  padding: EdgeInsets.all(AppSpaces.paddingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Card (Status / Title)
                      Container(
                        padding: EdgeInsets.all(AppSpaces.paddingMedium),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.person,
                                  color: AppColors.darkPurple,
                                  size: 30,
                                ),
                                SizedBox(width: AppSpaces.heightSmall),
                                Text(
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    controller.nameLoadingState ==
                                            StatusClasses.success
                                        ? "${controller.fname} ${controller.lname}"
                                        : controller.nameLoadingState ==
                                                StatusClasses.isloading
                                            ? "جار التحميل...."
                                            : "حدث خطأ !",
                                    // ${controller.nameLoadingState.message}",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                            Text(
                              "( ${controller.request.userType} )",
                              style: AppTextStyles.body
                                  .copyWith(color: AppColors.darkPurple),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: AppSpaces.heightLarge),

                      // Request Details
                      _sectionTitle("تفاصيل الطلب"),
                      controller.request.snapshot.specialization != null
                          ? _infoRow("الاختصاص",
                              controller.request.snapshot.specialization!.name)
                          : _infoRow("نوع العميل",
                              controller.request.snapshot.clientType!),
                      _infoRow(
                          controller.request.userType == UserRole.freelancer
                              ? "المسمى الوظيفي"
                              : "مجال العمل",
                          controller.request.snapshot.jobTitle),

                      const SizedBox(height: 10),

                      // Bio
                      _sectionTitle("نبذة"),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(AppSpaces.paddingMedium - 1),
                        decoration: _box(),
                        child: Text(controller.request.snapshot.bio),
                      ),

                      const SizedBox(height: 20),

                      // Skills
                      controller.request.snapshot.skills != null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _sectionTitle("المهارات"),
                                SkillsCards(
                                    skills:
                                        controller.request.snapshot.skills!),
                                // Wrap(
                                //   spacing: 8,
                                //   children: controller.request.snapshot.skills!
                                //       .map((e) => Chip(
                                //           label: Text(e),
                                //           backgroundColor:
                                //               AppColors.lightPurple))
                                //       .toList(),
                                // )
                              ],
                            )
                          : SizedBox.shrink(),

                      const SizedBox(height: 20),

                      // Work Samples
                      controller.request.snapshot.workSamples.isNotEmpty
                          ? _sectionTitle("عينات الأعمال")
                          : SizedBox.shrink(),
                      controller.request.snapshot.workSamples.isNotEmpty
                          ? Obx(() {
                              return Column(
                                  children: List.generate(
                                      controller.request.snapshot.workSamples
                                          .length, (i) {
                                if (controller.expendedWork.value == i) {
                                  return InkWell(
                                    onTap: () => controller.onWorkExpend(i),
                                    child: ProfileWorkCard(
                                      work: controller
                                          .request.snapshot.workSamples[i],
                                    ),
                                  );
                                }

                                return _fileTile(
                                    controller
                                        .request.snapshot.workSamples[i].title,
                                    () => controller.onWorkExpend(i));
                              }));
                            })
                          : SizedBox.shrink(),

                      const SizedBox(height: 20),

                      /// Certificates
                      controller.request.snapshot.certificates.isNotEmpty
                          ? _sectionTitle("الشهادات")
                          : SizedBox.shrink(),
                      controller.request.snapshot.certificates.isNotEmpty
                          ? Column(
                              children: List.generate(
                                  controller.request.snapshot.certificates
                                      .length, (i) {
                              return ProfileCertificateTile(
                                certificate:
                                    controller.request.snapshot.certificates[i],
                                isOwnProfile: false,
                              );
                            }))
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
                // }),
                bottomNavigationBar: controller.request.status ==
                        RequestStatus.pending
                    ? Container(
                        margin: EdgeInsets.all(10),
                        // color: AppColors.white,
                        child: Row(
                          children: [
                            Expanded(
                                child: CustomButton(
                              color: AppColors.red,
                              text: "Reject",
                              onTap: () {
                                Get.bottomSheet(CustomBottomSheetContainer(
                                  children: [
                                    Text("رفض الطلب المقدم",
                                        style: AppTextStyles.heading
                                        // .copyWith(color: AppColors.black),
                                        ),
                                    Text(
                                      "انت على وشك رفض الطلب المقدم لهذا المستخدم ، الرجاء ادخال سبب الرفض :",
                                      style: AppTextStyles.body
                                          .copyWith(color: AppColors.black),
                                    ),
                                    SizedBox(
                                      height: AppSpaces.heightMedium,
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Text(
                                        "التعليق",
                                        style: AppTextStyles.inputLabel
                                            .copyWith(
                                                color: AppColors.lightPurple),
                                      ),
                                    ),
                                    CustomTextField(
                                        onChanged: (val) => controller
                                                .rejectComment =
                                            val // hintText: "ادخل سبب الرفض",
                                        ),
                                    SizedBox(
                                      height: AppSpaces.heightLarge,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CustomButton(
                                          width: 100.w,
                                          text: "رفض",
                                          onTap: () async =>
                                              await controller.onReject(),
                                        ),
                                        SizedBox(
                                          width: AppSpaces.heightMedium2,
                                        ),
                                        CustomButton(
                                          textStyle: AppTextStyles.button
                                              .copyWith(
                                                  color: AppColors.purple),
                                          color: AppColors.white,
                                          width: 100.w,
                                          text: "إلغاء",
                                          onTap: () => Get.back(),
                                        ),
                                      ],
                                    )
                                  ],
                                ));
                              },
                            )),
                            const SizedBox(width: 10),
                            Expanded(
                                child: CustomButton(
                                    color: AppColors.green,
                                    text: "Accept",
                                    onTap: controller.onAccept)),
                          ],
                        ),
                      )
                    : controller.request.status == RequestStatus.approved
                        ? Padding(
                            padding: EdgeInsets.all(AppSpaces.paddingLarge),
                            child: CustomButton(
                                color: AppColors.red,
                                text: "حذف الطلب",
                                prefix: Icon(
                                  Icons.delete_forever,
                                  color: AppColors.white,
                                ),
                                onTap: () => Get.defaultDialog(
                                    title: "تحذير",
                                    middleText: "هل انت متأكد من حذف الطلب ؟",
                                    textConfirm: "حذف",
                                    textCancel: "إلغاء",
                                    onConfirm: controller.deleteRequest)),
                          )
                        : Padding(
                            padding: EdgeInsets.all(AppSpaces.paddingLarge),
                            child: CustomButton(
                                color: AppColors.red,
                                text: "حذف الطلب و المستخدم",
                                prefix: Icon(
                                  Icons.delete_forever,
                                  color: AppColors.white,
                                ),
                                onTap: () => Get.defaultDialog(
                                    title: "تحذير",
                                    middleText:
                                        "هل انت متأكد من حذف المستخدم والطلب ؟",
                                    textConfirm: "حذف",
                                    textCancel: "إلغاء",
                                    onConfirm:
                                        controller.deleteUserAndRequest)),
                          )),
          );
        });
  }

  /// ================= UI Helpers =================

  Widget _sectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpaces.paddingSmall + 2),
      child: Text(
        title,
        style: AppTextStyles.blacksubheading.copyWith(fontSize: 18.sp),
        // style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold , ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSpaces.paddingSmall),
      padding: EdgeInsets.all(AppSpaces.paddingSmall + 2),
      decoration: _box(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _fileTile(String title, VoidCallback onclick) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSpaces.paddingMedium),
      padding: const EdgeInsets.all(12),
      decoration: _box(),
      child: Row(
        children: [
          const Icon(Icons.insert_drive_file, color: AppColors.purple),
          SizedBox(width: AppSpaces.heightSmall),
          Expanded(child: Text(title)),
          TextButton(
            onPressed: onclick,
            child: const Text("View"),
          )
        ],
      ),
    );
  }

  BoxDecoration _box() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 5,
        )
      ],
    );
  }
}
