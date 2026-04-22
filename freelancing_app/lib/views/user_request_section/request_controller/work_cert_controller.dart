import 'package:freelancing_platform/views/user_request_section/helper_function/validators.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';


class WorkCertController extends GetxController {
  // الأعمال
 RxList<Map<String, Object>> workItems = [
  {"title": "", "description": "", "image": "", "valid": false},
  {"title": "", "description": "", "image": "", "valid": false},
].obs;
//الشهادات 
RxList<Map<String, Object>> certItems = [
  {
    "image": "",
    "title": "",
    "description": "",
    "date": "",
    "url": "",
    "id": "",
    "skills": <String>[],
    "expanded": false,
    "valid": false,
  },
  {
    "image": "",
    "title": "",
    "description": "",
    "date": "",
    "url": "",
    "id": "",
    "skills": <String>[],
    "expanded": false,
    "valid": false,
  },
].obs;

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
    workItems.add(<String, Object>{
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
    certItems.add(<String, Object>{
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
final current = certItems[index]["expanded"] == true;
    certItems[index]["expanded"] = !current;
        certItems.refresh();
  }

  // ---------------- اختيار مهارة ----------------
  void toggleSkill(int certIndex, String skill) {
    final skills = (certItems[certIndex]["skills"] as List).cast<String>();

    if (skills.contains(skill)) {
      skills.remove(skill);
    } else {
      skills.add(skill);
    }
certItems[certIndex]["skills"] = skills;
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
     return item["valid"] as bool? ?? false;
  }

  bool validateCertificate(int index) {
    final item = certItems[index];
    item["valid"] = Validators.validateCertificate(item);
    certItems.refresh();
     return item["valid"] as bool? ?? false;
  }
}
