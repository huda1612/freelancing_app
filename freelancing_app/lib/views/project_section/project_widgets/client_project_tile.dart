import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/project_status.dart';
import 'package:freelancing_platform/core/widgets/custom_button.dart';
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
    this.onTap,
    this.onApproveCompletion,
    this.onRepublish,
    this.onDelete,
  });

  final ProjectModel project;
  final ClientProjectTileMode mode;
  final bool isBusy;
  final VoidCallback? onTap;
  final VoidCallback? onApproveCompletion;
  final VoidCallback? onRepublish;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ProjectCard(project: project),
          if (_showActions) ...[
            SizedBox(height: 8.h),
            _buildActions(),
          ],
        ],
      ),
    );
  }

  bool get _showActions =>
      mode == ClientProjectTileMode.delivered ||
      mode == ClientProjectTileMode.withdrawn;

  Widget _buildActions() {
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

    return Row(
      children: [
        Expanded(
          child: CustomButton(
            text: 'إعادة نشر',
            height: 44,
            width: null,
            isLoading: isBusy,
            onTap: onRepublish ?? () {},
            gradient: AppColors.gradientColor,
            textStyle: AppTextStyles.link.copyWith(
              color: AppColors.white,
              fontSize: 12.sp,
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: CustomButton(
            text: 'حذف',
            height: 44,
            width: null,
            isLoading: isBusy,
            onTap: onDelete ?? () {},
            buttonType: ButtonType.outlined,
            color: Colors.red,
            textStyle: AppTextStyles.link.copyWith(
              color: Colors.red,
              fontSize: 12.sp,
            ),
          ),
        ),
      ],
    );
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
