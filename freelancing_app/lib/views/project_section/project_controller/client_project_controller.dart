import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/classes/user_session.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/project_status.dart';
import 'package:freelancing_platform/core/services/navigation_service.dart';
import 'package:freelancing_platform/core/widgets/custom_snackbar.dart';
import 'package:freelancing_platform/data/services/project_service.dart';
import 'package:freelancing_platform/data/services/user_service.dart';
import 'package:freelancing_platform/models/project_collections/project_model.dart';
import 'package:get/get.dart';

class ClientProjectController extends GetxController {
  final ProjectService _projectService = ProjectService();
  final UserService _userService = UserService();

  // ClientProjectController({
  //   ProjectService? projectService,
  //   UserService? userService,
  // })  : _projectService = projectService ?? ProjectService(),
  //       _userService = userService ?? UserService();

  final pageState = StatusClasses.isloading.obs;
  final activeTabIndex = 0.obs;
  final projects = <ProjectModel>[].obs;

  List<String> actionProjectsId = [];
  ProjectModel? selectedProject;

  @override
  void onInit() {
    super.onInit();
    actionProjectsId = [];
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
      (list) {
        list.sort((a, b) {
          final aMs = a.createdAt?.millisecondsSinceEpoch ?? 0;
          final bMs = b.createdAt?.millisecondsSinceEpoch ?? 0;
          return bMs.compareTo(aMs);
        });
        projects.assignAll(list);
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

//later!!
  void openActiveProject(ProjectModel project) {
    selectedProject = project;
    NavigationService.toNamed(
      AppRoutes.activeProject,
      arguments: {'project': project},
    );
  }

  //ينفذ عند الموافقه على انهاء المشروع
  //بده اسا تعديل بس نضيف الدفع
  Future<void> approveProjectCompletion(ProjectModel project) async {
    _startAction(project.id);
    //1-تغيير حاله المشروع الى منتهي
    final res = await _projectService.updateProjectStatus(
      projectId: project.id,
      status: ProjectStatus.completed,
    );
    if (res != StatusClasses.success) {
      _endAction(project.id);
      customSnackbar(message: "خطأ : ${res.type} / ${res.message}");
      return;
    }
    //2- زيادة عدد مشاريعي المكتمله بواحد
    await _userService.updateUserData2(
      {'completed_projects': FieldValue.increment(1)},
      UserSession.uid!,
    );
    //3- زيادة عدد مشاريع الفريلانسر المكتمله بواحد
    if (project.acceptedFreelancerId != null) {
      await _userService.updateUserData2(
        {'completed_projects': FieldValue.increment(1)},
        project.acceptedFreelancerId!,
      );
    }

    _updateLocalProjectStatus(project.id, ProjectStatus.completed);
    _endAction(project.id);
    customSnackbar(message: "تم إكمال المشروع بنجاح");
  }

  // Future<void> republishProject(ProjectModel project) async {
  //   _startAction(project.id);
  //   final res = await _projectService.republishProject(project.id);
  //   _endAction(project.id);
  //   if (res != StatusClasses.success) {
  //     customSnackbar(message: "خطأ : ${res.type} / ${res.message}");
  //     return;
  //   }
  //   _updateLocalProjectStatus(project.id, ProjectStatus.newProject);
  //   customSnackbar(message: "تم إعادة نشر المشروع");
  // }

  void confirmDeleteProject(ProjectModel project) {
    Get.defaultDialog(
      title: "تأكيد الحذف",
      middleText: "هل أنت متأكد أنك تريد حذف هذا المشروع؟",
      textCancel: "إلغاء",
      textConfirm: "حذف",
      onConfirm: () async {
        Get.back();
        await deleteProject(project);
      },
    );
  }

  Future<void> deleteProject(ProjectModel project) async {
    _startAction(project.id);
    final res = await _projectService.deleteProject(project);
    _endAction(project.id);
    if (res != StatusClasses.success) {
      customSnackbar(message: "خطأ : ${res.type} / ${res.message}");
      return;
    }
    projects.removeWhere((p) => p.id == project.id);
    customSnackbar(message: "تم حذف المشروع");
  }

  void updateProjectStatusLocally(String projectId, String status) {
    _updateLocalProjectStatus(projectId, status);
  }

  void _updateLocalProjectStatus(String projectId, String status) {
    final index = projects.indexWhere((p) => p.id == projectId);
    if (index == -1) return;
    // final old = projects[index];
    projects[index] = projects[index].copyWith(
      // id: old.id,
      // clientId: old.clientId,
      // title: old.title,
      // description: old.description,
      // category: old.category,
      // skillsRequired: old.skillsRequired,
      // budget: old.budget,
      // durationDays: old.durationDays,
      status: status,
      // acceptedOfferId: old.acceptedOfferId,
      // createdAt: old.createdAt,
    );
    projects.refresh();
  }

  void _startAction(String projectId) {
    actionProjectsId.add(projectId);
    update();
  }

  void _endAction(String projectId) {
    actionProjectsId.remove(projectId);
    update();
  }

  bool isBusy(String projectId) => actionProjectsId.contains(projectId);
}
