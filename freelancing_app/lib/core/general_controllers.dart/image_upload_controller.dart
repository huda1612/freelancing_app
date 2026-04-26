import 'dart:io';
import 'package:freelancing_platform/core/services/image_service.dart';
import 'package:get/get.dart';

class ImageUploadController extends GetxController {
  File? localImage;
  String imageUrl = "";

  bool isUploading = false;
  String? error;

  /// اختيار صورة + preview فوري + رفع
  Future<String?> pickAndUpload(String presetName) async {
    error = null;

    final file = await ImageService.pickImage();
    if (file == null) return null;

    // 🔥 preview فوري
    localImage = file;
    isUploading = true;
    update();

    final result = await ImageService.uploadImage(presetName, file);

    return result.fold(
      (err) {
        error = err.message;
        isUploading = false;
        update();
        return null;
      },
      (url) {
        imageUrl = url;
        isUploading = false;
        update();
        return url;
      },
    );
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
//             if (c.isUploading)
//               const Center(child: CircularProgressIndicator()),
//           ],
//         ),
//       ),
//     );
//   },
// );