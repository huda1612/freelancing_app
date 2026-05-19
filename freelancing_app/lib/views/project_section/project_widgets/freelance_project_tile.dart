import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/project_status.dart';
import 'package:freelancing_platform/models/project_collections/project_model.dart';
import 'package:freelancing_platform/views/project_section/project_widgets/project_card.dart';

enum FreelancerProjectTileMode {
  inProgress,
  delivered,
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
      tasksDone: mode == FreelancerProjectTileMode.inProgress ? tasksDone : null,
      tasksTotal:
          mode == FreelancerProjectTileMode.inProgress ? tasksTotal : null,
    );
  }

  static FreelancerProjectTileMode modeFromStatus(String status) {
    switch (status) {
      case ProjectStatus.inProgress:
        return FreelancerProjectTileMode.inProgress;
      case ProjectStatus.delivered:
        return FreelancerProjectTileMode.delivered;
      case ProjectStatus.completed:
        return FreelancerProjectTileMode.completed;
      case ProjectStatus.cancelled:
        return FreelancerProjectTileMode.withdrawn;
      default:
        return FreelancerProjectTileMode.inProgress;
    }
  }
}
