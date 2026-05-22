import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/project_status.dart';
import 'package:freelancing_platform/core/widgets/custom_app_bar.dart';
import 'package:freelancing_platform/core/widgets/custom_button.dart';
import 'package:freelancing_platform/core/widgets/custom_error_widget.dart';
import 'package:freelancing_platform/core/widgets/custom_loading.dart';
import 'package:freelancing_platform/core/widgets/get_rerponse_handler.dart';
import 'package:freelancing_platform/views/project_section/project_controller/project_details_controller.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

const Color softPurple = Color(0xffA99CFF);

class ProjectDetailsView extends StatelessWidget {
  const ProjectDetailsView({super.key});
  // final String? projectId =
  //     NavigationService.routeArguments(AppRoutes.projectDetails)?['projectId'];
  // final controller = Get.put(ProjectDetailsController(),
  //     tag: NavigationService.routeArguments(
  //         AppRoutes.projectDetails)?['projectId']);

  @override
  Widget build(BuildContext context) {
    //هالطريقه بتمرير البيانات اشتغلت واجتت البيانات من الarguments بس المشكله كانت بان لازم اعملها بالbuild ما بتنعمل بالكنترولر قبل بناء الصفحه
    // final project =
    //     NavigationService.arguments<Map<String, ProjectModel>>(context);

    // if (controller.project == null) {
    //   return BaseScreen(
    //     body: Center(
    //       child: CustomErrorWidget(
    //         message: "تعذر تحميل بيانات المشروع",
    //       ),
    //     ),
    //   );
    // }
    return GetBuilder<ProjectDetailsController>(
        // init: Get.find<ProjectDetailsController>(),
        builder: (c) {
      if (c.pageState == StatusClasses.isloading) {
        return CustomLoading();
      }
      if (c.pageState != StatusClasses.isloading && c.project == null) {
        return CustomErrorWidget(
          message: "تعذر تحميل المشروع",
        );
      }

      return ModalProgressHUD(
        inAsyncCall: c.loadingDelete,
        child: UiStateHandler(
          status: c.pageState,
          fetchDataFun: c.loadProject,
          child: Scaffold(
            backgroundColor: Colors.grey.shade100,

            // App Bar
            appBar: CustomAppBar(
              title: "تفاصيل المشروع",
              backgroundGradient: AppColors.gradientColor,
              trailingIcon: c.isOwnProject &&
                      c.project!.status == ProjectStatus.newProject
                  ? PopupMenuButton(
                      icon: const Icon(Icons.more_vert, color: AppColors.white),
                      onSelected: (val) => c.onDeleteProject(),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: "delete",
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red, size: 18),
                              SizedBox(width: 8),
                              Text("حذف"),
                            ],
                          ),
                        ),
                      ],
                    )
                  : SizedBox.shrink(),
            ),

            body: SingleChildScrollView(
              padding: EdgeInsets.all(AppSpaces.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!c.isOwnProject)
                    sectionCard(
                      child: InkWell(
                        onTap: () {
                          // print(controller.project!.clientId);
                          Get.toNamed(
                            AppRoutes.userProfile,
                            arguments: {"userId": c.project!.clientId},
                          );
                        },
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 22,
                              backgroundColor: AppColors.lightPurple,
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                            SizedBox(width: AppSpaces.heightSmall),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "صاحب المشروع",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.purple,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "اضغط لعرض الملف الشخصي",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),

                  /// عنوان المشروع
                  sectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        title("عنوان المشروع"),
                        SizedBox(height: AppSpaces.heightSmall),
                        Text(
                          c.project!.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // وصف المشروع
                  sectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        title("وصف المشروع"),
                        SizedBox(height: AppSpaces.heightSmall),
                        Text(
                          c.project!.description,
                          style: const TextStyle(height: 1.7, fontSize: 15),
                        ),
                      ],
                    ),
                  ),

                  /// الميزانية
                  sectionCard(
                    child: infoRow(
                      Icons.attach_money,
                      "الميزانية",
                      c.project!.budget.toString(),
                    ),
                  ),

                  // مدة التنفيذ
                  sectionCard(
                    child: infoRow(
                      Icons.timer,
                      "مدة التنفيذ",
                      "${c.project!.durationDays.toString()} يوم",
                    ),
                  ),

                  // التخصص
                  sectionCard(
                    child: infoRow(
                      Icons.work,
                      "التصنيف",
                      c.project!.category.name,
                    ),
                  ),

                  /// المهارات المطلوبة
                  sectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        title("المهارات المطلوبة"),
                        SizedBox(height: AppSpaces.heightSmall),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: c.project!.skillsRequired
                              .map((skill) => skillChip(skill))
                              .toList(),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: AppSpaces.heightMedium),

                  // زر تقديم عرض + زر العروض المقدّمة (للفريلانسر) أو عرض العروض للعميل
                  if (c.project!.status == ProjectStatus.newProject)
                    if (c.isFreelancer)
                      Obx(() => Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: CustomButton(
                                      isLoading: c.loadingCheckOldOffer.value,
                                      text: c.hasOffer.value
                                          ? 'تعديل العرض المرسل'
                                          : 'تقديم عرض',
                                      height: 44,
                                      width: null,
                                      onTap: c.onOfferSubmit,
                                      prefix: Icon(
                                        c.hasOffer.value
                                            ? Icons.mode
                                            : Icons.send_rounded,
                                        color: AppColors.white,
                                        size: 18.sp,
                                      ),
                                      gradient: AppColors.gradientColor,
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Expanded(
                                    child: CustomButton(
                                      text: 'العروض المقدَّمة',
                                      height: 44,
                                      width: null,
                                      onTap: c.onOfferView,
                                      buttonType: ButtonType.outlined,
                                      color: AppColors.vividPurple,
                                      textStyle: AppTextStyles.link.copyWith(
                                        color: AppColors.vividPurple,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      prefix: Icon(
                                        Icons.visibility_outlined,
                                        color: AppColors.vividPurple,
                                        size: 18.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (c.hasOffer.value) ...[
                                SizedBox(height: 15.h),
                                CustomButton(
                                  onTap: c.withdrawOffer,
                                  prefix: Icon(
                                    Icons.delete_outline,
                                    color: AppColors.red,
                                  ),
                                  text: "سحب العرض",
                                  buttonType: ButtonType.outlined,
                                  color: Colors.red,
                                  textStyle: AppTextStyles.link.copyWith(
                                    color: Colors.red,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ],
                          )),

                  if (!c.isFreelancer)
                    CustomButton(
                      text: "عرض العروض المستلمة",
                      onTap: c.onOfferView,
                      prefix: const Icon(
                        Icons.content_paste,
                        color: AppColors.white,
                      ),
                      gradient: AppColors.gradientColor,
                    ),
                  SizedBox(height: AppSpaces.heightMedium),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  /// Card
  Widget sectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpaces.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  // Section Title
  Widget title(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.purple,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  /// Info Row
  Widget infoRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.purple),
        const SizedBox(width: 12),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.purple,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  /// Skill Chip
  Widget skillChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: softPurple.withOpacity(0.15),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style: const TextStyle(
            color: AppColors.purple, fontWeight: FontWeight.bold),
      ),
    );
  }
}
