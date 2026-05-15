import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/core/widgets/custom_snackbar.dart';
import 'package:freelancing_platform/models/project_collections/project_model.dart';
import 'package:freelancing_platform/views/project_section/project_controller/client_project_controller.dart';
import 'package:get/get.dart';

class ActiveProjectController extends GetxController {
  ProjectModel? project;

  @override
  void onInit() {
    super.onInit();
    final argProject = Get.arguments?['project'];
    if (argProject is ProjectModel) {
      project = argProject;
      return;
    }
    if (Get.isRegistered<ClientProjectController>()) {
      project = Get.find<ClientProjectController>().selectedProject;
    }
    if (project == null) {
      customSnackbar(message: "تعذر تحميل بيانات المشروع");
    }
  }

  void openOffers() {
    if (project == null) return;
    Get.toNamed(AppRoutes.projectOffers, arguments: {
      'project': project,
      'projectId': project!.id,
    });
  }
}
