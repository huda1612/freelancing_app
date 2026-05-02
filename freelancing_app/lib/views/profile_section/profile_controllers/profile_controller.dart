import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/classes/user_session.dart';
import 'package:freelancing_platform/core/constants/app_image_preset.dart';
import 'package:freelancing_platform/core/constants/user_roles.dart';
import 'package:freelancing_platform/core/general_controllers.dart/image_upload_controller.dart';
import 'package:freelancing_platform/core/utils/helper_function/check_login.dart';
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

  ProfileController({
    UserService? userService,
    WorkSampleService? workSampleService,
  })  : _userService = userService ?? UserService(),
        _workSampleService = workSampleService ?? WorkSampleService();

  final pageState = StatusClasses.isloading.obs;
  // final isProfileImageUploading = false.obs;
  final activeTabIndex = 0.obs;
  String userId = '';

  final user = Rxn<UserModel>();
  final profileImage = ''.obs;
  final reviews = <ReviewModel>[].obs;
  final certificates = <CertificateModel>[].obs;
  final works = <WorksampleModel>[].obs;
  final TextEditingController bioController = TextEditingController();

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
    // if (role == null) {}
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
    // update();
    // isLoading.value = true;
    try {
      final getUserResponse = await _userService.fetchUserData2(userId);
      getUserResponse.fold((error) {
        pageState.value = error;
        // update();
        return;
      }, (fetchedUser) {
        user.value = fetchedUser;
        profileImage.value = fetchedUser.photoUrl;
        bioController.text = fetchedUser.bio;
        pageState.value = StatusClasses.success;
        // update();
      });
      if (pageState.value != StatusClasses.success) return;

      // final resultList =
      await Future.wait([
        // _loadReviews(uid),
        _loadCertificates(userId),
        _loadWorks(userId),
      ]);
      // if (resultList[0] != StatusClasses.success) {
      //   pageState =
      // }
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
    CertificateService certificateService = CertificateService();
    final response = await certificateService.getAllUserCertificate(uid: uid);
    return response.fold((error) {
      return error;
    }, (cerList) {
      certificates.assignAll(cerList);
      return StatusClasses.success;
    });
  }

  Future<StatusClasses> _loadWorks(String uid) async {
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
            "users/$userId/profile_${DateTime.now().millisecondsSinceEpoch}"
        // groupName: "users",
        // id: userId,
        // folder: "profile",
        );

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
          print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" + url);

          profileImage.value = url;
        }
        //  تحديث UI مباشرة بدون fetch
        // user.value = user.value!.copyWith(photoUrl: url);
        // profileImage.value = url;
        // update();
      },
    );
  }

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
