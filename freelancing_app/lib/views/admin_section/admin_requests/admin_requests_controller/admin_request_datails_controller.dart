import 'package:get/get.dart';

class RequestDetailController extends GetxController {
  // البيانات الأساسية
  final specialization = ''.obs;
  final jobTitle = ''.obs;
  final bio = ''.obs;
  final skills = <String>[].obs;

  // الملفات
  final workSamples = <String>[].obs; // روابط ملفات/صور
  final certificates = <String>[].obs;

  @override
  void onInit() {
    super.onInit();

    // 🔹 بيانات تجريبية (بدلها من API / Firestore)
    specialization.value = "برمجة ، تطوير المواقع و التطبيقات";
    jobTitle.value = "Flutter Developer";
    bio.value = "I am a Flutter developer with experience in building apps...";
    skills.assignAll(["Flutter", "Dart", "GetX"]);

    workSamples.assignAll([
      "https://example.com/work1.pdf",
      "https://example.com/work2.pdf",
    ]);

    certificates.assignAll([
      "https://example.com/cert1.pdf",
    ]);
  }
}
