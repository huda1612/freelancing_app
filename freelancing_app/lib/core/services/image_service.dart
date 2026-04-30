import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/utils/helper_function/check_internet.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
//طريقه اختيار و رفع صورة
// final result = await ImageService.pickAndUploadImage("profile_preset");
// result.fold(
//   (error) {
//     //  في خطأ
//     print("Error: $error");
//   },
//
//   (imageUrl) {
//     //  نجح الرفع
//     print("Image URL: $imageUrl");
//   },
// );

class ImageService {
  static Future<File?> pickImage() async {
    try {
      //اول شي المستخدم بيختار صورة
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);

      if (picked == null) {
        //لو ما اختار
        return null;
      }

      //مناخد عنوان ملف الصورة بجهازه
      File imageFile = File(picked.path);

      // نستخدم التابع اللي عملناه لرفع الصوره لل API
      // final result = await ImageService.uploadImage(presetName, imageFile);

      return imageFile;
    } catch (e) {
      return null;
    }
  }

  static Future<Either<StatusClasses, String>> pickAndUploadImage(
      String presetName) async {
    try {
      //مناخد عنوان ملف الصورة بجهازه
      final imageFile = await pickImage();
      if (imageFile == null) {
        return Left(StatusClasses.customError("لم يتم اختيار صورة"));
      }
      // نستخدم التابع اللي عملناه لرفع الصوره لل API
      final result = await ImageService.uploadImage(presetName, imageFile);

      return result;
    } catch (e) {
      return Left(StatusClasses.customError("Unexpected error"));
    }
  }

  static Future<Either<StatusClasses, String>> uploadImage(
      String presetName, File imageFile) async {
    try {
      if (await checkInternet()) {
        const clodeName = "dyylbz73y";
        final url = Uri.parse(
            "https://api.cloudinary.com/v1_1/$clodeName/image/upload");

        final request = http.MultipartRequest("POST", url);

        request.fields['upload_preset'] = presetName;

        request.files.add(
          await http.MultipartFile.fromPath(
            'file',
            imageFile.path,
            // contentType: MediaType('image', 'jpeg'),
          ),
        );

        final response = await request.send();

        if (response.statusCode == 200) {
          final resBody = await response.stream.bytesToString();

          final secureUrl = jsonDecode(resBody)['secure_url'];

          return Right(secureUrl);
        } else {
          return Left(StatusClasses.customError("حدث خطأ ما"));
        }
      } else {
        return const Left(StatusClasses.offlineError);
      }
    } on SocketException {
      // print("Network error");
      return Left(StatusClasses.customError("Network error"));
    } catch (e) {
      print("An unexpected error occured $e");
      return Left(StatusClasses.customError("An unexpected error occured"));
    }
  }
}
