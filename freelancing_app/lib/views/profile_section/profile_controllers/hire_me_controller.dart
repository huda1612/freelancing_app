import 'package:freelancing_platform/core/classes/app_notifications.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/classes/user_session.dart';
import 'package:freelancing_platform/core/constants/app_notification_types.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/project_status.dart';
import 'package:freelancing_platform/core/services/navigation_service.dart';
import 'package:freelancing_platform/core/services/notification_sender_services.dart';
import 'package:freelancing_platform/core/widgets/custom_snackbar.dart';
import 'package:freelancing_platform/data/services/project_service.dart';
import 'package:freelancing_platform/models/project_collections/project_model.dart';
import 'package:freelancing_platform/views/profile_section/profile_controllers/profile_controller.dart';
import 'package:get/get.dart';

class HireMeController extends GetxController {
  final ProjectService _projectService = ProjectService();

  final pageState = StatusClasses.isloading.obs;
  final projects = <ProjectModel>[].obs;
  final String freelancerId;

  HireMeController({required this.freelancerId});

  @override
  void onInit() {
    super.onInit();
    loadClientProjects();
  }

  Future<void> loadClientProjects() async {
    pageState.value = StatusClasses.isloading;

    final res = await _projectService.getClientProjects(
        clientId: UserSession.uid!, justNewProjects: true);

    res.fold(
      (err) => pageState.value = err,
      (list) {
        projects.assignAll(list);
        // if (newProjects.isEmpty) {
        //   pageState.value = StatusClasses.notFound;
        // } else {
        pageState.value = StatusClasses.success;
        // }
      },
    );
  }

  Future<void> selectProject(ProjectModel project) async {
    // if(freelancerId == null) {
    //   Get.back();
    //   customSnackbar(message: "حدث خطأ ! الرجاء اعادة الدخول الى الصفحة");
    //   return;}
    //ارسال اشعار لازم
    Get.back();
    String? clientName;
    if (Get.isRegistered<ProfileController>(tag: UserSession.uid)) {
      clientName = Get.find<ProfileController>(tag: UserSession.uid).fullName;
    }
    final notification = AppNotification.hireMe(
        projectId: project.id,
        projectTitle: project.title,
        clientName: clientName);
    await NotificationSenderServices.sendNotificationToUser(
        uId: freelancerId,
        title: notification.title,
        body: notification.body,
        data: notification.data);
    customSnackbar(message: "لقد تم ارسال الطلب");
  }

  // void showNoProjectsDialog() {
  //   Get.defaultDialog(
  //     title: "لا توجد مشاريع",
  //     middleText: "ليس لديك مشاريع جديدة متاحة للتوظيف حالياً",
  //     textConfirm: "حسناً",
  //     onConfirm: () => Get.back(),
  //   );
  // }
}
