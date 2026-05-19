import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/project_status.dart';
import 'package:freelancing_platform/core/widgets/custom_app_bar.dart';
import 'package:freelancing_platform/core/widgets/custom_button.dart';
import 'package:freelancing_platform/core/widgets/custom_error_widget.dart';
import 'package:freelancing_platform/core/widgets/get_rerponse_handler.dart';
import 'package:freelancing_platform/models/project_collections/project_model.dart';
import 'package:freelancing_platform/views/project_section/project_controller/active_project_controller.dart';
import 'package:freelancing_platform/views/project_section/project_widgets/project_partner_header.dart';
import 'package:freelancing_platform/views/project_section/project_widgets/project_section_card.dart';
import 'package:freelancing_platform/views/project_section/project_widgets/project_task_row.dart';
import 'package:get/get.dart';

const Color _softPurple = Color(0xffA99CFF);

class ActiveProjectView extends GetView<ActiveProjectController> {
  const ActiveProjectView({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: CustomAppBar(
          title: 'المشروع النشط',
          backgroundGradient: AppColors.gradientColor,
          leadingIcon: const Icon(Icons.arrow_back, color: AppColors.white),
          onLeadingPressed: controller.goBack,
        ),
        body: Obx(() {
          final project = controller.project;
          if (project == null) {
            return const Center(
              child: CustomErrorWidget(message: 'تعذر تحميل المشروع'),
            );
          }

          return UiStateHandler(
            status: controller.pageState.value,
            fetchDataFun: controller.loadTasks,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppSpaces.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => ProjectPartnerHeader(
                      displayName: controller.partnerName.value.isNotEmpty
                          ? controller.partnerName.value
                          : '—',
                      isLoading: controller.partnerLoading.value,
                      onViewProfile: controller.openPartnerProfile,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ..._projectInfoSections(project),
                  SizedBox(height: 8.h),
                  _tasksSection(),
                  SizedBox(height: 16.h),
                  _actionButtons(),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  List<Widget> _projectInfoSections(ProjectModel project) {
    return [
      ProjectSectionCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProjectSectionTitle('عنوان المشروع'),
            SizedBox(height: AppSpaces.heightSmall),
            Text(
              project.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      ProjectSectionCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProjectSectionTitle('وصف المشروع'),
            SizedBox(height: AppSpaces.heightSmall),
            Text(
              project.description,
              style: const TextStyle(height: 1.7, fontSize: 15),
            ),
          ],
        ),
      ),
      ProjectSectionCard(
        child: ProjectInfoRow(
          icon: Icons.attach_money,
          title: 'الميزانية',
          value: project.budget.toStringAsFixed(0),
        ),
      ),
      ProjectSectionCard(
        child: ProjectInfoRow(
          icon: Icons.timer,
          title: 'مدة التنفيذ',
          value: '${project.durationDays} يوم',
        ),
      ),
      ProjectSectionCard(
        child: ProjectInfoRow(
          icon: Icons.work,
          title: 'التصنيف',
          value: project.category.name,
        ),
      ),
      if (project.skillsRequired.isNotEmpty)
        ProjectSectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ProjectSectionTitle('المهارات المطلوبة'),
              SizedBox(height: AppSpaces.heightSmall),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: project.skillsRequired
                    .map(
                      (skill) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: _softPurple.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          skill,
                          style: const TextStyle(
                            color: AppColors.purple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
    ];
  }

  Widget _tasksSection() {
    return ProjectSectionCard(
      marginBottom: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: ProjectSectionTitle('قائمة المهام'),
              ),
              if (controller.canEditTasks)
                IconButton(
                  onPressed: controller.addTask,
                  icon: const Icon(Icons.add_circle, color: AppColors.vividPurple),
                  tooltip: 'إضافة مهمة',
                ),
            ],
          ),
          SizedBox(height: 8.h),
          Obx(() {
            if (controller.tasks.isEmpty) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Text(
                  controller.canEditTasks
                      ? 'اضغط + لإضافة أول مهمة'
                      : 'لا توجد مهام بعد',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              );
            }

            return Column(
              children: controller.tasks.map((task) {
                return ProjectTaskRow(
                  task: task,
                  controller: controller.taskController(task.id),
                  canEdit: controller.canEditTasks,
                  onDescriptionChanged: (v) =>
                      controller.updateTaskDescription(task.id, v),
                  onDoneChanged: (v) => controller.toggleTaskDone(task.id, v),
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _actionButtons() {
    return Obx(() {
      final _ = controller.actionLoading.value;
      if (controller.canDeliverProject) {
        return CustomButton(
          text: 'إنهاء المشروع',
          onTap: controller.deliverProject,
          isLoading: controller.actionLoading.value,
          gradient: AppColors.gradientColor,
          prefix: const Icon(Icons.check_circle_outline, color: AppColors.white),
        );
      }

      if (controller.canApproveCompletion) {
        return CustomButton(
          text: 'الموافقة على إنهاء المشروع',
          onTap: controller.approveProjectCompletion,
          isLoading: controller.actionLoading.value,
          gradient: AppColors.gradientColor,
        );
      }

      final status = controller.project?.status;
      if (status == ProjectStatus.delivered && controller.isFreelancer) {
        return Text(
          'تم التسليم — بانتظار موافقة العميل',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.vividPurple,
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
          ),
        );
      }

      return const SizedBox.shrink();
    });
  }
}
