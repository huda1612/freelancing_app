import 'package:freelancing_platform/core/constants/data_constsnats/project_status.dart';
import 'package:freelancing_platform/data/services/project_task_service.dart';
import 'package:freelancing_platform/models/project_collections/project_model.dart';
import 'package:freelancing_platform/models/project_collections/project_task_progress.dart';
import 'package:get/get.dart';

mixin ProjectTaskProgressMixin on GetxController {
  final taskProgressMap = <String, ProjectTaskProgress>{}.obs;

  ProjectTaskService get taskProgressService => ProjectTaskService();

  Future<void> loadTaskProgressForProjects(List<ProjectModel> projects) async {
    final inProgress = projects
        .where((p) => p.status == ProjectStatus.inProgress)
        .toList();

    if (inProgress.isEmpty) {
      taskProgressMap.clear();
      return;
    }

    final map = <String, ProjectTaskProgress>{};
    await Future.wait(
      inProgress.map((project) async {
        final res =
            await taskProgressService.getTaskProgress(projectId: project.id);
        res.fold((_) {}, (progress) => map[project.id] = progress);
      }),
    );
    taskProgressMap.assignAll(map);
  }

  int? tasksDoneFor(String projectId) => taskProgressMap[projectId]?.done;

  int? tasksTotalFor(String projectId) => taskProgressMap[projectId]?.total;
}
