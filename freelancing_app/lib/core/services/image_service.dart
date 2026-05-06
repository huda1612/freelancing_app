import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/utils/helper_function/check_internet.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

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
// بيشتغل هيك:
// نفس public_id 👉 يتم الاستبدال
// public_id مختلف 👉 تنحفظ صورة جديدة
// صورة وحدة (مثل بروفايل)	public_id ثابت
// عدة صور (مثل أعمال)	public_id متغير
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
      debugPrint("Error picking image: $e");
      return null;
    }
  }

  static Future<Either<StatusClasses, String>> pickAndUploadImage(
    String presetName, {
    String? publicId,
    // String? folder,
    // String? groupName,
    // bool overwrite = false
  }) async {
    try {
      //مناخد عنوان ملف الصورة بجهازه
      final imageFile = await pickImage();
      if (imageFile == null) {
        return Left(StatusClasses.customError("لم يتم اختيار صورة"));
      }
      // ضغط الصورة
      final compressedFile = await compressImage(imageFile);
      // إذا فشل الضغط، استخدم الأصل
      final fileToUpload = compressedFile ?? imageFile;
      print("Original size: ${imageFile.lengthSync()} bytes");
      print("Compressed size: ${fileToUpload.lengthSync()} bytes");
      // نستخدم التابع اللي عملناه لرفع الصوره لل API
      final result = await ImageService.uploadImage(presetName, fileToUpload,
          publicId: publicId);

      return result;
    } catch (e) {
      return Left(StatusClasses.customError("Unexpected error"));
    }
  }

  static Future<Either<StatusClasses, String>> uploadImage(
    String presetName,
    File imageFile, {
    String? publicId,
  
  }) async {
    try {
      if (await checkInternet()) {
        const cloudName = "dyylbz73y";
        final url = Uri.parse(
            "https://api.cloudinary.com/v1_1/$cloudName/image/upload");

        final request = http.MultipartRequest("POST", url);

        request.fields['upload_preset'] = presetName;

        //هو اسم/مسار الصورة داخل Cloudinary (public_id)
        // مثال
        // "users/$uId/profile"
        // "projects/$projectId/image"
        // "messages/$chatId/image"
        //صار عندك "مفتاح" للصورة

        if (publicId != null) {
          request.fields['public_id'] = publicId;
        }

        request.files.add(
          await http.MultipartFile.fromPath(
            'file',
            imageFile.path,
            // contentType: MediaType('image', 'jpeg'),
          ),
        );

        final response = await request.send();
        final responseBody = await response.stream.bytesToString();

        if (response.statusCode == 200) {
          final secureUrl = jsonDecode(responseBody)['secure_url'];
          return Right(secureUrl);
        } else {
          String errorMessage = "حدث خطأ ما";
          try {
            final bodyJson = jsonDecode(responseBody);
            if (bodyJson is Map && bodyJson.containsKey('error')) {
              final cloudinaryError = bodyJson['error'];
              if (cloudinaryError is Map &&
                  cloudinaryError['message'] != null) {
                errorMessage = cloudinaryError['message'].toString();
              } else if (cloudinaryError is String) {
                errorMessage = cloudinaryError;
              }
            }
          } catch (_) {
            // ignore parse errors and keep generic message
          }
          print(errorMessage);
          return Left(StatusClasses.customError(
              "خطأ في رفع الصورة (${response.statusCode}): $errorMessage"));
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

  static Future<File?> compressImage(File file) async {
    final dir = p.dirname(file.path);
    final name = p.basenameWithoutExtension(file.path);

    final targetPath = "$dir/${name}_compressed.jpg";

    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 70,
    );

    return result == null ? null : File(result.path);
  }
}
