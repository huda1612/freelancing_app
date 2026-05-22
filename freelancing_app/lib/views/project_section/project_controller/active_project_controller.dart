import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/classes/user_session.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/project_status.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/user_roles.dart';
import 'package:freelancing_platform/core/services/navigation_service.dart';
import 'package:freelancing_platform/core/widgets/custom_snackbar.dart';
import 'package:freelancing_platform/data/services/offer_service.dart';
import 'package:freelancing_platform/data/services/project_service.dart';
import 'package:freelancing_platform/data/services/project_task_service.dart';
import 'package:freelancing_platform/data/services/user_service.dart';
import 'package:freelancing_platform/models/project_collections/project_model.dart';
import 'package:freelancing_platform/models/project_collections/task_model.dart';
import 'package:freelancing_platform/views/project_section/project_controller/client_project_controller.dart';
import 'package:freelancing_platform/views/project_section/project_controller/freelance_project_controller.dart';
import 'package:get/get.dart';

class ActiveProjectController extends GetxController {
  ActiveProjectController({
    ProjectTaskService? taskService,
    ProjectService? projectService,
    OfferService? offerService,
    UserService? userService,
  })  : _taskService = taskService ?? ProjectTaskService(),
        _projectService = projectService ?? ProjectService(),
        _offerService = offerService ?? OfferService(),
        _userService = userService ?? UserService();

  final ProjectTaskService _taskService;
  final ProjectService _projectService;
  final OfferService _offerService;
  final UserService _userService;

  final Rx<ProjectModel?> projectRx = Rx<ProjectModel?>(null);
  final tasks = <TaskModel>[].obs;
  final pageState = StatusClasses.isloading.obs;
  final partnerName = ''.obs;
  final partnerUserId = ''.obs;
  final partnerLoading = false.obs;
  final actionLoading = false.obs;

  final Map<String, TextEditingController> _taskControllers = {};
  ProjectModel? get project => projectRx.value;

  bool get isClient => UserSession.role == UserRole.client;
  bool get isFreelancer => UserSession.role == UserRole.freelancer;
  bool get canEditTasks =>
      isFreelancer &&
      project?.status == ProjectStatus.inProgress &&
      !_isReadOnlyViewer;

  bool get _isReadOnlyViewer {
    final status = project?.status;
    return status == ProjectStatus.completed ||
        status == ProjectStatus.cancelled;
  }

  bool get allTasksDone => tasks.isNotEmpty && tasks.every((t) => t.isDone);

  bool get canDeliverProject =>
      canEditTasks && allTasksDone && !(actionLoading.value);

  bool get canApproveCompletion =>
      isClient &&
      project?.status == ProjectStatus.delivered &&
      !(actionLoading.value);

  @override
  void onInit() async {
    super.onInit();
    await initPage();
  }

  Future<void> initPage() async {
    await _resolveProject();
    if (projectRx.value != null) {
      _bootstrap();
    } else {
      pageState.value = StatusClasses.customError('تعذر تحميل المشروع');
    }
  }

  Future<void> _resolveProject() async {
    final nestedArgs =
        NavigationService.routeArguments(AppRoutes.activeProject);
    final nestedProject = nestedArgs?['project'];
    if (nestedProject is ProjectModel) {
      projectRx.value = nestedProject;
      return;
    }
    //بحال كان مرسل رقم المشروع(من الاشعار)
    final nestedProjectId = nestedArgs?['projectId'];
    if (nestedProjectId != null) {
      final projectRes = await ProjectService().getProject(nestedProjectId!);
      projectRes.fold((err) async {
        pageState.value = err;
      }, (p) async {
        projectRx.value = p;
      });
    }

    final args = Get.arguments;
    if (args is Map && args['project'] is ProjectModel) {
      projectRx.value = args['project'] as ProjectModel;
      return;
    }

    if (Get.isRegistered<ClientProjectController>()) {
      final p = Get.find<ClientProjectController>().selectedProject;
      if (p != null) {
        projectRx.value = p;
        return;
      }
    }
    if (Get.isRegistered<FreelancerProjectController>()) {
      final p = Get.find<FreelancerProjectController>().selectedProject;
      if (p != null) {
        projectRx.value = p;
      }
    }
  }

  Future<void> _bootstrap() async {
    pageState.value = StatusClasses.isloading;

    await Future.wait([
      _loadPartnerInfo(),
      loadTasks(),
    ]);
    pageState.value = StatusClasses.success;
  }

  Future<void> _loadPartnerInfo() async {
    final p = project;
    if (p == null) return;

    partnerLoading.value = true;

    if (isClient) {
      final offerRes = await _offerService.getAcceptedOfferForProject(
        projectId: p.id,
        acceptedOfferId: p.acceptedOfferId,
      );
      offerRes.fold(
        (_) {},
        (offer) {
          if (offer != null) {
            partnerUserId.value = offer.freelancerId;
            partnerName.value =
                offer.freelancerSnapshot.fullName.trim().isNotEmpty
                    ? offer.freelancerSnapshot.fullName
                    : offer.freelancerSnapshot.username;
          }
        },
      );
    } else {
      partnerUserId.value = p.clientId;
      final user = await _userService.fetchUserData(p.clientId);
      if (user != null) {
        partnerName.value = '${user.fname} ${user.lname}'.trim();
        if (partnerName.value.isEmpty) {
          partnerName.value = user.username;
        }
      }
    }

    partnerLoading.value = false;
  }

