import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/project_status.dart';
// import 'package:freelancing_platform/core/services/navigation_service.dart';
import 'package:freelancing_platform/core/widgets/base_screen.dart';
import 'package:freelancing_platform/core/widgets/custom_app_bar.dart';
import 'package:freelancing_platform/core/widgets/custom_button.dart';
import 'package:freelancing_platform/core/widgets/custom_error_widget.dart';
import 'package:freelancing_platform/views/project_section/project_controller/project_details_controller.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

const Color softPurple = Color(0xffA99CFF);

class ProjectDetailsView extends StatelessWidget {
  ProjectDetailsView({super.key});

  final controller = Get.find<ProjectDetailsController>();

  @override
  Widget build(BuildContext context) {
    //هالطريقه بتمرير البيانات اشتغلت واجتت البيانات من الarguments بس المشكله كانت بان لازم اعملها بالbuild ما بتنعمل بالكنترولر قبل بناء الصفحه
    // final project =
    //     NavigationService.arguments<Map<String, ProjectModel>>(context);
    // print("!!!!!!!!!!!!!! + $project");
    if (controller.project == null) {
      return BaseScreen(
        body: Center(
          child: CustomErrorWidget(
            message: "تعذر تحميل بيانات المشروع",
          ),
        ),
      );
    }
    return GetBuilder<ProjectDetailsController>(builder: (c) {
      return ModalProgressHUD(
        inAsyncCall: c.loadingDelete,
        child: Scaffold(
          backgroundColor: Colors.grey.shade100,

          // App Bar
          appBar: CustomAppBar(
            title: "تفاصيل المشروع",
            backgroundGradient: AppColors.gradientColor,
            trailingIcon: controller.isOwnProject &&
                    controller.project!.status == ProjectStatus.newProject
                ? PopupMenuButton(
                    icon: const Icon(Icons.more_vert, color: AppColors.white),
                    onSelected: (val) => controller.onDeleteProject(),
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
                if (!controller.isOwnProject)
                  sectionCard(
                    child: InkWell(
                      onTap: () {
                        // print(controller.project!.clientId);
                        Get.toNamed(
                          AppRoutes.userProfile,
                          arguments: {"userId": controller.project!.clientId},
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
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
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
                        controller.project!.title,
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
                        controller.project!.description,
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
                    controller.project!.budget.toString(),
                  ),
                ),

                // مدة التنفيذ
                sectionCard(
                  child: infoRow(
                    Icons.timer,
                    "مدة التنفيذ",
                    "${controller.project!.durationDays.toString()} يوم",
                  ),
                ),

                // التخصص
                sectionCard(
                  child: infoRow(
                    Icons.work,
                    "التصنيف",
                    controller.project!.category.name,
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
                        children: controller.project!.skillsRequired
                            .map((skill) => skillChip(skill))
                            .toList(),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: AppSpaces.heightMedium),

                // زر تقديم عرض + زر العروض المقدّمة (للفريلانسر) أو عرض العروض للعميل
                if (controller.project!.status == ProjectStatus.newProject)
                  // GetBuilder<ProjectDetailsController>(
                  //   builder:
                  if (controller.isFreelancer)
                    Obx(() => Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: CustomButton(
                                isLoading:
                                    controller.loadingCheckOldOffer.value,
                                text: controller.hasOffer.value
                                    ? 'تعديل العرض المرسل'
                                    : 'تقديم عرض',
                                height: 44,
                                width: null,
                                onTap: controller.onOfferSubmit,
                                prefix: Icon(
                                  controller.hasOffer.value
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
                                onTap: controller.onOfferView,
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
                        )),
                if (!controller.isFreelancer)
                  CustomButton(
                    text: "عرض العروض المستلمة",
                    onTap: controller.onOfferView,
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
