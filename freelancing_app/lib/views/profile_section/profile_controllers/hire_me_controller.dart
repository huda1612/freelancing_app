import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/classes/user_session.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/project_status.dart';
import 'package:freelancing_platform/core/services/navigation_service.dart';
import 'package:freelancing_platform/core/widgets/custom_snackbar.dart';
import 'package:freelancing_platform/data/services/project_service.dart';
import 'package:freelancing_platform/models/project_collections/project_model.dart';
import 'package:get/get.dart';

class HireMeController extends GetxController {
  final ProjectService _projectService = ProjectService();

  final pageState = StatusClasses.isloading.obs;
  final projects = <ProjectModel>[].obs;
  final String? freelancerId;

  HireMeController({this.freelancerId});

  @override
  void onInit() {
    super.onInit();
    loadClientProjects();
  }

  Future<void> loadClientProjects() async {
    pageState.value = StatusClasses.isloading;

    final res = await _projectService.getClientProjects(
      clientId: UserSession.uid!,
    );

    res.fold(
      (err) => pageState.value = err,
      (list) {
        // تصفية المشاريع الجديدة فقط
        final newProjects = list
            .where((p) => p.status == ProjectStatus.newProject)
            .toList();
        
        projects.assignAll(newProjects);
        
        if (newProjects.isEmpty) {
          pageState.value = StatusClasses.notFound;
        } else {
          pageState.value = StatusClasses.success;
        }
      },
    );
  }

  void selectProject(ProjectModel project) {
    // توجيه المستقل لصفحة تقديم عرض على المشروع
    NavigationService.toNamed(
      AppRoutes.submitOffer,
      arguments: {
        'project': project,
        'projectId': project.id,
      },
    );
    Get.back();
  }

  void showNoProjectsDialog() {
    Get.defaultDialog(
      title: "لا توجد مشاريع",
      middleText: "ليس لديك مشاريع جديدة متاحة للتوظيف حالياً",
      textConfirm: "حسناً",
      onConfirm: () => Get.back(),
    );
  }
}
