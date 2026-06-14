import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/project_status.dart';
import 'package:freelancing_platform/models/project_collections/project_model.dart';
import 'package:freelancing_platform/views/project_section/project_widgets/project_card.dart';
import 'package:freelancing_platform/views/project_section/project_widgets/status_container.dart';
//ok
enum ClientProjectTileMode {
  newProject,
  setup,
  waitingTasksApproval,
  inProgress,
  readyToComplete,
  completed,
  cancelled,
}

class ClientProjectTile extends StatelessWidget {
  const ClientProjectTile({
    super.key,
    required this.project,
    required this.mode,
    // this.isBusy = false,
    this.tasksDone,
    this.tasksTotal,
    this.onTap,
    // this.onDelete,
  });

  final ProjectModel project;
  final ClientProjectTileMode mode;
  // final bool isBusy;
  final int? tasksDone;
  final int? tasksTotal;
  final VoidCallback? onTap;
  // final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return ProjectCard(
      project: project,
      onTap: onTap,
      tasksDone: mode == ClientProjectTileMode.inProgress ||
              mode == ClientProjectTileMode.readyToComplete
          ? tasksDone
          : null,
      tasksTotal: mode == ClientProjectTileMode.inProgress ||
              mode == ClientProjectTileMode.readyToComplete
          ? tasksTotal
          : null,
      header: _buildHeader(),
    );
  }

  Widget? _buildHeader() {
    // if (mode == ClientProjectTileMode.cancelled) {
    //   return isBusy
    //       ? CustomLoading()
    //       : IconButton(
    //           onPressed: onDelete ?? () {},
    //           icon: Icon(
    //             Icons.delete,
    //             color: AppColors.red,
    //           ));
    // }
    if (mode == ClientProjectTileMode.setup ||
        mode == ClientProjectTileMode.waitingTasksApproval) {
      return StatusContainer(
          text: mode == ClientProjectTileMode.setup
              ? "بانتظار تحديد المهام"
              : "بانتظار الموافقة على المهام",
          bgColor: Colors.orange.withOpacity(.1),
          textColor: Colors.orange);
    }
    if (mode == ClientProjectTileMode.readyToComplete) {
      return StatusContainer(
          bgColor: AppColors.green.withOpacity(.1),
          text: "بانتظار انهاء المشروع",
          textColor: AppColors.green);
    }
    return null;
  }

  static ClientProjectTileMode modeFromStatus(String status) {
    switch (status) {
      case ProjectStatus.setup:
        return ClientProjectTileMode.setup;

      case ProjectStatus.waitingTasksApproval:
        return ClientProjectTileMode.waitingTasksApproval;

      case ProjectStatus.inProgress:
        return ClientProjectTileMode.inProgress;

      case ProjectStatus.readyToComplete:
        return ClientProjectTileMode.readyToComplete;

      case ProjectStatus.completed:
        return ClientProjectTileMode.completed;

      case ProjectStatus.cancelled:
        return ClientProjectTileMode.cancelled;

      default:
        return ClientProjectTileMode.newProject;
    }
  }
}
