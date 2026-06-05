import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/classes/user_session.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/project_status.dart';
import 'package:freelancing_platform/core/services/navigation_service.dart';
import 'package:freelancing_platform/data/services/project_service.dart';
import 'package:freelancing_platform/models/project_collections/project_model.dart';
import 'package:freelancing_platform/views/project_section/project_functions/projects_auto_complete.dart';
import 'package:get/get.dart';

class FreelancerProjectController extends GetxController {
  final ProjectService _projectService;

  FreelancerProjectController({
    ProjectService? projectService,
  }) : _projectService = projectService ?? ProjectService();

  final pageState = StatusClasses.isloading.obs;
  final activeTabIndex = 0.obs;
  final projects = <ProjectModel>[].obs;

  ProjectModel? selectedProject;

  @override
  void onInit() {
    super.onInit();
    loadProjects();
  }

  Future<void> loadProjects() async {
    pageState.value = StatusClasses.isloading;

    final res = await _projectService.getFreelancerProjects(
      freelancerId: UserSession.uid!,
    );

    res.fold(
      (err) => pageState.value = err,
      (list) async {
        //  1- أول شي: شغّل auto complete
        final updatedProjectIds = await autoCompleteProjects(list);

        list.sort((a, b) {
          final aMs = a.createdAt?.millisecondsSinceEpoch ?? 0;
          final bMs = b.createdAt?.millisecondsSinceEpoch ?? 0;
          return bMs.compareTo(aMs);
        });
        projects.assignAll(list);
        if (updatedProjectIds.isNotEmpty) {
          projects.value = projects
              .map((p) => updatedProjectIds.contains(p.id)
                  ? p.copyWith(status: ProjectStatus.completed)
                  : p)
              .toList();
        }
        pageState.value = StatusClasses.success;
      },
    );
  }

  String get statusForActiveTab =>
      ProjectStatus.freelancerTabStatuses[activeTabIndex.value];

  List<ProjectModel> projectsForActiveTab() {
    if (statusForActiveTab == ProjectStatus.inProgress) {
      return projects
          .where((p) =>
              p.status == ProjectStatus.setup ||
              p.status == ProjectStatus.waitingTasksApproval ||
              p.status == ProjectStatus.inProgress ||
              p.status == ProjectStatus.readyToComplete)
          .toList();
    }
    return projects.where((p) => p.status == statusForActiveTab).toList();
  }

  void setTabIndex(int index) {
    activeTabIndex.value = index;
  }

  void openActiveProject(ProjectModel project) {
    selectedProject = project;
    NavigationService.toNamed(
      AppRoutes.activeProject,
      arguments: <String, dynamic>{'project': project},
    );
  }
}
