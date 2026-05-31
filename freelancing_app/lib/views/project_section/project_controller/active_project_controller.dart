import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/classes/app_notifications.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/classes/user_session.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/project_status.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/task_status.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/user_roles.dart';
import 'package:freelancing_platform/core/services/navigation_service.dart';
import 'package:freelancing_platform/core/services/notification_sender_services.dart';
import 'package:freelancing_platform/core/utils/helper_function/normalize_numbers.dart';
import 'package:freelancing_platform/core/widgets/custom_snackbar.dart';
import 'package:freelancing_platform/data/services/offer_service.dart';
import 'package:freelancing_platform/data/services/project_service.dart';
import 'package:freelancing_platform/data/services/project_task_service.dart';
import 'package:freelancing_platform/data/services/user_service.dart';
import 'package:freelancing_platform/models/project_collections/offer_model.dart';
import 'package:freelancing_platform/models/project_collections/project_model.dart';
import 'package:freelancing_platform/models/project_collections/task_model.dart';
import 'package:freelancing_platform/views/project_section/project_controller/client_project_controller.dart';
import 'package:freelancing_platform/views/project_section/project_controller/freelance_project_controller.dart';
import 'package:get/get.dart';

class ActiveProjectController extends GetxController {
  //services
  final ProjectTaskService _taskService = ProjectTaskService();
  final ProjectService _projectService = ProjectService();
  final OfferService _offerService = OfferService();
  final UserService _userService = UserService();

//data
  final Rx<ProjectModel?> projectRx = Rx<ProjectModel?>(null);
  final Rx<OfferModel?> offerRx = Rx<OfferModel?>(null);

  final tasks = <TaskModel>[].obs;
  final extraTasks = <TaskModel>[].obs;

  final partnerName = ''.obs;
  final partnerUserId = ''.obs;

  //state
  final pageState = StatusClasses.isloading.obs;
  final partnerLoading = false.obs;
  final actionLoading = false.obs;
  /////بدها حذف !!!!!!!!!!!!
  // final addIsLoading = false.obs;
  final loadingTaskIds = <String>{}.obs;

  //controllers
  // final Map<String, TextEditingController> _taskControllers = {};
  // final newTaskController = Rx<TextEditingController?>(null);
  final setupTasks = <SetupTaskInput>[].obs;
  final extraTasksControllers = <SetupTaskInput>[].obs;

  final TextEditingController rejectReasonController = TextEditingController();
  double get tasksTotalAmount {
    double total = 0;

    for (final task in setupTasks) {
      total += task.amount;
    }

    return total;
  }

  //*******************************getters*******************************

  //status
  bool get isSetup => project != null && project!.status == ProjectStatus.setup;
  bool get iswaitingTasksApproval =>
      project != null && project!.status == ProjectStatus.waitingTasksApproval;
  bool get isInProgress =>
      project != null && project!.status == ProjectStatus.inProgress;

  bool get isReadyToComplete =>
      project != null && project!.status == ProjectStatus.readyToComplete;

  bool get iscompleteOrCencel =>
      project != null &&
      (project!.status == ProjectStatus.completed ||
          project!.status == ProjectStatus.cancelled);

  bool get canSendTasks {
    if (offer == null) return false;

    if (setupTasks.isEmpty) return false;

    final target = offer!.price;

    return tasksTotalAmount == target;
  }

  ProjectModel? get project => projectRx.value;
  OfferModel? get offer => offerRx.value;

  bool get isClient => UserSession.role == UserRole.client;
  bool get isFreelancer => UserSession.role == UserRole.freelancer;

  bool get canEditTasks =>
      isFreelancer && (isInProgress || isSetup) && !_isReadOnlyViewer;
  bool get canAddBasTask => isFreelancer && isSetup && !_isReadOnlyViewer;

  bool get canManageExtraTasks =>
      (isFreelancer || isClient) &&
      (isInProgress || isReadyToComplete) &&
      !_isReadOnlyViewer;

  bool get _isReadOnlyViewer {
    final status = project?.status;
    return status == ProjectStatus.completed ||
        status == ProjectStatus.cancelled;
    //|| status == ProjectStatus.delivered;
  }

