import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/project_status.dart';
import 'package:freelancing_platform/core/widgets/custom_app_bar.dart';
import 'package:freelancing_platform/core/widgets/custom_refreshable_empty_message.dart';
import 'package:freelancing_platform/core/widgets/get_rerponse_handler.dart';
import 'package:freelancing_platform/models/project_collections/project_model.dart';
import 'package:freelancing_platform/core/services/navigation_service.dart';
import 'package:freelancing_platform/views/project_section/project_controller/freelance_project_controller.dart'
    show FreelancerProjectController;
import 'package:freelancing_platform/views/project_section/project_widgets/freelance_project_tile.dart';
import 'package:get/get.dart';

class FreelancerProjectView extends StatelessWidget {
  final FreelancerProjectController controller =
      Get.find<FreelancerProjectController>();

  FreelancerProjectView({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: CustomAppBar(
          title: 'مشاريعي',
          backgroundGradient: AppColors.gradientColor,
          leadingIcon: const Icon(Icons.arrow_back, color: AppColors.white),
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
            children:
                List.generate(ProjectStatus.freelancerTabLabels.length, (i) {
              return Padding(
                padding: EdgeInsets.only(left: i == 0 ? 0 : 6.w),
                child: _tabButton(
                  label: ProjectStatus.freelancerTabLabels[i],
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
        return CustomRefreshableEmptyMessage(
            onRefresh: controller.loadProjects,
            emptyMessage: _emptyMessageForTab(controller.activeTabIndex.value));
      }

      return RefreshIndicator(
        onRefresh: controller.loadProjects,
        child: ListView.builder(
          padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 24.h),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final ProjectModel project = items[index];
            final mode = FreelancerProjectTile.modeFromStatus(project.status);

            return FreelancerProjectTile(
              project: project,
              mode: mode,
              tasksDone: project.completedTasksCount,
              tasksTotal: project.tasksCount,
              onTap:
                  //يمكن لو شلتهم كلهم بعدين احسن لان رح يصير خلص كله عالactive عند الفريلانسر !!!
                  mode == FreelancerProjectTileMode.inProgress ||
                          mode == FreelancerProjectTileMode.setup ||
                          mode ==
                              FreelancerProjectTileMode.waitingTasksApproval ||
                          mode == FreelancerProjectTileMode.readyToComplete
                      ? () => controller.openActiveProject(project)
                      : null,
            );
          },
        ),
      );
    });
  }

  String _emptyMessageForTab(int tab) {
    switch (tab) {
      case 0:
        return 'لا توجد مشاريع قيد التقدم.';
      case 1:
        return 'لا توجد مشاريع تم تسليمها.';
      case 2:
        return 'لا توجد مشاريع مكتملة.';
      case 3:
        return 'لا توجد مشاريع مسحوبة.';
      default:
        return 'لا توجد بيانات.';
    }
  }
}
