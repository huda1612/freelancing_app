import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/project_status.dart';
import 'package:freelancing_platform/core/widgets/custom_app_bar.dart';
import 'package:freelancing_platform/core/widgets/custom_empty_data_text.dart';
import 'package:freelancing_platform/core/widgets/get_rerponse_handler.dart';
import 'package:freelancing_platform/models/project_collections/project_model.dart';
import 'package:freelancing_platform/core/services/navigation_service.dart';
import 'package:freelancing_platform/views/project_section/project_controller/client_project_controller.dart';
import 'package:freelancing_platform/views/project_section/project_widgets/client_project_tile.dart';
import 'package:get/get.dart';

class ClientProjectView extends StatelessWidget {
  final ClientProjectController controller =
      Get.find<ClientProjectController>();

  ClientProjectView({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: CustomAppBar(
          title: 'مشاريعي',
          backgroundGradient: AppColors.gradientColor,
          // leadingIcon: const Icon(Icons.arrow_back, color: AppColors.white),
          onLeadingPressed: NavigationService.back,

        ),
        body: Obx(
          () => UiStateHandler(
            status: controller.pageState.value,
            fetchDataFun: controller.loadProjects,
            child: Column(
              children: [
                _tabsBar(),
                Expanded(child: _buildProjectsList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _tabsBar() {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.grey,
              blurRadius: 2,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(8, 3, 8, 0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(ProjectStatus.clientTabLabels.length, (i) {
              return Padding(
                padding: EdgeInsets.only(left: i == 0 ? 0 : 6.w),
                child: _tabButton(
                  label: ProjectStatus.clientTabLabels[i],
                  selected: controller.activeTabIndex.value == i,
                  onTap: () => controller.setTabIndex(i),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _tabButton({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: const BoxDecoration(color: Colors.transparent),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12.sp,
                color: selected ? AppColors.vividPurple : AppColors.grey,
              ),
            ),
            const SizedBox(height: 7),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: 2.5,
              width: selected ? 48 : 0,
              decoration: BoxDecoration(
                color: AppColors.vividPurple,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectsList() {
    return Obx(() {
      final items = controller.projectsForActiveTab();
      if (items.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: customEmptyMessage(
              message: _emptyMessageForTab(controller.activeTabIndex.value),
            ),
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 24.h),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final ProjectModel project = items[index];
          final mode = ClientProjectTile.modeFromStatus(project.status);

          return GetBuilder<ClientProjectController>(
            builder: (c) => ClientProjectTile(
              project: project,
              mode: mode,
              isBusy: c.isBusy(project.id),
              onTap: () => _onProjectTap(c, project, mode),
              onApproveCompletion: mode == ClientProjectTileMode.delivered
                  ? () => c.approveProjectCompletion(project)
                  : null,
              onRepublish: mode == ClientProjectTileMode.withdrawn
                  ? () => c.republishProject(project)
                  : null,
              onDelete: mode == ClientProjectTileMode.withdrawn
                  ? () => c.confirmDeleteProject(project)
                  : null,
            ),
          );
        },
      );
    });
  }

  void _onProjectTap(
    ClientProjectController c,
    ProjectModel project,
    ClientProjectTileMode mode,
  ) {
    switch (mode) {
      case ClientProjectTileMode.newProject:
      case ClientProjectTileMode.completed:
        c.openProjectDetails(project);
        break;
      case ClientProjectTileMode.inProgress:
        c.openActiveProject(project);
        break;
      case ClientProjectTileMode.delivered:
        c.openActiveProject(project);
        break;
      case ClientProjectTileMode.withdrawn:
        break;
    }
  }

  String _emptyMessageForTab(int tab) {
    switch (tab) {
      case 0:
        return 'لا توجد مشاريع جديدة.';
      case 1:
        return 'لا توجد مشاريع قيد التقدم.';
      case 2:
        return 'لا توجد مشاريع مستلمة.';
      case 3:
        return 'لا توجد مشاريع مكتملة.';
      case 4:
        return 'لا توجد مشاريع مسحوبة.';
      default:
        return 'لا توجد بيانات.';
    }
  }
}
