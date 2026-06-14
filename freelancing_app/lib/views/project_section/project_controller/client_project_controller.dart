import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/classes/user_session.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/project_status.dart';
import 'package:freelancing_platform/core/services/navigation_service.dart';
import 'package:freelancing_platform/data/services/project_service.dart';
import 'package:freelancing_platform/models/project_collections/project_model.dart';
import 'package:freelancing_platform/views/project_section/project_functions/projects_auto_complete.dart';
import 'package:get/get.dart';
//ok
class ClientProjectController extends GetxController {
  final ProjectService _projectService = ProjectService();

  final pageState = StatusClasses.isloading.obs;
  final activeTabIndex = 0.obs;
  final projects = <ProjectModel>[].obs;

  // List<String> actionProjectsId = [];
  ProjectModel? selectedProject;

  @override
  void onInit() {
    super.onInit();
    // actionProjectsId = [];
    loadProjects();
  }

//ok
  Future<void> loadProjects() async {
    pageState.value = StatusClasses.isloading;

    final res = await _projectService.getClientProjects(
      clientId: UserSession.uid!,
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
      ProjectStatus.clientTabStatuses[activeTabIndex.value];
//ok
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

//ok
  void setTabIndex(int index) {
    activeTabIndex.value = index;
  }

//ok
  void openProjectDetails(ProjectModel project) async {
    selectedProject = project;
    final result = await NavigationService.toNamed(
      AppRoutes.projectDetails,
      arguments: {'project': project, "projectId": project.id},
    );
    if (result == true) {
      loadProjects();
    }
  }

//ok
  void openActiveProject(ProjectModel project) {
    selectedProject = project;
    NavigationService.toNamed(
      AppRoutes.activeProject,
      arguments: {'project': project},
    );
  }

  void updateProjectStatusLocally(String projectId, String status) {
    final index = projects.indexWhere((p) => p.id == projectId);
    if (index == -1) return;
    projects[index] = projects[index].copyWith(
      status: status,
    );
    projects.refresh();
  }

  // void _startAction(String projectId) {
  //   actionProjectsId.add(projectId);
  //   update();
  // }

  // void _endAction(String projectId) {
  //   actionProjectsId.remove(projectId);
  //   update();
  // }

  // bool isBusy(String projectId) => actionProjectsId.contains(projectId);

  // void confirmDeleteProject(ProjectModel project) {
  //   Get.defaultDialog(
  //     title: "تأكيد الحذف",
  //     middleText: "هل أنت متأكد أنك تريد حذف هذا المشروع؟",
  //     textCancel: "إلغاء",
  //     textConfirm: "حذف",
  //     onConfirm: () async {
  //       Get.back();
  //       await deleteProject(project);
  //     },
  //   );
  // }

  // Future<void> deleteProject(ProjectModel project) async {
  //   _startAction(project.id);
  // final res = await _projectService.deleteProject(project);
  //   _endAction(project.id);
  //   if (res != StatusClasses.success) {
  //     customSnackbar(message: "خطأ : ${res.type} / ${res.message}");
  //     return;
  //   }
  //   projects.removeWhere((p) => p.id == project.id);
  //   customSnackbar(message: "تم حذف المشروع");
  // }

  // void updateProjectStatusLocally(String projectId, String status) {
  //   _updateLocalProjectStatus(projectId, status);
  // }
}
