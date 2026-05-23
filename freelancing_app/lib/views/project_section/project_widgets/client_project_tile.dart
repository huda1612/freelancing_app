import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/project_status.dart';
import 'package:freelancing_platform/core/widgets/custom_button.dart';
import 'package:freelancing_platform/core/widgets/custom_loading.dart';
import 'package:freelancing_platform/models/project_collections/project_model.dart';
import 'package:freelancing_platform/views/project_section/project_widgets/project_card.dart';

enum ClientProjectTileMode {
  newProject,
  inProgress,
  delivered,
  completed,
  withdrawn,
}

class ClientProjectTile extends StatelessWidget {
  const ClientProjectTile({
    super.key,
    required this.project,
    required this.mode,
    this.isBusy = false,
    this.tasksDone,
    this.tasksTotal,
    this.onTap,
    this.onApproveCompletion,
    // this.onRepublish,
    this.onDelete,
  });

  final ProjectModel project;
  final ClientProjectTileMode mode;
  final bool isBusy;
  final int? tasksDone;
  final int? tasksTotal;
  final VoidCallback? onTap;
  final VoidCallback? onApproveCompletion;
  // final VoidCallback? onRepublish;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return ProjectCard(
      project: project,
      onTap: onTap,
      tasksDone: mode == ClientProjectTileMode.inProgress ? tasksDone : null,
      tasksTotal: mode == ClientProjectTileMode.inProgress ? tasksTotal : null,
      footer: _buildFooter(),
      header: _buildHeader(),
    );
  }

  Widget? _buildHeader() {
    if (mode == ClientProjectTileMode.withdrawn) {
      return isBusy
          ? CustomLoading()
          : IconButton(
              onPressed: onDelete ?? () {},
              icon: Icon(
                Icons.delete,
                color: AppColors.red,
              ));
    }
    return null;
  }

  Widget? _buildFooter() {
    if (mode == ClientProjectTileMode.delivered) {
      return CustomButton(
        text: 'الموافقة على إنهاء المشروع',
        height: 44,
        width: null,
        isLoading: isBusy,
        onTap: onApproveCompletion ?? () {},
        gradient: AppColors.gradientColor,
        textStyle: AppTextStyles.link.copyWith(
          color: AppColors.white,
          fontSize: 13.sp,
        ),
      );
    }

    // if (mode == ClientProjectTileMode.withdrawn) {
    //   // return isBusy
    //     ? CustomLoading()
    //     : Align(
    //         // alignment: Alignment.topRight,
    //         child: IconButton(
    //             onPressed: onDelete ?? () {},
    //             icon: Icon(
    //               Icons.delete,
    //               color: AppColors.red,
    //             )),
    //       );
    // return Expanded(
    //   child: CustomButton(
    //     text: 'حذف',
    //     height: 44,
    //     width: null,
    //     isLoading: isBusy,
    //     onTap: onDelete ?? () {},
    //     buttonType: ButtonType.outlined,
    //     color: Colors.red,
    //     textStyle: AppTextStyles.link.copyWith(
    //       color: Colors.red,
    //       fontSize: 12.sp,
    //     ),
    //   ),
    // );
    // }
    return null;
  }

  static ClientProjectTileMode modeFromStatus(String status) {
    switch (status) {
      case ProjectStatus.inProgress:
        return ClientProjectTileMode.inProgress;
      case ProjectStatus.delivered:
        return ClientProjectTileMode.delivered;
      case ProjectStatus.completed:
        return ClientProjectTileMode.completed;
      case ProjectStatus.cancelled:
        return ClientProjectTileMode.withdrawn;
      default:
        return ClientProjectTileMode.newProject;
    }
  }
}
