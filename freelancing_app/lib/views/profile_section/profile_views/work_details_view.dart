import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';
import 'package:freelancing_platform/core/widgets/custom_empty_data_text.dart';
import 'package:freelancing_platform/core/widgets/custom_loading.dart';
import 'package:freelancing_platform/views/profile_section/profile_controllers/work_details_controller.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class WorkDetailsView extends StatelessWidget {
  const WorkDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    
    return GetBuilder<WorkDetailsController>(
        init: Get.find<WorkDetailsController>(),
        builder: (controller) {
          return ModalProgressHUD(
            inAsyncCall: controller.isPageLoading,
            child: Scaffold(
              backgroundColor: Colors.grey.shade100,
              body: Column(
                children: [
                  // Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                      top: 50,
                      right: 18,
                      left: 18,
                      bottom: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(AppSpaces.radiusSmall)),
                      gradient: AppColors.gradientColor,
                    ),
                    child: Row(
                      children: [
                        // زر رجوع
                        IconButton(
                            icon: const Icon(Icons.arrow_back),
                            color: AppColors.white,
                            onPressed: () => Get.back()),

                        const Spacer(),

                        Text("تفاصيل العمل",
                            style: AppTextStyles.heading
                                .copyWith(color: AppColors.white)),

                        const Spacer(),

                        // الثلاث نقاط
                        controller.isOwnProfile && !controller.isNewWork
                            ? PopupMenuButton(
                                icon: const Icon(Icons.more_vert,
                                    color: AppColors.white),
                                onSelected: controller.onSelectOption,
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: "edit",
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit, size: 18),
                                        SizedBox(width: 8),
                                        controller.isEditing
                                            ? Text("إلغاء")
                                            : Text("تعديل"),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: "delete",
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete,
                                            color: Colors.red, size: 18),
                                        SizedBox(width: 8),
                                        Text("حذف"),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox.shrink()
                      ],
                    ),
                  ),

                  // Body
                  Expanded(
                    /// إذا في بيانات
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //title

                          box(
                            child: controller.isEditing
                                ? TextField(
                                    controller: controller.titleC,
                                    decoration: InputDecoration(
                                      hintText: "ادخل عنوان العمل",
                                      hintStyle: TextStyle(
                                        color: AppColors.grey,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                : Text(
                                    controller.work.title,
                                    style: const TextStyle(
                                      color: AppColors.purple,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),

                          const SizedBox(height: 18),

                          GestureDetector(
                            onTap: controller.isEditing
                                ? controller.selectNewImage
                                : null,
                            child: SizedBox(
                                width: double.infinity,
                                child: controller.newImageFile != null
                                    ? Image.file(
                                        controller
                                            .newImageFile!, //غير مدعومه بالويب هي الويدجيت
                                        fit: BoxFit.cover)
                                    : controller.work.imageUrl != null &&
                                            controller.work.imageUrl!
                                                .trim()
                                                .isNotEmpty
                                        ? CachedNetworkImage(
                                            imageUrl:
                                                controller.work.imageUrl ?? '',
                                            placeholder: (context, url) =>
                                                const CustomLoading(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(
                                              Icons.image_not_supported_rounded,
                                              color: AppColors.darkPurple,
                                              size: 100,
                                            ),
                                            fit: BoxFit.cover,
                                          )
                                        : GestureDetector(
                                            onTap: controller.isEditing
                                                ? controller.selectNewImage
                                                : null,
                                            child: Column(
                                              children: [
                                                Icon(
                                                  controller.isEditing
                                                      ? Icons
                                                          .add_a_photo_rounded
                                                      : Icons
                                                          .no_photography_rounded,
                                                  color: AppColors.darkPurple,
                                                  size: 100,
                                                ),
                                                customEmptyMessage(
                                                    message: controller
                                                            .isEditing
                                                        ? "اضف صورة للعمل"
                                                        : "لا يوجد صورة للعمل"),
                                              ],
                                            ),
                                          )),
                          ),
                          // }),

                          const SizedBox(height: 18),

                          /// Description
                          const Text(
                            "وصف العمل",
                            style: TextStyle(
                              color: AppColors.purple,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 10),

                          box(
                            child: controller.isEditing
                                ? TextField(controller: controller.descC)
                                : Text(controller.work.description),
                          ),

                          const SizedBox(height: 25),

                          if (controller.isEditing)
                            Center(
                              child: ElevatedButton(
                                onPressed: controller.isNewWork
                                    ? controller.saveNewWork
                                    : controller.saveChange,
                                child: Text(controller.isNewWork
                                    ? "إضافة العمل"
                                    : "حفظ التعديلات"),
                              ),
                            ),
                        ],
                      ),
                    ),
                    // }
                  ),
                  // ),
                ],
              ),
            ),
          );
        });
    // );
  }

  /// Card UI
  Widget box({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: child,
    );
  }
}