import 'package:freelancing_platform/core/classes/user_session.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/project_status.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/user_roles.dart';
import 'package:freelancing_platform/core/services/navigation_service.dart';
import 'package:freelancing_platform/data/services/project_service.dart';
import 'package:freelancing_platform/data/services/user_service.dart';
import 'package:freelancing_platform/models/project_collections/project_model.dart';
import 'package:freelancing_platform/views/project_section/project_controller/project_task_progress_mixin.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController with ProjectTaskProgressMixin {
  DashboardController({
    ProjectService? projectService,
    UserService? userService,
  })  : _projectService = projectService ?? ProjectService(),
        _userService = userService ?? UserService();

  final ProjectService _projectService;
  final UserService _userService;

  final rating = 0.0.obs;
  final completedProjects = 0.obs;
  final totalPoints = 0.obs;
  final activeProjects = 0.obs;
  final expectedEarnings = 0.0.obs;
  final nearestProject = ''.obs;
  final nearestDeadline = ''.obs;
  final farthestProject = ''.obs;
  final farthestDeadline = ''.obs;

  final inProgressProjects = <ProjectModel>[].obs;
  final projectsLoading = false.obs;

  String get ratingText => rating.value.toStringAsFixed(1);
  String get completedProjectsText => completedProjects.value.toString();
  String get totalPointsText => totalPoints.value.toString();
  String get activeProjectsText => activeProjects.value.toString();
  String get expectedEarningsText =>
      '${expectedEarnings.value.toStringAsFixed(0)}\$';
  String get nearestDeliveryText =>
      '${nearestProject.value} · ${nearestDeadline.value}';
  String get farthestDeliveryText =>
      '${farthestProject.value} · ${farthestDeadline.value}';

  @override
  void onInit() {
    super.onInit();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    await Future.wait([
      _loadUserStats(),
      _loadInProgressProjects(),
    ]);
  }

  Future<void> _loadUserStats() async {
    final user = await _userService.fetchUserData(UserSession.uid!);
    if (user != null) {
      rating.value = user.rating;
      completedProjects.value = user.completedProjects;
      totalPoints.value = user.points;
    }
  }

  Future<void> _loadInProgressProjects() async {
    projectsLoading.value = true;

    List<ProjectModel> all = [];
    if (UserSession.role == UserRole.freelancer) {
      final res = await _projectService.getFreelancerProjects(
        freelancerId: UserSession.uid!,
      );
      res.fold((_) {}, (list) => all = list);
    } else if (UserSession.role == UserRole.client) {
      final res = await _projectService.getClientProjects(
        clientId: UserSession.uid!,
      );
      res.fold((_) {}, (list) => all = list);
    }

    final active = all
        .where((p) => p.status == ProjectStatus.inProgress)
        .toList()
      ..sort((a, b) {
        final aMs = a.createdAt?.millisecondsSinceEpoch ?? 0;
        final bMs = b.createdAt?.millisecondsSinceEpoch ?? 0;
        return bMs.compareTo(aMs);
      });

    inProgressProjects.assignAll(active);
    activeProjects.value = active.length;

    expectedEarnings.value = active.fold(
      0.0,
      (sum, p) => sum + p.budget,
    );

    if (active.isNotEmpty) {
      nearestProject.value = active.first.title;
      nearestDeadline.value = 'بعد ${active.first.durationDays} يوم';
      farthestProject.value = active.last.title;
      farthestDeadline.value = 'بعد ${active.last.durationDays} يوم';
    } else {
      nearestProject.value = '—';
      nearestDeadline.value = '—';
      farthestProject.value = '—';
      farthestDeadline.value = '—';
    }

    await loadTaskProgressForProjects(active);
    projectsLoading.value = false;
  }

  void openActiveProject(ProjectModel project) {
    NavigationService.toNamed(
      AppRoutes.activeProject,
      arguments: {'project': project},
    );
  }
}