  bool get allTasksDone =>
      tasks.isNotEmpty &&
      tasks.every((t) => (t.status == TaskStatus.approved)) &&
      extraTasks.every((t) => (t.status == TaskStatus.approved));

  bool get canCompleteProject =>
      isClient &&
      isReadyToComplete &&
      allTasksDone &&
      !(actionLoading.value) &&
      loadingTaskIds.isEmpty;
  //  &&!(addIsLoading.value);
  // bool get canApproveCompletion =>
  //     isClient &&
  //     project?.status == ProjectStatus.readyToComplete &&
  //     !(actionLoading.value);
  // &&!(addIsLoading.value);

  //******************************************page initalize******************************************************* */
  @override
  void onInit() async {
    super.onInit();
    await initPage();
  }

  Future<void> initPage() async {
    pageState.value = StatusClasses.isloading;
    await _resolveProject();
    if (projectRx.value != null) {
      await _bootstrap();
    } else {
      if (pageState.value != StatusClasses.isloading) {
        return;
      }
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
      final projectRes = await _projectService.getProject(nestedProjectId!);
      projectRes.fold((err) async {
        pageState.value = err;
        // print(pageState.value.message);
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
      loadOffer(),
      loadTasks(),
    ]);
    await _loadPartnerInfo();
    await _syncProjectStatusWithTasks();

    if (pageState.value != StatusClasses.isloading) {
      return;
    }
    pageState.value = StatusClasses.success;
  }

  Future<void> loadOffer() async {
    final p = project;
    if (p == null) return;
    if (p.acceptedOfferId == null) return;
    final offerRes = await _offerService.getAcceptedOfferForProject(
      // projectId: p.id,
      acceptedOfferId: p.acceptedOfferId!,
    );
    offerRes.fold(
      (err) {
        pageState.value = err;
      },
      (offer) {
        offerRx.value = offer;
      },
    );
  }

  Future<void> _loadPartnerInfo() async {
    final p = project;
    if (p == null) return;

    partnerLoading.value = true;
    if (p.acceptedFreelancerId == null && isClient) {
      partnerName.value = "unKnown";
      partnerLoading.value = false;

      return;
    }
    partnerUserId.value = isClient ? p.acceptedFreelancerId! : p.clientId;

    final user = await _userService
        .fetchUserData(isClient ? p.clientId : p.acceptedFreelancerId!);
    if (user != null) {
      partnerName.value = '${user.fname.trim()} ${user.lname.trim()}'.trim();
      if (partnerName.value.isEmpty) {
        partnerName.value = user.username;
      }
    }

    partnerLoading.value = false;
  }

  Future<void> loadTasks() async {
    // final p = project;
    if (project == null) return;
    if (project!.status == ProjectStatus.setup && isClient) return;
    final res = await _taskService.getTasks(projectId: project!.id);
    res.fold(
      (err) {
        customSnackbar(message: 'تعذر تحميل المهام');
        pageState.value = err;
      },
      (list) {
        // _syncTaskControllers(list);
        if (isSetup) {
          for (final t in setupTasks) {
            t.descriptionController.dispose();
            t.amountController.dispose();
          }
          setupTasks.clear();
          setupTasks.addAll(list.map((st) => SetupTaskInput(
              descriptionController:
                  TextEditingController(text: st.description),
              amountController:
                  TextEditingController(text: st.amount.toString()))));
        } else {
          tasks.assignAll(list.where((t) => t.isExtra == false));
          extraTasks.assignAll(list.where((t) => t.isExtra == true));
        }
      },
    );
    // await _syncProjectStatusWithTasks();
  }

  //******************************************project setup status operations********************************************* */

  ///on + icon press function
  void onAddNewTask() {
    if (!canAddBasTask || project == null) return;

    setupTasks.add(
      SetupTaskInput(
        descriptionController: TextEditingController(),
        amountController: TextEditingController(),
      ),
    );
  }

  String? _validateSetupTasks() {
    if (setupTasks
        .where((t) => t.descriptionController.text.trim().isEmpty)
        .toList()
        .isNotEmpty) {
      return "لا يمكن ارسال مهمة بوصف فارغ";
    }
    if (!canSendTasks) {
      return "المبلغ الاجمالي للمهام لا يساوي المبلغ المتفق عليه";
    }
    return null;
  }

  ///send task function
  Future<void> sendTasks() async {
    if (!canSendTasks || project == null) return;
    actionLoading.value = true;

    final validate = _validateSetupTasks();
    if (validate != null) {
      customSnackbar(message: validate);
      actionLoading.value = false;

      return;
    }

    final res = await _taskService.sendSetupTasks(
      projectId: project!.id,
      setupTasks: setupTasks
          .map((t) => TaskModel(
                  id: '',
                  description: t.descriptionController.text.trim(),
                  amount: t.amount,
                  status: TaskStatus.pending)
              // {
              //       'description': t.descriptionController.text.trim(),
              //       'amount': t.amount,
              //     }
              )
          .toList(),
    );
    actionLoading.value = false;

    if (res != StatusClasses.success) {
      customSnackbar(message: 'تعذر ارسال المهام');
      return;
    }
    _updateLocalProjectStatus(ProjectStatus.waitingTasksApproval);
    customSnackbar(message: 'تم ارسال المهام بنجاح — بانتظار موافقة العميل');
    // await _bootstrap();
    await loadTasks();

    //ارسال اشعار
    final notification = AppNotification.sendTasks(
        projectId: project!.id, projectTitle: project!.title);
    if (partnerUserId.value.isEmpty) {
      customSnackbar(message: "لا يوجد عميل لايمكن ارسال الاشعار");
      return;
    }
    await _sendNotificationToPartner(notification);
  }

  /// approve setup tasks function
  Future<void> approveProjectTasks() async {
    if (!isClient) {
      customSnackbar(message: "فقط العيمل يمكنه الموافقة");
      return;
    }
    if (project == null) {
      customSnackbar(
          message: "حدث خطأ في جلب بيانات المشروع لا يمكن الموافقة الان");
      return;
    }
    actionLoading.value = true;

    final res =
        await _projectService.updateProject(projectId: project!.id, body: {
      "status": ProjectStatus.inProgress,
      "tasksCount": tasks.length,
      "completedTasksCount": 0,
      "startAt": FieldValue.serverTimestamp(),
    });

    actionLoading.value = false;

    if (res != StatusClasses.success) {
      customSnackbar(message: 'تعذر الموافقة : ${res.message ?? res.type}');
      return;
    }
    _updateLocalProjectStatus(ProjectStatus.inProgress);

    projectRx.value = project!.copyWith(
      startAt: Timestamp.now(),
    );

    customSnackbar(message: 'تمت الموفقة على المهام بنجاح');
    //ارسال اشعار
    final notification = AppNotification.approveTasks(
        projectId: project!.id, projectTitle: project!.title);
    if (partnerUserId.value.isEmpty) {
      customSnackbar(message: "لا يوجد فريلانسر لايمكن ارسال الاشعار");
      return;
    }
    await _sendNotificationToPartner(notification);

    // await NotificationSenderServices.sendNotificationToUser(
    //     uId: partnerUserId.value,
    //     title: rejNotif.title,
    //     body: rejNotif.body,
    //     data: rejNotif.data);
    // await _bootstrap();
    // await loadTasks();
  }

  /// reject setup tasks function
  Future<void> rejectProjectTasks() async {
    if (!isClient) {
      customSnackbar(message: "فقط العيمل يمكنه الموافقة");
      return;
    }
    actionLoading.value = true;

    final res = await _projectService.updateProjectStatus(
        projectId: project!.id, status: ProjectStatus.setup);

    actionLoading.value = false;

    if (res != StatusClasses.success) {
      customSnackbar(message: 'تعذر الرفض : ${res.message ?? res.type}');
      return;
    }
    _updateLocalProjectStatus(ProjectStatus.setup);
    tasks.clear();
    tasks.refresh();
    customSnackbar(message: 'تم رفض المهام');
    //ارسال اشعار
    final notification = AppNotification.rejectTasks(
        projectId: project!.id, projectTitle: project!.title);
    await _sendNotificationToPartner(notification);
  }

  //******************************************tasks in progress operations********************************************* */
  ///في حال قام الفريلانسر بانهاء المهمة
  Future<void> onFreelancerEndTask(
      {required String taskId, required int index, required isExtra}) async {
    Get.back();
    if (!canEditTasks) {
      customSnackbar(message: "لا يمكنك التعديل على حالة المهام");
      return;
    }
    if (project == null) return;

    if (!isExtra) {
      if (tasks[index].status != TaskStatus.pending) return;
    } else {
      if (extraTasks[index].status != TaskStatus.pending) return;
    }

    _startAction(taskId);

    final res = await _taskService.updateTask(
      projectId: project!.id,
      taskId: taskId,
      data: {
        'status': TaskStatus.completedByFreelancer,
        'rejectionReason': null
      },
    );
    if (res != StatusClasses.success) {
      customSnackbar(message: "خطأ : ${res.message ?? res.type}");
      _endAction(taskId);

      return;
    }
    _endAction(taskId);
    customSnackbar(message: "تم طلب انهاء المهمة");
    if (!isExtra) {
      tasks[index] = tasks[index].copyWith(
          status: TaskStatus.completedByFreelancer, rejectionReason: null);
    } else {
      extraTasks[index] = extraTasks[index].copyWith(
          status: TaskStatus.completedByFreelancer, rejectionReason: null);
    }

    final notification = AppNotification.endTask(
        projectId: project!.id,
        projectTitle: project?.title,
        taskNumber: index + 1);
    await _sendNotificationToPartner(notification);
  }

  bool _canRejectOrApproveTask({required int index, required bool isExtra}) {
    if (!isClient && !_isReadOnlyViewer) {
      return false;
    }
    if (project == null) return false;
    if (!isExtra) {
      if (tasks[index].status != TaskStatus.completedByFreelancer) {
        return false;
      }
    } else {
      if (extraTasks[index].status != TaskStatus.completedByFreelancer) {
        return false;
      }
    }
    return true;
  }

  ///في حال قام العميل برفض انهاء المهمة
  Future<void> onClientRejectTask(
      {required String taskId,
      required int index,
      required bool isExtra}) async {
    if (!_canRejectOrApproveTask(index: index, isExtra: isExtra)) {
      customSnackbar(message: "لا يمكنك رفض انهاء المهمة");
      return;
    }
    final rejectReason = rejectReasonController.text.trim();

    if (rejectReason.isEmpty) {
      customSnackbar(message: "يرجى ادخال سبب الرفض اولا");
      return;
    }
    Get.back();

    _startAction(taskId);
    rejectReasonController.clear();

    final res = await _taskService.updateTask(
      projectId: project!.id,
      taskId: taskId,
      data: {'status': TaskStatus.pending, 'rejectionReason': rejectReason},
    );
    if (res != StatusClasses.success) {
      customSnackbar(message: "خطأ : ${res.message ?? res.type}");
      _endAction(taskId);

      return;
    }
    _endAction(taskId);

    if (!isExtra) {
      tasks[index] = tasks[index]
          .copyWith(status: TaskStatus.pending, rejectionReason: rejectReason);
    } else {
      extraTasks[index] = extraTasks[index]
          .copyWith(status: TaskStatus.pending, rejectionReason: rejectReason);
    }

    customSnackbar(message: "تم رفض انهاء المهمة");

    final notification = AppNotification.rejectTask(
        projectId: project!.id,
        projectTitle: project?.title,
        rejectionReason: rejectReason,
        taskNumber: index + 1);
    await _sendNotificationToPartner(notification);
  }

  ///في حال قام العميل بالموافقة على انهاء المهمة
  Future<void> onClientApproveTask(
      {required String taskId,
      required int index,
      required bool isExtra}) async {
    if (!_canRejectOrApproveTask(index: index, isExtra: isExtra)) {
      customSnackbar(message: "لا يمكنك الموافقه على المهمة");
      return;
    }
    //1- تغيير حالة المهمة بالسيرفر
    _startAction(taskId);
    final res = await _taskService.updateTask(
      projectId: project!.id,
      taskId: taskId,
      data: {'status': TaskStatus.approved, 'rejectionReason': null},
    );
    if (res != StatusClasses.success) {
      customSnackbar(message: "خطأ : ${res.message ?? res.type}");
      _endAction(taskId);
      return;
    }
    _endAction(taskId);

    //2- تغيير حالة المهمة محليا
    if (!isExtra) {
      tasks[index] = tasks[index]
          .copyWith(status: TaskStatus.approved, rejectionReason: null);
    } else {
      extraTasks[index] = extraTasks[index]
          .copyWith(status: TaskStatus.approved, rejectionReason: null);
    }

    ///3- هون لازم تتم عملية الدفع !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    customSnackbar(message: "تمت الموافقة على انهاء المهمة");

    final notification = AppNotification.approveTask(
        projectId: project!.id,
        projectTitle: project?.title,
        taskNumber: index + 1);

    await Future.wait([
      //4 -تحقق من انتهاءالمشروع
      _checkAndChangeToReadyToComplete(),
      //5- زيادة عدد المهام المكتمله بالمشروع
      _projectService.updateProject(
          projectId: project!.id,
          body: {"completedTasksCount": FieldValue.increment(1)}),
    ]);
    //6- ارسال الاشعار الى الشريك ان تمت الموافقة عالمهمة
    unawaited(_sendNotificationToPartner(notification));
    //2- زيادة عدد المهام المكتمله بالمشروع
    // await _projectService.updateProject(
    //     projectId: project!.id,
    //     body: {"completedTasksCount": FieldValue.increment(1)});

    //4- ارسال الاشعار الى الشريك ان تمت الموافقة عالمهمة
    // if (partnerUserId.value.isEmpty) {
    //   customSnackbar(message: "لا يوجد مستقل لايمكن ارسال الاشعار");
    //   return;
    // }

    // final notification = AppNotification.approveTask(
    //     projectId: project!.id,
    //     projectTitle: project?.title,
    //     taskNumber: index + 1);

    // await _sendNotificationToPartner(notification);
  }

  //******************************************Extra tasks in progress operations********************************************* */
  ///تابع اضافة حقول لادخال مهمه اضافية
  void onAddExtraTasks() {
    if (!canManageExtraTasks || project == null) return;

    extraTasksControllers.add(
      SetupTaskInput(
        descriptionController: TextEditingController(),
        amountController: TextEditingController(),
      ),
    );
  }

  Future<bool> _checkExtraTaskExist(String taskId) async {
    await loadTasks();
    final index = extraTasks.indexWhere((t) => t.id == taskId);
    return index != -1 && extraTasks[index].status == TaskStatus.requested;
  }

  ///تابع ارسال طلب المهمة الاضافية
  Future<void> onRequestExtraTask(int index) async {
    if (!canManageExtraTasks || project == null) return;
    if (index < 0 || index >= extraTasksControllers.length) return;
    final description = extraTasksControllers[index].descriptionController.text;
    final amount = extraTasksControllers[index].amount;
    if (description.isEmpty) {
      customSnackbar(message: "يجب ادخال تفاصيل المهمة أولا");
      return;
    }
    extraTasksControllers[index].descriptionController.dispose();
    extraTasksControllers[index].amountController.dispose();
    extraTasksControllers.removeAt(index);

    customSnackbar(message: "جار طلب المهمه");

    final res = await _taskService.addTask(
      projectId: project!.id,
      description: description,
      amount: amount,
      isExtra: true,
      requestedBy: UserSession.uid,
    );
    if (res != StatusClasses.success) {
      customSnackbar(message: "خطأ : ${res.message ?? res.type}");
      return;
    }
    await _checkAndReturnProjectToInProgress();
    loadTasks();
    final notification = AppNotification.requestExtraTask(
      projectId: project!.id,
      projectTitle: project?.title,
      extraTaskDescription: description,
    );
    unawaited(_sendNotificationToPartner(notification));
  }

  ///تابع الغاء او رفض المهمة الاضافية
  Future<void> onCancelOrRejectRequestedTask(
      {required String taskId,
      required String taskDescription,
      required bool isCencel}) async {
    if (!canManageExtraTasks || project == null) return;
    _startAction(taskId);

    //اول شي بتأكد لو التاسك موجود اسا وما انرفض ولا توافق عليه
    if (!await _checkExtraTaskExist(taskId)) {
      isCencel
          ? customSnackbar(message: "لم يعد بامكانك إلغاء الطلب ")
          : customSnackbar(message: "لم يعد بامكانك رفض الطلب ");
      _endAction(taskId);
      return;
    }
    final res =
        await _taskService.deleteTask(projectId: project!.id, taskId: taskId);
    if (res != StatusClasses.success) {
      customSnackbar(message: "خطأ : ${res.message ?? res.type}");
      _endAction(taskId);
      return;
    }
    isCencel
        ? customSnackbar(message: "تم إلغاء طلب المهمة الإضافية")
        : customSnackbar(message: "تم رفض طلب المهمة الإضافية");
    _endAction(taskId);

    //حذف المهمه الاضافيه محليا
    extraTasks.removeWhere((t) => t.id == taskId);

    //التحقق من انتهاء المشروع وتغيير حالته اذا انتهى
    await _checkAndChangeToReadyToComplete();

    //ارسال الاشعار
    AppNotification notification;
    isCencel
        ? notification = AppNotification.cancelRequestExtraTask(
            projectId: project!.id,
            projectTitle: project?.title,
            extraTaskDescription: taskDescription,
          )
        : notification = AppNotification.rejectRequestedExtraTask(
            projectId: project!.id,
            projectTitle: project?.title,
            extraTaskDescription: taskDescription,
          );
    unawaited(_sendNotificationToPartner(notification));
  }

  ///تابع الموافقة على المهمة الاضافية
  Future<void> onApproveRequestedTask({
    required String taskId,
    required String taskDescription,
  }) async {
    if (!canManageExtraTasks || project == null) return;
    _startAction(taskId);

    //اول شي بتأكد لو التاسك موجود اسا وما انلغى
    if (!await _checkExtraTaskExist(taskId)) {
      customSnackbar(
          message: "لم يعد بامكانك الموافقة على الطلب ، لقد تم إلغاءه ");
      _endAction(taskId);
      return;
    }

    //تغيير حالة المهمه الاضافيه
    final res = await _taskService.updateTask(
      projectId: project!.id,
      taskId: taskId,
      data: {
        'status': TaskStatus.pending,
      },
    );
    if (res != StatusClasses.success) {
      customSnackbar(message: "خطأ : ${res.message ?? res.type}");
      _endAction(taskId);
      return;
    }

    customSnackbar(message: "تم الموافقة على طلب المهمة الإضافية");
    _endAction(taskId);

    //تغيير حالة المهمه الاضافيه محليا
    final index = extraTasks.indexWhere((t) => t.id == taskId);
    extraTasks[index] = extraTasks[index].copyWith(status: TaskStatus.pending);

    //اضافه مهمه على عدد المهام الكلي للمشروع
    await _projectService.updateProject(
        projectId: project!.id, body: {"tasksCount": FieldValue.increment(1)});

    //ارسال الاشعار
    final notification = AppNotification.approveRequestExtraTask(
      projectId: project!.id,
      projectTitle: project?.title,
      extraTaskDescription: taskDescription,
    );

    await _sendNotificationToPartner(notification);
  }

  //******************************************end project functions********************************************* */
  Future<void> _checkAndChangeToReadyToComplete() async {
    if (!allTasksDone || project == null) return;
    if (project!.status == ProjectStatus.readyToComplete) return;

    await _projectService.updateProject(projectId: project!.id, body: {
      "status": ProjectStatus.readyToComplete,
      "allTasksCompletedAt": Timestamp.now()
    });
    _updateLocalProjectStatus(ProjectStatus.readyToComplete);
    projectRx.value = project!.copyWith(allTasksCompletedAt: Timestamp.now());
    //ما حدثت قيمه التاريخ بالصفحه السابقه صفحه مشاريعي يعني !
  }

  Future<void> _checkAndReturnProjectToInProgress() async {
    if (allTasksDone || project == null) return;

    if (project!.status != ProjectStatus.readyToComplete) return;

    await _projectService.updateProject(
      projectId: project!.id,
      body: {
        "status": ProjectStatus.inProgress,
        "allTasksCompletedAt": null,
      },
    );

    _updateLocalProjectStatus(ProjectStatus.inProgress);
  }
  //******************************************idk yet********************************************* */

  Future<void> deliverProject() async {
    // if (!canDeliverProject || project == null) return;

    // actionLoading.value = true;
    // final res = await _projectService.updateProjectStatus(
    //   projectId: project!.id,
    //   status: ProjectStatus.delivered,
    // );
    // actionLoading.value = false;

    // if (res != StatusClasses.success) {
    //   customSnackbar(message: 'تعذر تسليم المشروع');
    //   return;
    // }

    // _updateLocalProjectStatus(ProjectStatus.delivered);
    // customSnackbar(message: 'تم تسليم المشروع — بانتظار موافقة العميل');
  }

  Future<void> approveProjectCompletion() async {
    // if (!canApproveCompletion || project == null) return;

    // actionLoading.value = true;
    // final res = await _projectService.updateProjectStatus(
    //   projectId: project!.id,
    //   status: ProjectStatus.completed,
    // );

    // if (res != StatusClasses.success) {
    //   actionLoading.value = false;
    //   customSnackbar(message: 'تعذر إكمال المشروع');
    //   return;
    // }

    // await _userService.updateUserData2(
    //   {'completed_projects': FieldValue.increment(1)},
    //   UserSession.uid!,
    // );

    // actionLoading.value = false;
    // _updateLocalProjectStatus(ProjectStatus.completed);
    // customSnackbar(message: 'تم إكمال المشروع بنجاح');
  }

  //******************************************helper functions********************************************* */
  void _startAction(String taskId) {
    loadingTaskIds.add(taskId);
  }

  void _endAction(String taskId) {
    loadingTaskIds.remove(taskId);
  }

  bool isTaskLoading(String taskId) {
    return loadingTaskIds.contains(taskId);
  }

  void _updateLocalProjectStatus(String status) {
    final p = project;
    if (p == null) return;

    projectRx.value = p.copyWith(
      status: status,
    );

    if (Get.isRegistered<ClientProjectController>()) {
      Get.find<ClientProjectController>()
          .updateProjectStatusLocally(p.id, status);
    }
    if (Get.isRegistered<FreelancerProjectController>()) {
      final fc = Get.find<FreelancerProjectController>();
      final idx = fc.projects.indexWhere((x) => x.id == p.id);
      if (idx != -1) {
        // final old = fc.projects[idx];
        fc.projects[idx] = fc.projects[idx].copyWith(
          status: status,
        );
        fc.projects.refresh();
      }
    }
  }

  void openPartnerProfile() {
    if (partnerUserId.value.isEmpty) return;
    // print("partner id : ${partnerUserId.value}");
    Get.toNamed(
      AppRoutes.userProfile,
      arguments: {'userId': partnerUserId.value},
    );
  }

  ///تابع ارسال اشعار الى الشريك
  Future<void> _sendNotificationToPartner(AppNotification notification) async {
    if (partnerUserId.value.isEmpty) {
      customSnackbar(message: "لا يوجد شريك لايمكن ارسال الاشعار");
      return;
    }

    await NotificationSenderServices.sendNotificationToUser(
        uId: partnerUserId.value,
        title: notification.title,
        body: notification.body,
        data: notification.data);
  }

  Future<void> _syncProjectStatusWithTasks() async {
    if (project == null) return;

    if (allTasksDone) {
      await _checkAndChangeToReadyToComplete();
    } else {
      await _checkAndReturnProjectToInProgress();
    }
  }
//******************************************old functions********************************************* */
  // bool taskIsEditing(String taskId) => _taskControllers.containsKey(taskId);

  // void _syncTaskControllers(List<TaskModel> list) {
  //   final ids = list.map((t) => t.id).toSet();
  //   for (final id in _taskControllers.keys.toList()) {
  //     if (!ids.contains(id)) {
  //       _taskControllers[id]?.dispose();
  //       _taskControllers.remove(id);
  //     }
  //   }
  //   for (final task in list) {
  //     final ctrl = _taskControllers.putIfAbsent(
  //       task.id,
  //       () => TextEditingController(text: task.description),
  //     );
  //     if (ctrl.text != task.description) {
  //       ctrl.text = task.description;
  //     }
  //   }
  // }

//delet please
  // TextEditingController taskController(String taskId) {
  //   return _taskControllers.putIfAbsent(
  //     taskId,
  //     () => TextEditingController(),
  //   );
  // }

  //ok
  // Future<void> onAddNewTask() async {
  //   if (!canEditTasks || project == null) return;
  //   if (isAddingTask) return;
  //   newTaskController.value = TextEditingController(text: "");
  //   print("!!!!!!!!!!!!!!!!!!! $isAddingTask");
  // }

//ok
  // Future<void> cencelAddingNewTask() async {
  //   newTaskController.value = null;
  // }

//ok
  // void onChangeNewTask(String value) {
  //   newTaskController.value!.text = value;
  // }

//ok
  // Future<void> saveNewTask() async {
  //   if (!canEditTasks || project == null) return;

  //   final newTask = newTaskController.value?.text;
  //   if (newTask == null || newTask.trim().isEmpty) {
  //     customSnackbar(message: "لا يمكن اضافة مهمة فارغة");
  //     return;
  //   }
  //   addIsLoading.value = true;
  //   final addResponse = await _taskService.addTask(
  //       projectId: project!.id, description: newTask);
  //   if (addResponse != StatusClasses.success) {
  //     customSnackbar(
  //         message: "حدث خطأ :${addResponse.type} / ${addResponse.message}");
  //     addIsLoading.value = false;
  //     return;
  //   }
  //   await loadTasks();
  //   // if(pageState.value != StatusClasses.success) return;
  //   newTaskController.value = null;
  //   addIsLoading.value = false;
  //   customSnackbar(message: "تمت إضافة المهمه بنجاح");
  // }

  // Future<void> updateTaskDescription(String taskId, String description) async {
  // if (!canEditTasks || project == null) return;

  // final index = tasks.indexWhere((t) => t.id == taskId);
  //    if (index == -1) return;

  //   tasks[index] = tasks[index].copyWith(description: description);

  //   await _taskService.updateTask(
  //      projectId: project!.id,
  //     taskId: taskId,
  //     data: {'description': description},
  //   );
  // }

  // Future<void> toggleTaskDone(String taskId, bool? value) async {
  //   if (!canEditTasks) {
  //     customSnackbar(message: "لا يمكنك التعديل على حالة المهام");
  //     return;
  //   }
  //   if (project == null || value == null) return;
  //   final index = tasks.indexWhere((t) => t.id == taskId);
  //   if (index == -1) return;
  //   if (tasks[index].status == TaskStatus.approved) return;
  //   tasks[index] = tasks[index].copyWith(
  //       status: value ? TaskStatus.completedByFreelancer : TaskStatus.pending);

  //   await _taskService.updateTask(
  //     projectId: project!.id,
  //     taskId: taskId,
  //     data: {
  //       'status': value ? TaskStatus.completedByFreelancer : TaskStatus.pending
  //     },
  //   );
  // }

  @override
  void onClose() {
    for (final t in setupTasks) {
      t.descriptionController.dispose();
      t.amountController.dispose();
    }

    for (final t in extraTasksControllers) {
      t.descriptionController.dispose();
      t.amountController.dispose();
    }

    rejectReasonController.dispose();

    super.onClose();
  }
}

class SetupTaskInput {
  final TextEditingController descriptionController;
  final TextEditingController amountController;

  SetupTaskInput({
    required this.descriptionController,
    required this.amountController,
  });

  double get amount =>
      double.tryParse(amountController.text) ??
      double.tryParse(normalizeNumbers(amountController.text)) ??
      0;
}
