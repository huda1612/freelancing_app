import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/project_status.dart';
import 'package:freelancing_platform/models/project_collections/project_model.dart';
import 'package:freelancing_platform/views/project_section/project_widgets/project_card.dart';
import 'package:freelancing_platform/views/project_section/project_widgets/status_container.dart';

enum FreelancerProjectTileMode {
  setup,
  waitingTasksApproval,
  inProgress,
  readyToComplete,
  // delivered,
  completed,
  withdrawn,
}

class FreelancerProjectTile extends StatelessWidget {
  const FreelancerProjectTile({
    super.key,
    required this.project,
    required this.mode,
    this.tasksDone,
    this.tasksTotal,
    this.onTap,
  });

  final ProjectModel project;
  final FreelancerProjectTileMode mode;
  final int? tasksDone;
  final int? tasksTotal;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ProjectCard(
      project: project,
      onTap: onTap,
      tasksDone: mode == FreelancerProjectTileMode.inProgress ||
              mode == FreelancerProjectTileMode.readyToComplete
          ? tasksDone
          : null,
      tasksTotal: mode == FreelancerProjectTileMode.inProgress ||
              mode == FreelancerProjectTileMode.readyToComplete
          ? tasksTotal
          : null,
      header: _buildHeader(),
      // header: mode == FreelancerProjectTileMode.setup ||
      //         mode == FreelancerProjectTileMode.waitingTasksApproval
      //     ? Text(
      //         mode == FreelancerProjectTileMode.setup
      //             ? "بانتظار تحديد المهام"
      //             : "بانتظار الموافقة على المهام",
      //         style: AppTextStyles.link.copyWith(color: AppColors.red))
      //     : null,
    );
  }

  Widget? _buildHeader() {
    if (mode == FreelancerProjectTileMode.setup ||
        mode == FreelancerProjectTileMode.waitingTasksApproval) {
      return StatusContainer(
        bgColor: Colors.orange.withOpacity(.1),
        textColor: Colors.orange,
        text: mode == FreelancerProjectTileMode.setup
            ? "بانتظار تحديد المهام"
            : "بانتظار الموافقة على المهام",
      );
    }
    if (mode == FreelancerProjectTileMode.readyToComplete) {
      return StatusContainer(
          bgColor: AppColors.green.withOpacity(.1),
          text: "بانتظار انهاء المشروع",
          textColor: AppColors.green);
    }
    return null;
  }

  static FreelancerProjectTileMode modeFromStatus(String status) {
    switch (status) {
      case ProjectStatus.setup:
        return FreelancerProjectTileMode.setup;
      case ProjectStatus.waitingTasksApproval:
        return FreelancerProjectTileMode.waitingTasksApproval;
      case ProjectStatus.inProgress:
        return FreelancerProjectTileMode.inProgress;
      // case ProjectStatus.delivered:
      //   return FreelancerProjectTileMode.delivered;
      case ProjectStatus.readyToComplete:
        return FreelancerProjectTileMode.readyToComplete;
      case ProjectStatus.completed:
        return FreelancerProjectTileMode.completed;
      case ProjectStatus.cancelled:
        return FreelancerProjectTileMode.withdrawn;
      default:
        return FreelancerProjectTileMode.inProgress;
    }
  }
}
