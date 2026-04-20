import 'package:freelancing_platform/views/user_request_section/freelancer_request/helper_function/validators.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';


class WorkCertController extends GetxController {
  // الأعمال
  RxList<Map<String, dynamic>> workItems = <Map<String, dynamic>>[].obs;

  // الشهادات
  RxList<Map<String, dynamic>> certItems = <Map<String, dynamic>>[].obs;

  // المهارات القادمة من الشاشة السابقة
  RxList<String> selectedSubSkills = <String>[].obs;

  @override
  void onInit() {
    if (Get.arguments != null && Get.arguments["skills"] != null) {
      selectedSubSkills.assignAll(Get.arguments["skills"]);
    }
    super.onInit();
  }

  // ---------------- إضافة عمل ----------------
  void addWorkItem() {
    workItems.add({
      "image": "",
      "title": "",
      "description": "",
      "valid": false,
    });
  }

  // ---------------- حذف عمل ----------------
  void removeWorkItem(int index) {
    workItems.removeAt(index);
  }

  // ---------------- إضافة شهادة ----------------
  void addCertificateItem() {
    certItems.add({
      "image": "",
      "title": "",
      "description": "",
      "date": "",
      "url": "",
      "id": "",
      "skills": <String>[],
      "expanded": false,
      "valid": false,
    });
  }

  // ---------------- حذف شهادة ----------------
  void removeCertificateItem(int index) {
    certItems.removeAt(index);
  }

  // ---------------- توسيع الشهادة ----------------
  void toggleExpand(int index) {
    certItems[index]["expanded"] = !certItems[index]["expanded"];
    certItems.refresh();
  }

  // ---------------- اختيار مهارة ----------------
  void toggleSkill(int certIndex, String skill) {
    List skills = certItems[certIndex]["skills"];

    if (skills.contains(skill)) {
      skills.remove(skill);
    } else {
      skills.add(skill);
    }

    certItems.refresh();
  }

  // ---------------- رفع صورة Firebase ----------------
  Future<String> uploadImage() async {
  final picker = ImagePicker();
  final picked = await picker.pickImage(source: ImageSource.gallery);

  if (picked == null) return "";

  // للويب
  if (GetPlatform.isWeb) {
    final bytes = await picked.readAsBytes();
    String fileName = "uploads/${DateTime.now().millisecondsSinceEpoch}.jpg";

    final ref = FirebaseStorage.instance.ref().child(fileName);
    await ref.putData(bytes);

    return await ref.getDownloadURL();
  }

  // للموبايل
  File file = File(picked.path);
  String fileName = "uploads/${DateTime.now().millisecondsSinceEpoch}.jpg";

  final ref = FirebaseStorage.instance.ref().child(fileName);
  await ref.putFile(file);

  return await ref.getDownloadURL();
}

  // ---------------- Validation ----------------
  bool validateWork(int index) {
    final item = workItems[index];
    item["valid"] = Validators.validateWork(item);
    workItems.refresh();
    return item["valid"];
  }

  bool validateCertificate(int index) {
    final item = certItems[index];
    item["valid"] = Validators.validateCertificate(item);
    certItems.refresh();
    return item["valid"];
  }
}
