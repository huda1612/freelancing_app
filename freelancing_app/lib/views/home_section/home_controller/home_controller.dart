import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/classes/user_session.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/collections_names.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/user_roles.dart';
import 'package:freelancing_platform/core/services/navigation_service.dart';
import 'package:freelancing_platform/data/services/project_service.dart';
import 'package:freelancing_platform/data/services/user_service.dart';
import 'package:freelancing_platform/models/project_collections/project_model.dart';
import 'package:freelancing_platform/models/user_collections/user_model.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final ProjectService _projectService = ProjectService();
  final UserService _userService = UserService();

  final pageState = StatusClasses.isloading.obs;
  final suggestedProjects = <ProjectModel>[].obs;
  final newProjects = <ProjectModel>[].obs;
  final featuredFreelancers = <UserModel>[].obs;
  final newFreelancers = <UserModel>[].obs;
  final currentUser = Rxn<UserModel>();

  String get userRole => UserSession.role ?? '';
  bool get isFreelancer => userRole == UserRole.freelancer;
  bool get isClient => userRole == UserRole.client;
  final hasUnreadNotifications = false.obs;

  StreamSubscription? _notificationsSub;

  @override
  void onInit() {
    super.onInit();
    _listenToUnreadNotifications();
    fetchHomeData();
  }

  Future<void> fetchHomeData() async {
    pageState.value = StatusClasses.isloading;

    final uid = UserSession.uid;
    if (uid == null) {
      pageState.value = StatusClasses.unauthorized;
      return;
    }

    // جلب بيانات المستخدم الحالي
    final userResponse = await _userService.fetchUserData2(uid);
    userResponse.fold(
      (error) => pageState.value = error,
      (user) {
        currentUser.value = user;
        _fetchDataBasedOnRole(user);
      },
    );
  }

  void _listenToUnreadNotifications() {
    final uid = UserSession.uid;
    if (uid == null) return;

    _notificationsSub = FirebaseFirestore.instance
        .collection(CollectionsNames.users)
        .doc(uid)
        .collection(CollectionsNames.notifications)
        .where('isRead', isEqualTo: false)
        .limit(1)
        .snapshots()
        .listen(
      (snapshot) {
        hasUnreadNotifications.value = snapshot.docs.isNotEmpty;
      },
      onError: (error) {
        hasUnreadNotifications.value = false;
        debugPrint("notifications listener error: $error");
      },
    );
  }

  Future<void> _fetchDataBasedOnRole(UserModel user) async {
    if (isFreelancer) {
      await _fetchFreelancerData(user);
    } else if (isClient) {
      await _fetchClientData();
    }
  }

  Future<void> _fetchFreelancerData(UserModel user) async {
    // جلب المشاريع المقترحة (10 مشاريع)
    final projectsResponse = await _projectService.getOpenProjects();
    projectsResponse.fold(
      (error) => pageState.value = error,
      (projects) {
        final filtered = projects.take(10).toList();
        suggestedProjects.assignAll(filtered);

        // جلب مشاريع جديدة بنفس الاختصاص
        if (user.specialization?.slug != null) {
          final sameSpecProjects = projects
              .where((p) => p.category.slug == user.specialization?.slug)
              .take(10)
              .toList();
          newProjects.assignAll(sameSpecProjects);
        } else {
          newProjects.assignAll(projects.take(10).toList());
        }

        pageState.value = StatusClasses.success;
      },
    );
  }

  Future<void> _fetchClientData() async {
    // جلب الفريلانسرز المميزين (لديهم تقييم ومشاريع منجزة)
    final freelancersResponse = await _userService.fetchUsersByRole(
      role: UserRole.freelancer,
    );

    freelancersResponse.fold(
      (error) => pageState.value = error,
      (freelancers) {
        final featured = freelancers
            .where((f) => f.overallRating > 0 && f.completedProjects > 0)
            .toList()
          ..sort((a, b) => b.overallRating.compareTo(a.overallRating));
        featuredFreelancers.assignAll(featured.take(10).toList());

        // جلب الفريلانسرز الجدد (بدون تقييم أو مشاريع)
        final newUsers = freelancers
            .where((f) => f.overallRating == 0 && f.completedProjects == 0)
            .toList();
        newFreelancers.assignAll(newUsers.take(10).toList());

        pageState.value = StatusClasses.success;
      },
    );
  }

  void openNotifications() {
    NavigationService.toNamed(AppRoutes.notifications);
  }

  void openProjectDetails(ProjectModel project) {
    NavigationService.toNamed(
      AppRoutes.projectDetails,
      arguments: {'projectId': project.id},
    );
  }

  void openFreelancerProfile(UserModel freelancer) {
    Get.toNamed(
      AppRoutes.userProfile,
      arguments: {'userId': freelancer.uid},
    );
  }

  String get welcomeMessage {
    final user = currentUser.value;
    if (user != null) {
      final name = '${user.fname} ${user.lname}'.trim();
      return name.isEmpty ? user.username : name;
    }
    return '';
  }

  @override
  void onClose() {
    _notificationsSub?.cancel();
    super.onClose();
  }
}
