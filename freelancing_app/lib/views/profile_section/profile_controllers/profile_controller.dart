import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/classes/user_session.dart';
import 'package:freelancing_platform/core/constants/app_image_preset.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/core/constants/user_roles.dart';
import 'package:freelancing_platform/core/general_controllers.dart/image_upload_controller.dart';
import 'package:freelancing_platform/core/services/image_service.dart';
import 'package:freelancing_platform/core/utils/helper_function/check_login.dart';
import 'package:freelancing_platform/core/utils/helper_function/validators.dart';
import 'package:freelancing_platform/core/widgets/custom_snackbar.dart';
import 'package:freelancing_platform/data/services/certificate_service.dart';
import 'package:freelancing_platform/data/services/user_service.dart';
import 'package:freelancing_platform/data/services/work_sample_service.dart';
import 'package:freelancing_platform/models/skill_collections/specialization_model.dart';
import 'package:freelancing_platform/models/user_collections/certificate_model.dart';
import 'package:freelancing_platform/models/user_collections/review_model.dart';
import 'package:freelancing_platform/models/user_collections/user_model.dart';
import 'package:freelancing_platform/models/user_collections/worksamples_model.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final UserService _userService;
  final WorkSampleService _workSampleService;
  final CertificateService _certificateService;

  ProfileController({
    UserService? userService,
    WorkSampleService? workSampleService,
    CertificateService? certificateService,
  })  : _userService = userService ?? UserService(),
        _workSampleService = workSampleService ?? WorkSampleService(),
        _certificateService = certificateService ?? CertificateService();

  //loading states
  final pageState = StatusClasses.isloading.obs;
  final isLoadingSkills = false.obs;
  final loadCertificates = false.obs;
  RxSet<String> loadingCertIds = <String>{}.obs;
  final addingCerLoading = false.obs;
  final activeTabIndex = 0.obs;

  //UI variables
  final user = Rxn<UserModel>();
  String userId = '';
  final profileImage = ''.obs;
  final reviews = <ReviewModel>[].obs;
  final certificates = <CertificateModel>[].obs;
  final works = <WorksampleModel>[].obs;
  final TextEditingController bioController = TextEditingController();

  var newCertificate = Rxn<CertificateModel>();

  List<String> get skills => user.value?.skills ?? const <String>[];

  @override
  void onInit() {
    super.onInit();
    if (!isLogin()) {
      return;
    }
    if (isOwnProfile) {
      userId = UserSession.uid!;
    } else {
      userId = Get.arguments['userId'];
    }

    loadProfile();
  }

  void addWork() {
    Get.toNamed(
      AppRoutes.workDetails,
      arguments: {
        "work": null,
        "isOwnProfile": isOwnProfile,
      },
    );
  }

  //لو مررت وسيط رقم المستخدم للصفحه وانا عم انتقلها معناها هي ما صفحتي صفحة مستخدم ما
  bool get isOwnProfile {
    final String? argUserId = Get.arguments?['userId'];
    if (argUserId == null) return true;
    return false;
  }

  String? get role {
    if (user.value == null) return null;
    return user.value!.role;
  }

  bool get isFreelancer {
    return role == UserRole.freelancer;
  }

  String get username {
    final raw = user.value?.username.trim() ?? '';
    if (raw.isEmpty) return 'username';
    return raw;
  }

  String get roleLabel {
    final raw = user.value?.role.trim() ?? '';
    if (raw.isEmpty) return 'Freelancer';
    return raw;
  }

  String get specializationLabel {
    final raw = user.value?.specialization?.name.trim() ?? '';
    if (raw.isEmpty) return '';
    return raw;
  }

  String get fullName {
    final u = user.value;
    if (u == null) return 'User Name';
    final first = u.fname.trim();
    final last = u.lname.trim();
    final joined = '$first $last'.trim();
    return joined.isEmpty ? u.username : joined;
  }

  String get subTitle {
    final u = user.value;
    if (u == null) return 'role / job title';
    final role = u.role.trim().isEmpty ? 'لا يوجد دور' : u.role.trim();
    final jobTitle =
        u.jobTitle.trim().isEmpty ? 'لا يوجد مسمى وظيفي' : u.jobTitle;

    return "$role / $jobTitle";
  }

  ///ما مستخدم !!!!!!!!!!!!!!
  // double get averageReviewsRating {
  //   if (reviews.isEmpty) return user.value?.rating ?? 0.0;
  //   final sum = reviews.fold<double>(0.0, (acc, item) => acc + item.rating);
  //   return sum / reviews.length;
  // }

  ///ما مستخدم !!!!!!!!!!!!!!
  // int get completedProjects => user.value?.completedProjects ?? works.length;

  Future<void> loadProfile() async {
    pageState.value = StatusClasses.isloading;

    try {
      final getUserResponse = await _userService.fetchUserData2(userId);
      getUserResponse.fold((error) {
        pageState.value = error;
        return;
      }, (fetchedUser) {
        user.value = fetchedUser;
        profileImage.value = fetchedUser.photoUrl;
        bioController.text = fetchedUser.bio;
        pageState.value = StatusClasses.success;
      });
      if (pageState.value != StatusClasses.success) return;

      await Future.wait([
        // _loadReviews(uid),
        _loadCertificates(userId),
        loadWorks(userId),
      ]);

      if (user.value == null) {
        _setFallbackData();
      }
      pageState.value = StatusClasses.success;
      // update();
      return;
    } catch (e) {
      // print(e);
      log(e.toString());
      _setFallbackData();
    }
  }

  //بده تغيير بس نعمل التقييم !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  // Future<StatusClasses> _loadReviews(String uid) async {
  //   // ReviweService _reviweService = ReviweService();
  //   final query = await _firestore
  //       .collection(CollectionsNames.users)
  //       .doc(uid)
  //       .collection('reviews')
  //       .orderBy('createdAt', descending: true)
  //       .limit(10)
  //       .get();

  //   final list = query.docs
  //       .map((doc) => ReviewModel.fromMap(doc.data(), doc.id))
  //       .toList();
  //   if (list.isNotEmpty) {
  //     reviews.assignAll(list);
  //   }
  // }

  Future<StatusClasses> _loadCertificates(String uid) async {
    loadCertificates.value = true;
    CertificateService certificateService = CertificateService();
    final response = await certificateService.getAllUserCertificate(uid: uid);
    return response.fold((error) {
      loadCertificates.value = false;
      return error;
    }, (cerList) {
      certificates.assignAll(cerList);
      print(certificates[1].imageURL);
      loadCertificates.value = false;
      return StatusClasses.success;
    });
  }

  Future<StatusClasses> loadWorks(String uid) async {
    final response = await _workSampleService.getAllUserWorkSample(uid: uid);
    return response.fold(
      (error) {
        return error;
      },
      (right) {
        if (right.isNotEmpty) {
          works.assignAll(right);
        }
        return StatusClasses.success;
      },
    );
  }

  Future<void> changeProfileImage() async {
    final imageUploadController = Get.find<ImageUploadController>();
    final result = await imageUploadController.pickAndUpload(
        AppImagePreset.profileImagePreset,
        publicId:
            "users/$userId/profile_${DateTime.now().millisecondsSinceEpoch}");

    result.fold(
      (err) {
        Get.snackbar(err.type, err.message ?? "حدث خطأ ما اثناء رفع الصورة");
      },
      (url) async {
        final updateResult = await _userService.updateUserData2({
          "photoUrl": url,
        }, userId);
        if (updateResult != StatusClasses.success) {
          Get.snackbar(updateResult.type,
              updateResult.message ?? "حدث خطأ ما في السيرفر");
          return;
        } else {
          // print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" + url);
          profileImage.value = url;
        }
      },
    );
  }
  //--------------------------------------skills manage-----------------------------------------------

  Future<void> editSkills() async {
    //بنقله على صفحة المهارات
    final selectedSkills =
        await Get.toNamed(AppRoutes.skillsSelection, arguments: {
      'oldSkills': user.value!.skills,
      'specailization': user.value!.specialization!.slug
    });

    //لو رجع بلا ما يضغط على حفظ
    if (selectedSkills == null) {
      customSnackbar(message: "لم يتم حفظ التعديلات");
      return;
    }
    if (selectedSkills is! List<String>) {
      customSnackbar(message: "خطأ بنوع البيانات الراجعه");
      return;
    }

    bool isSame = Set.from(selectedSkills).containsAll(user.value!.skills) &&
        Set.from(user.value!.skills).containsAll(selectedSkills);
    if (isSame) {
      customSnackbar(message: "لم يتم تغيير المهارات");
      return;
    }
    isLoadingSkills.value = true;

    final response = await _userService
        .updateUserData2({"skills": selectedSkills}, user.value!.uid);
    if (response != StatusClasses.success) {
      customSnackbar(
          message:
              "خطأ في تحديث المهارات : ${response.type}/${response.message}");
      isLoadingSkills.value = false;
      return;
    }
    user.value = user.value!.copyWith(skills: selectedSkills);
    isLoadingSkills.value = false;
    customSnackbar(message: "تم تحديث المهارات بنجاح");
  }

  //----------------------------------certificates manage--------------------------------------------

  void addCertificate() {
    newCertificate.value = CertificateModel(title: "", skills: []);
  }

  void cencelAddCertificate() {
    newCertificate.value = null;
  }

  Future<void> saveCertificate(
      String? certId, Map<String, dynamic> map, String operationType) async {
    void setLoadind(bool l) {
      if (certId != null) {
        l ? loadingCertIds.add(certId) : loadingCertIds.remove(certId);
      } else if (operationType == 'add') {
        addingCerLoading.value = l;
      }
    }

    //رفع الصوره
    String? imageUrl;
    setLoadind(true);

    if (map["newImageFlie"] != null) {
      final failedIsvalid = map["title"].toString().trim().isNotEmpty &&
          map["title"] != null &&
          map["description"].toString().trim().isNotEmpty &&
          map["description"] != null;
      if (!failedIsvalid) {
        customSnackbar(message: " يجب ادخال صورة وعنوان ووصف");
        setLoadind(false);

        return;
      }
      bool uploadFailed = false;
      //upload image
      // ضغط الصورة
      final compressedFile =
          await ImageService.compressImage(map["newImageFlie"]);
      // إذا فشل الضغط، استخدم الأصل
      final fileToUpload = compressedFile ?? map["newImageFlie"];
      final upRes = await ImageService.uploadImage(
          AppImagePreset.certificatePreset, fileToUpload);
      upRes.fold((err) {
        customSnackbar(message: "لم يتم رفع الصوره ، ${err.message}");
        uploadFailed = true;
      }, (url) {
        imageUrl = url;
      });
      if (uploadFailed) {
        setLoadind(false);

        return;
      }
    }
    Map<String, dynamic> newData = {
      "title": map['title'],
      "source": map['source'],
      "description": map['description'],
      "credentialID": map['credentialID'],
      "credentialURL": map['credentialURL'],
      "date": map['date'],
      "skills": map['skills'],
      "imageURL": imageUrl ?? map["imageURL"]
    };
    final isvalid = Validators.validateCertificate(newData);
    if (!isvalid) {
      customSnackbar(message: " يجب ادخال صورة وعنوان ووصف");
      // loadCertificates.value = false;
      setLoadind(false);

      return;
    }

    StatusClasses response;
    if (operationType == 'update') {
      response = await _certificateService.updateCertificate(
          newData: newData, uid: userId, cID: certId!);
    } else {
      final c = CertificateModel(
          title: map['title'],
          source: map['source'],
          description: map['description'],
          credentialID: map['credentialID'],
          credentialURL: map['credentialURL'],
          date: map['date'],
          skills: List<String>.from(map['skills']),
          imageURL: imageUrl);
      response =
          await _certificateService.addCertificate(uid: userId, certificate: c);
    }
    if (response != StatusClasses.success) {
      customSnackbar(message: "error : ${response.type} / ${response.message}");
      setLoadind(false);

      return;
    }

    //لتحديث البيانات بالواجهة
    if (operationType == "update") {
      final index = certificates.indexWhere((c) => c.id == certId);

      if (index != -1) {
        certificates[index] =
            CertificateModel.fromMap(newData, certificates[index].id!);
        certificates.refresh();
      }
    } else {
      newCertificate.value = null;
      await _loadCertificates(userId);
    }

    setLoadind(false);
    customSnackbar(message: "تمت العملية بنجاح");
  }

  Future<void> deleteCertificate(String certId) async {
    loadingCertIds.add(certId);
    final response =
        await _certificateService.deleteCertificate(uId: userId, cId: certId);
    if (response != StatusClasses.success) {
      customSnackbar(
          message: "حدث خطأ : ${response.type} / ${response.message}");
      return;
    }
    certificates.removeWhere((c) => c.id == certId);
    loadingCertIds.remove(certId);
    customSnackbar(message: "تم حذف الشهادة بنجاح");
  }

  //--------------------------------------------- UI functions--------------------------------------------

  void setTabIndex(int index) {
    activeTabIndex.value = index;
  }

  void _setFallbackData() {
    user.value = UserModel(
      uid: 'local-user',
      fname: 'User',
      lname: 'Name',
      username: 'username',
      email: 'user@email.com',
      role: 'Freelancer',
      specialization: SpecializationSnapshot(slug: 'a', name: 'برمجه'),
      bio:
          'مصمم ومطور مهتم ببناء حلول رقمية تجمع بين الشكل الجميل والأداء العملي، مع خبرة في تنفيذ مشاريع للشركات الناشئة والمتاجر الإلكترونية.',
      skills: const [
        'UI Design',
        'Flutter',
        'Branding',
        'Copywriting',
        'Web Development',
        'Motion Design',
      ],
      rating: 4.8,
      completedProjects: 120,
    );

    reviews.assignAll([
      ReviewModel(
        id: 'r1',
        fromUserId: 'u1',
        projectId: 'p1',
        rating: 5.0,
        comment: 'عمل ممتاز وملتزم جداً بالمواعيد.',
      ),
      ReviewModel(
        id: 'r2',
        fromUserId: 'u2',
        projectId: 'p2',
        rating: 4.5,
        comment: 'كتب محتوى قوي واحترافي للمشروع.',
      ),
      ReviewModel(
        id: 'r3',
        fromUserId: 'u3',
        projectId: 'p3',
        rating: 4.8,
        comment: 'تواصل سريع ونتيجة نهائية جميلة.',
      ),
      ReviewModel(
        id: 'r4',
        fromUserId: 'u4',
        projectId: 'p4',
        rating: 4.7,
        comment: 'تجربة ممتازة ومرونة كبيرة بالتعديلات.',
      ),
      ReviewModel(
        id: 'r5',
        fromUserId: 'u5',
        projectId: 'p5',
        rating: 5.0,
        comment: 'احترافية عالية بالتعامل والتنفيذ.',
      ),
    ]);

    certificates.assignAll([
      CertificateModel(
        id: 'c1',
        title: 'شهادة تصميم تجربة المستخدم',
        description:
            'شهادة متقدمة في تصميم تجربة المستخدم تشمل البحث والتحليل وبناء النماذج الأولية واختبار الاستخدام.',
      ),
      CertificateModel(
        id: 'c2',
        title: 'شهادة تطوير تطبيقات Flutter',
        description:
            'برنامج احترافي لتطوير تطبيقات Flutter مع إدارة الحالة وربط APIs وتحسين الأداء.',
      ),
      CertificateModel(
        id: 'c3',
        title: 'شهادة كتابة المحتوى التسويقي',
        description:
            'تركز على كتابة محتوى جذاب يحسن معدل التحويل ويراعي محركات البحث والأسلوب المناسب للجمهور.',
      ),
    ]);

    works.assignAll([
      WorksampleModel(
        id: 'w1',
        title: 'تطبيق متجر إلكتروني',
        description: 'تصميم وتطوير تجربة تسوق كاملة مع لوحة تحكم وإدارة طلبات.',
      ),
      WorksampleModel(
        id: 'w2',
        title: 'هوية بصرية لشركة ناشئة',
        description:
            'تصميم الشعار ونظام الألوان ودليل استخدام الهوية للمنصات الرقمية.',
      ),
      WorksampleModel(
        id: 'w3',
        title: 'حملة محتوى تسويقي',
        description:
            'إعداد محتوى إعلاني وسوشال ميديا حقق تفاعل أعلى بنسبة 40%.',
      ),
    ]);
  }

  @override
  void onClose() {
    bioController.dispose();
    super.onClose();
  }
}
