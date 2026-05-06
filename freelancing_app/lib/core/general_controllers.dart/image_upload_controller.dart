import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/services/image_service.dart';
import 'package:get/get.dart';

class ImageUploadController extends GetxController {
  File? localImage;
  String imageUrl = "";

  bool isUploading = false;
  // String? error;

  /// اختيار صورة + preview فوري + رفع
  Future<Either<StatusClasses, String>> pickAndUpload(
    String presetName, {
    // String? groupName,
    String? publicId,
    // String? folder,
    // bool overwrite = false,
  }) async {
    // error = null;

    final file = await ImageService.pickImage();
    if (file == null) {
      // Get.snackbar("تنبيه", "لم يتم اختيار صورة");
      // return Left(StatusClasses.idle);
      return Left(StatusClasses.customError("لم يتم اختيار صورة"));
    }
    // preview فوري
    localImage = file;
    isUploading = true;
    update();

    // ضغط الصورة
    final compressedFile = await ImageService.compressImage(file);
    // إذا فشل الضغط، استخدم الأصل
    final fileToUpload = compressedFile ?? file;
    debugPrint("!!!!!!!!!!!!!Original size: ${file.lengthSync()} bytes");
    debugPrint("Compressed size: ${fileToUpload.lengthSync()} bytes");
    // نستخدم التابع اللي عملناه لرفع الصوره لل API

    final result = await ImageService.uploadImage(
      presetName,
      fileToUpload,
      // groupName: groupName,
      publicId: publicId,
      // folder: folder,
      // overwrite: overwrite,
    );

    return result.fold(
      (err) {
        // error = err.message;
        localImage = null;
        isUploading = false;
        update();
        return Left(err);
      },
      (url) {
        imageUrl = url;
        localImage = null;
        isUploading = false;
        update();
        return Right(url);
      },
    );
  }

  void reset() {
    localImage = null;
    imageUrl = "";
    isUploading = false;
    update();
  }

  /// عرض الصورة الحالية (المحلية أو من الإنترنت)
  bool get hasImage => localImage != null || imageUrl.isNotEmpty;
}

//طريقة الاستخدام
// GetBuilder<ImageUploadController>(
//   builder: (c) {
//     return GestureDetector(
//       onTap: () => c.pickAndUpload("work_preset"),
//       child: Container(
//         width: 70,
//         height: 70,
//         color: Colors.grey.shade200,
//         child: Stack(
//           fit: StackFit.expand,
//           children: [
//             //  عرض الصورة
//             if (c.localImage != null)
//               Image.file(c.localImage!, fit: BoxFit.cover)
//             else if (c.imageUrl.isNotEmpty)
//               CachedNetworkImage(
//                 imageUrl: c.imageUrl,
//                 fit: BoxFit.cover,
//               )
//             else
//               const Icon(Icons.add_a_photo),

//             //  loading
            // if (c.isUploading)
//               const Center(child: CircularProgressIndicator()),
//           ],
//         ),
//       ),
//     );
//   },
// );