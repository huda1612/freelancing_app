import 'dart:io';
import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/widgets/custom_loading.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

class WorkItemWidget extends StatelessWidget {

  final int index;

  final RxList<Map<String, Object?>> workItems;
  final Future<void> Function(int, String) uploadImage;
  final void Function(int) removeWorkItem;
  final bool Function(int) validateWork;
  const WorkItemWidget({
    super.key,
    required this.index,
    required this.workItems,
    required this.uploadImage,
    required this.removeWorkItem,
    required this.validateWork,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (index < 0 || index >= workItems.length) {
        return const SizedBox.shrink();
      }

      final item = workItems[index];

      final isValid = item["valid"] == true;
      final imageUrl = (item["image"] ?? "").toString();
      final file = item["localImage"] as File?;
      final uploading = item["uploading"] == true;

      return Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isValid ? Colors.green : Colors.grey.shade300,
            width: isValid ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                // صورة
                GestureDetector(
                  onTap: () async {
                    await uploadImage(index, "work");
                    // var imgurl = await controller
                    //     .pickAndUpload(AppImagePreset.workSamplesPreset);
                    // if (imgurl == null) {
                    //   if (controller.error != null) {
                    //     Get.snackbar("حدث خطأ ما", "${controller.error}");
                    //   } else {
                    //     Get.snackbar("خطأ", "لم يتم اختيار صورة");
                    //   }
                    // } else {
                    //   final updatedItem = Map<String, Object?>.from(item);
                    //   updatedItem["image"] = imgurl;
                    //   workItems[index] = updatedItem;
                    //   workItems.refresh();
                    // }

                    // // final picker = ImagePicker();
                    // // final picked =
                    // //     await picker.pickImage(source: ImageSource.gallery);

                    // // if (picked == null) return;

                    // // File file = File(picked.path);
                    // File? file = await ImageService.pickImage();

                    // // 🔥 عرض الصورة مباشرة
                    // final tempItem = Map<String, Object>.from(item);
                    // tempItem["localImage"] = file;
                    // tempItem["uploading"] = true;

                    // workItems[index] = tempItem;
                    // workItems.refresh();

                    // // 🔼 رفع للصورة
                    // final result = await ImageService.uploadImage(
                    //     AppImagePreset.workSamplesPreset, file);

                    // result.fold(
                    //   (error) {
                    //     tempItem["uploading"] = false;
                    //     workItems[index] = tempItem;
                    //     workItems.refresh();
                    //   },
                    //   (url) {
                    //     final updatedItem = Map<String, Object>.from(tempItem);
                    //     updatedItem["image"] = url;
                    //     updatedItem["localImage"] = null; // حذف المؤقت
                    //     updatedItem["uploading"] = false;

                    //     workItems[index] = updatedItem;
                    //     workItems.refresh();
                    //   },
                    // );
                    // final updatedItem = Map<String, Object>.from(item);
                    // updatedItem["uploading"] = true;

                    // workItems[index] = updatedItem;
                    // workItems.refresh();

                    // String url = await uploadImage();

                    // final newItem = Map<String, Object>.from(updatedItem);
                    // newItem["uploading"] = false;
                    // newItem["image"] = url;

                    // workItems[index] = newItem;
                    // workItems.refresh();
                  },
                  child: Container(
                    width: 70,
                    height: 70,
                    color: Colors.grey.shade200,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (file != null)
                          Image.file(file, fit: BoxFit.cover)
                        else if (imageUrl.isNotEmpty)
                          CachedNetworkImage(
                            imageUrl: imageUrl,
                            placeholder: (context, url) =>
                                const CustomLoading(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            fit: BoxFit.cover,
                          )
                        else
                          const Icon(Icons.add_a_photo),
                        if (uploading) const CustomLoading(),
                      ],
                    ),
                    // child: Stack(
                    //   fit: StackFit.expand,
                    //   children: [
                    //     // 👇 local أولًا (أهم شي)
                    //     if (controller.localImage != null)
                    //       Image.file(controller.localImage!,
                    //           fit: BoxFit.cover),

                    //     // 👇 network فوقها
                    //     if (controller.imageUrl.isNotEmpty)
                    //       CachedNetworkImage(
                    //         imageUrl: controller.imageUrl,
                    //         fit: BoxFit.cover,
                    //       ),

                    //     // 👇 loading
                    //     if (controller.isUploading)
                    //       const Center(child: CustomLoading()),

                    //     // 👇 fallback
                    //     if (!controller.hasImage &&
                    //         !controller.isUploading)
                    //       const Icon(Icons.add_a_photo),
                    //   ],
                    // ),

                    // controller.localImage != null
                    //     ? Image.file(controller.localImage!,
                    //         fit: BoxFit.cover)
                    //     : controller.imageUrl.isNotEmpty
                    //         ? CachedNetworkImage(
                    //             imageUrl: controller.imageUrl,
                    //             fit: BoxFit.cover,
                    //           )
                    //         : controller.isUploading
                    //             ? CustomLoading()
                    //             : const Icon(Icons.add_a_photo),

                  ),
                ),

                SizedBox(width: 12),

                // عنوان
                Expanded(
                  child: TextFormField(
                    initialValue: item["title"] as String,
                    decoration: InputDecoration(labelText: "عنوان العمل"),
                    onChanged: (v) {
                      item["title"] = v;
                      validateWork(index);
                    },
                  ),
                ),

                // حذف
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => removeWorkItem(index),
                ),
              ],
            ),
            TextFormField(
              initialValue: item["description"] as String,
              decoration: InputDecoration(labelText: "الوصف"),
              onChanged: (v) {
                item["description"] = v;
                validateWork(index);
              },
            ),
          ],
        ),
      );
    });
  }
}
