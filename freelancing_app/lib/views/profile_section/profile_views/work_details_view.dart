import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';
import 'package:freelancing_platform/core/widgets/CustomEmptyDataText.dart';
import 'package:freelancing_platform/core/widgets/custom_loading.dart';
import 'package:freelancing_platform/views/profile_section/profile_controllers/work_details_controller.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

// const Color mainPurple = Color(0xff6C63FF);
// const Color softPurple = Color(0xffA99CFF);

class WorkDetailsView extends StatelessWidget {
  const WorkDetailsView({super.key});

  // final controller = Get.find<WorkDetailsController>();

  @override
  Widget build(BuildContext context) {
    return
        // Directionality(
        // textDirection: TextDirection.rtl,
        // child:
        GetBuilder<WorkDetailsController>(
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
                              onPressed: () {
                                controller.hasChanged
                                    ? Get.back(result: controller.work)
                                    : Get.back();
                              },
                            ),

                            const Spacer(),

                            Text("تفاصيل العمل",
                                style: AppTextStyles.heading
                                    .copyWith(color: AppColors.white)),

                            const Spacer(),

                            // الثلاث نقاط
                            controller.isOwnProfile
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
                                    ? TextField(controller: controller.titleC)
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

                              // box(
                              //     child: CachedNetworkImage(
                              //   imageUrl: controller.work.imageUrl ?? '',
                              //   placeholder: (context, url) =>
                              //       const CustomLoading(),
                              //   errorWidget: (context, url, error) =>
                              //       const Icon(Icons.error),
                              //   fit: BoxFit.cover,
                              // )),

                              // Image
                              // GetBuilder<ImageUploadController>(
                              // init: Get.find<ImageUploadController>(),
                              // builder: (imageController) {
                              // return

                              GestureDetector(
                                onTap: controller.isEditing
                                    ? controller.selectNewImage
                                    : null,
                                child: SizedBox(
                                    width: double.infinity,
                                    child: controller.newImageFile != null
                                        ? Image.file(controller.newImageFile!,
                                            fit: BoxFit.cover)
                                        : controller.work.imageUrl != null &&
                                                controller
                                                    .work.imageUrl!.isNotEmpty
                                            ? CachedNetworkImage(
                                                imageUrl:
                                                    controller.work.imageUrl ??
                                                        '',
                                                placeholder: (context, url) =>
                                                    const CustomLoading(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                                fit: BoxFit.cover,
                                              )
                                            : customEmptyMessage(
                                                message: "لا يوجد صورة للعمل")),
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
                                    onPressed: controller.saveChange,
                                    // onPressed: () {
                                    //   controller.updateData(
                                    //     controller.titleC.text,
                                    //     controller.imageC.text,
                                    //     controller.descC.text,
                                    //   );

                                    //   controller.isEditing = false;
                                    // },
                                    child: const Text("حفظ التعديلات"),
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

                  /// Bottom Nav
                  // bottomNavigationBar: BottomNavigationBar(
                  //   currentIndex: 2,
                  //   selectedItemColor: mainPurple,
                  //   unselectedItemColor: Colors.grey,
                  //   items: const [
                  //     BottomNavigationBarItem(icon: Icon(Icons.home), label: "الرئيسية"),
                  //     BottomNavigationBarItem(icon: Icon(Icons.search), label: "بحث"),
                  //     BottomNavigationBarItem(icon: Icon(Icons.person), label: "حسابي"),
                  //   ],
                  // ),
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