  Future<void> loadTasks() async {
    final p = project;
    if (p == null) return;

    final res = await _taskService.getTasks(projectId: p.id);
    res.fold(
      (err) {
        customSnackbar(message: 'تعذر تحميل المهام');
        pageState.value = err;
      },
      (list) {
        _syncTaskControllers(list);
        tasks.assignAll(list);
      },
    );
  }

  void _syncTaskControllers(List<TaskModel> list) {
    final ids = list.map((t) => t.id).toSet();
    for (final id in _taskControllers.keys.toList()) {
      if (!ids.contains(id)) {
        _taskControllers[id]?.dispose();
        _taskControllers.remove(id);
      }
    }
    for (final task in list) {
      final ctrl = _taskControllers.putIfAbsent(
        task.id,
        () => TextEditingController(text: task.description),
      );
      if (ctrl.text != task.description) {
        ctrl.text = task.description;
      }
    }
  }

  TextEditingController taskController(String taskId) {
    return _taskControllers.putIfAbsent(
      taskId,
      () => TextEditingController(),
    );
  }

  int get _nextTaskNumber {
    if (tasks.isEmpty) return 1;
    return tasks.map((t) => t.orderNumber).reduce((a, b) => a > b ? a : b) + 1;
  }

  Future<void> addTask() async {
    if (!canEditTasks || project == null) return;

    final res = await _taskService.addTask(
      projectId: project!.id,
      orderNumber: _nextTaskNumber,
    );

    res.fold(
      (_) => customSnackbar(message: 'تعذر إضافة المهمة'),
      (task) {
        _taskControllers[task.id] = TextEditingController();
        tasks.add(task);
      },
    );
  }

  Future<void> updateTaskDescription(String taskId, String description) async {
    if (!canEditTasks || project == null) return;

    final index = tasks.indexWhere((t) => t.id == taskId);
    if (index == -1) return;

    tasks[index] = tasks[index].copyWith(description: description);

    await _taskService.updateTask(
      projectId: project!.id,
      taskId: taskId,
      data: {'description': description},
    );
  }

  Future<void> toggleTaskDone(String taskId, bool? value) async {
    if (!canEditTasks || project == null || value == null) return;

    final index = tasks.indexWhere((t) => t.id == taskId);
    if (index == -1) return;

    tasks[index] = tasks[index].copyWith(isDone: value);

    await _taskService.updateTask(
      projectId: project!.id,
      taskId: taskId,
      data: {'isDone': value},
    );
  }

  Future<void> deliverProject() async {
    if (!canDeliverProject || project == null) return;

    actionLoading.value = true;
    final res = await _projectService.updateProjectStatus(
      projectId: project!.id,
      status: ProjectStatus.delivered,
    );
    actionLoading.value = false;

    if (res != StatusClasses.success) {
      customSnackbar(message: 'تعذر تسليم المشروع');
      return;
    }

    _updateLocalProjectStatus(ProjectStatus.delivered);
    customSnackbar(message: 'تم تسليم المشروع — بانتظار موافقة العميل');
  }

  Future<void> approveProjectCompletion() async {
    if (!canApproveCompletion || project == null) return;

    actionLoading.value = true;
    final res = await _projectService.updateProjectStatus(
      projectId: project!.id,
      status: ProjectStatus.completed,
    );

    if (res != StatusClasses.success) {
      actionLoading.value = false;
      customSnackbar(message: 'تعذر إكمال المشروع');
      return;
    }

    await _userService.updateUserData2(
      {'completed_projects': FieldValue.increment(1)},
      UserSession.uid!,
    );

    actionLoading.value = false;
    _updateLocalProjectStatus(ProjectStatus.completed);
    customSnackbar(message: 'تم إكمال المشروع بنجاح');
  }

  void _updateLocalProjectStatus(String status) {
    final p = project;
    if (p == null) return;

    projectRx.value = ProjectModel(
      id: p.id,
      clientId: p.clientId,
      title: p.title,
      description: p.description,
      category: p.category,
      skillsRequired: p.skillsRequired,
      budget: p.budget,
      durationDays: p.durationDays,
      status: status,
      acceptedOfferId: p.acceptedOfferId,
      createdAt: p.createdAt,
    );

    if (Get.isRegistered<ClientProjectController>()) {
      Get.find<ClientProjectController>()
          .updateProjectStatusLocally(p.id, status);
    }
    if (Get.isRegistered<FreelancerProjectController>()) {
      final fc = Get.find<FreelancerProjectController>();
      final idx = fc.projects.indexWhere((x) => x.id == p.id);
      if (idx != -1) {
        final old = fc.projects[idx];
        fc.projects[idx] = ProjectModel(
          id: old.id,
          clientId: old.clientId,
          title: old.title,
          description: old.description,
          category: old.category,
          skillsRequired: old.skillsRequired,
          budget: old.budget,
          durationDays: old.durationDays,
          status: status,
          acceptedOfferId: old.acceptedOfferId,
          createdAt: old.createdAt,
        );
        fc.projects.refresh();
      }
    }
  }

  void openPartnerProfile() {
    if (partnerUserId.value.isEmpty) return;
    Get.toNamed(
      AppRoutes.userProfile,
      arguments: {'userId': partnerUserId.value},
    );
  }

  void goBack() => NavigationService.back();

  @override
  void onClose() {
    for (final c in _taskControllers.values) {
      c.dispose();
    }
    super.onClose();
  }
}
