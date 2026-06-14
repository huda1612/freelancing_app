import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:freelancing_platform/core/classes/app_notifications.dart';
import 'package:freelancing_platform/core/classes/firebase_crud.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/classes/user_session.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/project_status.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/task_status.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/user_roles.dart';
import 'package:freelancing_platform/core/services/navigation_service.dart';
import 'package:freelancing_platform/core/services/notification_sender_services.dart';
import 'package:freelancing_platform/core/services/stripe_backend_services.dart';
import 'package:freelancing_platform/core/utils/helper_function/normalize_numbers.dart';
import 'package:freelancing_platform/core/widgets/custom_snackbar.dart';
import 'package:freelancing_platform/data/services/offer_service.dart';
import 'package:freelancing_platform/data/services/project_service.dart';
import 'package:freelancing_platform/data/services/project_task_service.dart';
import 'package:freelancing_platform/data/services/rating_service.dart';
import 'package:freelancing_platform/data/services/user_service.dart';
import 'package:freelancing_platform/models/project_collections/offer_model.dart';
import 'package:freelancing_platform/models/project_collections/project_model.dart';
import 'package:freelancing_platform/models/project_collections/task_model.dart';
import 'package:freelancing_platform/models/user_collections/rating_model.dart';
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
  final Rx<RatingModel?> myRating = Rx<RatingModel?>(null);

  final tasks = <TaskModel>[].obs;
  final extraTasks = <TaskModel>[].obs;

  final partnerName = ''.obs;
  final partnerUserId = ''.obs;
  String? freelancerAccountId;
  bool freelancerAccountCompleted = false;

  //state
  final pageState = StatusClasses.isloading.obs;
  final partnerLoading = false.obs;
  final actionLoading = false.obs;
  final ratingIsLoading = false.obs;
  final cancelIsLoading = false.obs;

  final loadingTaskIds = <String>{}.obs;
  final requestExtraTaskLoading = false.obs;

  //controllers
  final setupTasks = <SetupTaskInput>[].obs;
  final extraTasksControllers = <SetupTaskInput>[].obs;

  final TextEditingController rejectReasonController = TextEditingController();
  final TextEditingController projectCancelReasonController =
      TextEditingController();

  //*******************************getters*******************************
  double get tasksTotalAmount {
    double total = 0;

    for (final task in setupTasks) {
      total += task.amount;
    }

    return total;
  }

  //status
  bool get isSetup => project != null && project!.status == ProjectStatus.setup;
  bool get iswaitingTasksApproval =>
      project != null && project!.status == ProjectStatus.waitingTasksApproval;
  bool get isInProgress =>
      project != null && project!.status == ProjectStatus.inProgress;

  bool get isReadyToComplete =>
      project != null && project!.status == ProjectStatus.readyToComplete;

  bool get isComplete =>
      project != null && project!.status == ProjectStatus.completed;
  bool get isCanceled =>
      project != null && project!.status == ProjectStatus.cancelled;

  bool get canSendTasks {
    if (offer == null || setupTasks.isEmpty) return false;

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
      ((isInProgress && (isClient || isFreelancer)) ||
          (isReadyToComplete && isClient)) &&
      !_isReadOnlyViewer;
  bool get _isReadOnlyViewer {
    final status = project?.status;
    return status == ProjectStatus.completed ||
        status == ProjectStatus.cancelled;
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
      loadingTaskIds.isEmpty &&
      !requestExtraTaskLoading.value;

  String? get autoCompleteRemainingTime {
    if (project?.allTasksCompletedAt == null) return null;

    final completedAt = project!.allTasksCompletedAt!.toDate();
    final deadline = completedAt.add(const Duration(days: 3));

    final remaining = deadline.difference(DateTime.now());

    if (remaining.isNegative) return "0 يوم";

    final days = remaining.inDays;
    final hours = remaining.inHours % 24;

    return "$days يوم و $hours ساعة";
  }

  double get paidAmount {
    double total = 0;
    // المهام الأساسية
    for (final t in tasks) {
      if (t.status == TaskStatus.approved) {
        total += t.amount;
      }
    }
    // المهام الإضافية
    for (final t in extraTasks) {
      if (t.status == TaskStatus.approved) {
        total += t.amount;
      }
    }
    return total;
  }

  double get totalAmount {
    final base = offer?.price ?? 0;
    final extra = extraTasks
        .where((t) => t.status != TaskStatus.requested)
        .fold(0.0, (summ, t) => summ + t.amount);
    return base + extra;
  }

  bool get isRated {
    if (project == null) return false;
    return isClient ? project!.clientRated : project!.freelancerRated;
  }

  int get extraTasksCount =>
      extraTasks.where((t) => t.status != TaskStatus.requested).length;

  int get completedTasksCount =>
      tasks.where((t) => t.status == TaskStatus.approved).length;
  int get completedExtraTasksCount =>
      extraTasks.where((t) => t.status == TaskStatus.approved).length;

  double get progress =>
      (completedTasksCount + completedExtraTasksCount) /
      ((tasks.length + extraTasksCount) == 0
          ? 1
          : (tasks.length + extraTasksCount));

  int get pendingTasksForApprovalCount =>
      tasks.where((t) => t.status == TaskStatus.completedByFreelancer).length +
      extraTasks
          .where((t) => t.status == TaskStatus.completedByFreelancer)
          .length;

  bool get clientCanCencelProject {
    // Rx<bool> r = false.obs;
    return isClient &&
        (isSetup || iswaitingTasksApproval || isInProgress) &&
        !(actionLoading.value) &&
        loadingTaskIds.isEmpty;
    // return r;
  }

  double get _mainTasksCompletionRatio {
    if (tasks.isEmpty) return 0;
    final doneCount =
        tasks.where((t) => t.status == TaskStatus.approved).length;
    return doneCount / tasks.length;
  }

  bool get isMainTasksAbove75Percent {
    return _mainTasksCompletionRatio >= 0.75;
  }

  //******************************************page initalize******************************************************* */
  @override
  void onInit() {
    super.onInit();
    initPage();
  }

  Future<void> initPage() async {
    pageState.value = StatusClasses.isloading;
    await _resolveProject();
    // print(project?.toMap());

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
    //############## from arguments #########################
    final nestedArgs =
        NavigationService.routeArguments(AppRoutes.activeProject);
    final nestedProject = nestedArgs?['project'];
    if (nestedProject is ProjectModel) {
      projectRx.value = nestedProject;
      print("SOURCE = arguments1");
      return;
    }
    final args = Get.arguments;
    if (args is Map && args['project'] is ProjectModel) {
      projectRx.value = args['project'] as ProjectModel;
      print("SOURCE = arguments2");
      return;
    }
    //بحال كان مرسل رقم المشروع(من الاشعار)
    final argsProjectId = args?['projectId'];
    print("******************* projectId : $argsProjectId");
    if (argsProjectId != null) {
      final projectRes = await _projectService.getProject(argsProjectId!);
      projectRes.fold((err) async {
        pageState.value = err;
      }, (p) async {
        print("SOURCE = notification1");
        projectRx.value = p;
      });
      return;
    }

    //بحال كان مرسل رقم المشروع(من الاشعار)
    final nestedProjectId = nestedArgs?['projectId'];
    print("******************* projectId : $nestedProjectId");
    if (nestedProjectId != null) {
      final projectRes = await _projectService.getProject(nestedProjectId!);
      projectRes.fold((err) async {
        pageState.value = err;
      }, (p) async {
        projectRx.value = p;
      });
      return;
    }

    //############## from selectedProject #########################
    if (Get.isRegistered<ClientProjectController>()) {
      final p = Get.find<ClientProjectController>().selectedProject;
      if (p != null) {
        projectRx.value = p;
        print("SOURCE = selectedProject");
        return;
      }
    }
    if (Get.isRegistered<FreelancerProjectController>()) {
      final p = Get.find<FreelancerProjectController>().selectedProject;
      if (p != null) {
        print("SOURCE = selectedProject");
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
      acceptedOfferId: p.acceptedOfferId!,
    );
    offerRes.fold(
      (err) {
        customSnackbar(message: 'تعذر تحميل العرض');
        pageState.value = err;
      },
      (offer) {
        offerRx.value = offer;
      },
    );
  }

  Future<void> loadTasks() async {
    if (project == null) return;
    if (project!.status == ProjectStatus.setup && isClient) return;

    final res = await _taskService.getTasks(projectId: project!.id);
    res.fold(
      (err) {
        customSnackbar(message: 'تعذر تحميل المهام');
        // print("!!!!!!!!!! ${err.message ?? err.type}");
        pageState.value = err;
      },
      (list) {
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
    await _syncProjectStatusWithTasks();
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

    final partnerUser = await _userService
        .fetchUserData(isClient ? p.acceptedFreelancerId! : p.clientId);
    if (partnerUser != null) {
      partnerName.value =
          '${partnerUser.fname.trim()} ${partnerUser.lname.trim()}'.trim();
      if (partnerName.value.isEmpty) {
        partnerName.value = partnerUser.username;
      }
      if (isClient) {
        freelancerAccountId = partnerUser.stripeAccountId;
        freelancerAccountCompleted =
            partnerUser.stripeOnboardingCompleted ?? false;
      }
    }

    partnerLoading.value = false;
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
              status: TaskStatus.pending))
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

    // await _bootstrap();
    // await loadTasks();
  }

  /// reject setup tasks function
  Future<void> rejectProjectTasks() async {
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

    _changeLocalTaskStatus(
        index: index,
        isExtra: isExtra,
        rejectionReason: null,
        status: TaskStatus.completedByFreelancer);

    final notification = AppNotification.endTask(
        projectId: project!.id,
        projectTitle: project?.title,
        taskNumber: index + 1);
    await _sendNotificationToPartner(notification);
  }

  bool _canRejectOrApproveTask({required int index, required bool isExtra}) {
    if (!isClient || _isReadOnlyViewer) {
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

    _changeLocalTaskStatus(
        index: index,
        isExtra: isExtra,
        rejectionReason: rejectReason,
        status: TaskStatus.pending);

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
    if (freelancerAccountId == null || freelancerAccountCompleted == false) {
      customSnackbar(
          message: "لم يكمل الفريلانسر اعداد الحساب ، لا يمكن الدفع");
      return;
    }
    _startAction(taskId);

    ///4- هون لازم تتم عملية الدفع
    final paymentDone =
        await _makePayment(index: index, isExtra: isExtra, taskId: taskId);
    if (paymentDone == false) {
      _endAction(taskId);
      return;
    }

    //تغيير حالة المهمه
    final res = await FirebaseCrud.runTransaction(action: (transaction) async {
      final taskRef = _taskService.tasksRef(project!.id).doc(taskId);
      final projectRef = _projectService.projectsCollectionRef.doc(project!.id);

      final snap = await transaction.get(projectRef);
      final value = snap['completedTasksCount'] ?? 0;

      //   //1- تغيير حالة المهمة بالسيرفر
      transaction.update(
          taskRef, {'status': TaskStatus.approved, 'rejectionReason': null});
      //   //2- زيادة عدد المهام المكتمله بالمشروع
      transaction.update(projectRef, {
        "completedTasksCount": value + 1,
      });
    });

    if (res != StatusClasses.success) {
      customSnackbar(message: "خطأ : ${res.message ?? res.type}");
      _endAction(taskId);
      return;
    }
    _endAction(taskId);

    // //3- تغيير حالة المهمة محليا
    _changeLocalTaskStatus(
        index: index,
        isExtra: isExtra,
        status: TaskStatus.approved,
        rejectionReason: null);

    final newCount = (project!.completedTasksCount ?? 0) + 1;
    projectRx.value = project!.copyWith(completedTasksCount: newCount);

    _syncProjectInLists(projectRx.value!);

    customSnackbar(message: "تمت الموافقة على انهاء المهمة");

    final notification = AppNotification.approveTaskWithPayment(
        projectId: project!.id,
        projectTitle: project?.title,
        taskNumber: index + 1);

    //5 -تحقق من انتهاءالمشروع
    await _checkAndChangeToReadyToComplete();

    //6- ارسال الاشعار الى الشريك ان تمت الموافقة عالمهمة
    unawaited(_sendNotificationToPartner(notification));
  }

  Future<bool> _makePayment(
      {required String taskId,
      required int index,
      required bool isExtra}) async {
    final paymentRes = await StripeServices.createPaymentIntent(
      !isExtra ? tasks[index].amount : extraTasks[index].amount,
      freelancerAccountId!,
    );

    if (paymentRes.isLeft()) {
      final err = paymentRes.fold((l) => l, (_) => null);
      customSnackbar(
        message: "فشل إنشاء الدفع: ${err?.message ?? err?.type}",
      );
      return false;
    }

    final data = paymentRes.getOrElse(() => {});
    final clientSecret = data["clientSecret"];

    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: "Freelancity",
        ),
      );

      await Stripe.instance.presentPaymentSheet();
    } catch (e, s) {
      print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
      print(e);

      print("ERROR = $e");
      print("STACK = $s");

      customSnackbar(message: "تم إلغاء أو فشل الدفع");
      return false;
    }
    return true;
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
    requestExtraTaskLoading.value = true;

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
      requestExtraTaskLoading.value = false;

      return;
    }

    final notification = AppNotification.requestExtraTask(
      projectId: project!.id,
      projectTitle: project?.title,
      extraTaskDescription: description,
    );
    unawaited(_sendNotificationToPartner(notification));
    // await _checkAndReturnProjectToInProgress(); //هي اصلا عم تستدعى بتحميل التاسكات
    await loadTasks();
    requestExtraTaskLoading.value = false;
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

    final res = await FirebaseCrud.runTransaction(action: (transaction) async {
      final projectRef = _projectService.projectsCollectionRef.doc(project!.id);
      final taskRef = _taskService.tasksRef(project!.id).doc(taskId);

      final snap = await transaction.get(projectRef);
      final value = snap['tasksCount'] ?? 0;

      //تغيير حالة المهمه الاضافيه
      transaction.update(taskRef, {'status': TaskStatus.pending});
      //اضافه مهمه على عدد المهام الكلي للمشروع

      transaction.update(projectRef, {
        "tasksCount": value + 1,
      });
    });

    if (res != StatusClasses.success) {
      customSnackbar(message: "خطأ : ${res.message ?? res.type}");
      debugPrint("خطأ : ${res.message ?? res.type}");
      _endAction(taskId);
      return;
    }

    customSnackbar(message: "تم الموافقة على طلب المهمة الإضافية");
    _endAction(taskId);

    //تغيير حالة المهمه الاضافيه محليا
    final index = extraTasks.indexWhere((t) => t.id == taskId);
    extraTasks[index] = extraTasks[index].copyWith(status: TaskStatus.pending);
    extraTasks.refresh();

    //تغيير عدد المهام الكلي محليا
    final newCount = (project!.tasksCount ?? 0) + 1;
    projectRx.value = project!.copyWith(tasksCount: newCount);
    _syncProjectInLists(projectRx.value!);

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
    if (project!.status != ProjectStatus.inProgress) return;

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

  Future<void> completeProject() async {
    if (!canCompleteProject || project == null) return;
    //اغلاق الدايلوغ
    Get.back();
    actionLoading.value = true;
    //1- تحديث بيانات المشروع (تغيير الحاله و موعد الانهاء)
    final res = await _projectService.updateProject(
      projectId: project!.id,
      body: {
        "status": ProjectStatus.completed,
        "endAt": FieldValue.serverTimestamp(),
      },
    );

    if (res != StatusClasses.success) {
      customSnackbar(
          message: 'تعذر انهاء المشروع : ${res.message ?? res.type}');
      actionLoading.value = false;

      return;
    }

    //2- تغيير حالة المشروع محليا
    projectRx.value = project!.copyWith(
      status: ProjectStatus.completed,
      endAt: Timestamp.now(),
    );
    _updateLocalProjectStatus(ProjectStatus.completed);
    actionLoading.value = false;

    //3- تحديث عدد المشاريع المكتمله عند المستخدمين ال2
    unawaited(_increseCompletedProjects());
    customSnackbar(message: 'تم انهاء المشروع بنجاح');

    loadingTaskIds.clear();
    extraTasksControllers.clear();
    setupTasks.clear();

    final notification = AppNotification.completeProject(
        projectId: project!.id, projectTitle: project!.title);
    unawaited(_sendNotificationToPartner(notification));
  }

  Future<void> _increseCompletedProjects() async {
    await _userService.updateUserData2(
      {
        "completed_projects": FieldValue.increment(1),
      },
      project!.clientId,
    );
    if (project!.acceptedFreelancerId != null) {
      await _userService.updateUserData2(
        {
          "completed_projects": FieldValue.increment(1),
        },
        project!.acceptedFreelancerId!,
      );
    }
  }

  Future<void> onRatingSubmit(
    double professionalism,
    double communication,
    double punctuality,
    double quality,
    double workAgain,
    String? comment,
  ) async {
    if (UserSession.uid == null || project == null) return;
    if ((professionalism + communication + punctuality + quality + workAgain) ==
        0) {
      customSnackbar(message: "يرجى ادخال التقييم اولا");
      return;
    }
    if (partnerUserId.value.isEmpty) {
      customSnackbar(message: "لا يوجد شريك لتقييمه");
      return;
    }
    Get.back();
    ratingIsLoading.value = true;
    final reating = RatingModel(
        id: '',
        fromUserId: UserSession.uid!,
        projectId: project!.id,
        professionalism: professionalism,
        communication: communication,
        punctuality: punctuality,
        quality: quality,
        workAgain: workAgain,
        category: project!.category.name,
        comment: comment?.trim(),
        projectName: project!.title,
        projectStatus: project!.status);
    //1- submit the rating to server
    final res = await RatingService().submitRatingTransaction(
        userId: partnerUserId.value,
        rating: reating,
        isClientSubmitting: isClient);
    if (res != StatusClasses.success) {
      customSnackbar(message: "خطأ : ${res.message ?? res.type}");
      ratingIsLoading.value = false;
    } else {
      //2- update local rating data
      projectRx.value = projectRx.value!.copyWith(
        clientRated: isClient ? true : project!.clientRated,
        freelancerRated: isFreelancer ? true : project!.freelancerRated,
      );
      ratingIsLoading.value = false;
      customSnackbar(message: "تم التقييم بنجاح");
      _syncProjectInLists(projectRx.value!);

      final notification = AppNotification.newRating(
          projectId: project!.id, projectTitle: project!.title);
      unawaited(_sendNotificationToPartner(notification));
    }
  }

  Future<void> onViewRate() async {
    if (project == null || !isRated) return;
    if (myRating.value != null) return;
    ratingIsLoading.value = true;
    final res = await RatingService().getUserProjectRatings(
        uId: partnerUserId.value, projectId: project!.id);
    res.fold((e) {
      Get.back();
      customSnackbar(message: "خطأ : ${e.message ?? e.type}");
    }, (rating) {
      myRating.value = rating.firstOrNull;
      if (myRating.value == null) {
        customSnackbar(message: "لا يوجد تقييم لهذا المشروع");
      }
    });
    ratingIsLoading.value = false;
  }

  Future<void> cancelProject() async {
    if (!isClient || !clientCanCencelProject || project == null) return;
    //اغلاق الدايلوغ
    Get.back();
    cancelIsLoading.value = true;
    final cancelReason = projectCancelReasonController.text.trim();
    //1- تحديث بيانات المشروع (تغيير الحاله و موعد الالغاء)
    final res = await _projectService.updateProject(
      projectId: project!.id,
      body: {
        "status": ProjectStatus.cancelled,
        "endAt": FieldValue.serverTimestamp(),
        "cancelReason": cancelReason.isNotEmpty ? cancelReason : null
      },
    );

    if (res != StatusClasses.success) {
      customSnackbar(
          message: 'تعذر إلغاء المشروع : ${res.message ?? res.type}');
      cancelIsLoading.value = false;
      return;
    }

    //2- تغيير حالة المشروع محليا
    projectRx.value = project!.copyWith(
        status: ProjectStatus.cancelled,
        endAt: Timestamp.now(),
        cancelReason: cancelReason);

    _updateLocalProjectStatus(ProjectStatus.cancelled);
    cancelIsLoading.value = false;

    customSnackbar(message: 'تم إلغاء المشروع بنجاح');

    loadingTaskIds.clear();
    extraTasksControllers.clear();
    setupTasks.clear();

    final notification = AppNotification.cancelProject(
        projectId: project!.id,
        projectTitle: project!.title,
        cancelReason: cancelReason.isEmpty ? null : cancelReason);
    unawaited(_sendNotificationToPartner(notification));
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

  void _changeLocalTaskStatus(
      {required bool isExtra,
      required String? status,
      required int index,
      required String? rejectionReason}) {
    if (!isExtra) {
      tasks[index] = tasks[index]
          .copyWith(status: status, rejectionReason: rejectionReason);
      tasks.refresh();
    } else {
      extraTasks[index] = extraTasks[index]
          .copyWith(status: status, rejectionReason: rejectionReason);
      extraTasks.refresh();
    }
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
      Get.find<FreelancerProjectController>()
          .updateProjectStatusLocally(p.id, status);
    }
  }

  ///مزامنة قيم متغيرات المشروع بقوائم المشاريع اللي بالصفحة السابقة
  void _syncProjectInLists(ProjectModel updatedProject) {
    if (Get.isRegistered<ClientProjectController>()) {
      final controller = Get.find<ClientProjectController>();
      final index =
          controller.projects.indexWhere((p) => p.id == updatedProject.id);
      if (index != -1) {
        controller.projects[index] = updatedProject;
        controller.projects.refresh();
      }
    }

    if (Get.isRegistered<FreelancerProjectController>()) {
      final controller = Get.find<FreelancerProjectController>();
      final index =
          controller.projects.indexWhere((p) => p.id == updatedProject.id);
      if (index != -1) {
        controller.projects[index] = updatedProject;
        controller.projects.refresh();
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

  // Future<void> openCheckout(String url) async {
  //   final uri = Uri.parse(url);
  //   if (!await launchUrl(
  //     uri,
  //     mode: LaunchMode.externalApplication,
  //   )) {
  //     throw Exception("Could not launch checkout");
  //   }
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
    projectCancelReasonController.dispose();
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
