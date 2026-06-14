import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/project_status.dart';
import 'package:freelancing_platform/core/widgets/custom_app_bar.dart';
import 'package:freelancing_platform/core/widgets/custom_refreshable_empty_message.dart';
import 'package:freelancing_platform/core/widgets/get_rerponse_handler.dart';
import 'package:freelancing_platform/models/project_collections/project_model.dart';
import 'package:freelancing_platform/views/project_section/project_controller/client_project_controller.dart';
import 'package:freelancing_platform/views/project_section/project_widgets/client_project_tile.dart';
import 'package:freelancing_platform/core/widgets/list_tab_bar.dart';
import 'package:get/get.dart';

//ok
class ClientProjectView extends StatelessWidget {
  final ClientProjectController controller =
      Get.find<ClientProjectController>();

  ClientProjectView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: 'مشاريعي',
        backgroundGradient: AppColors.gradientColor,
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
    );
  }

  Widget _tabsBar() {
    return Obx(() {
      final selectedIndex =
          controller.activeTabIndex.value; //حتى تتغير بالواجهة بالObx
      return ListTabBar(
        tabsLength: ProjectStatus.clientTabLabels.length,
        getLabel: (i) => ProjectStatus.clientTabLabels[i],
        isSelected: (i) => selectedIndex == i,
        onLabelTab: (i) => controller.setTabIndex(i),
      );
    });
  }

  Widget _buildProjectsList() {
    return Obx(() {
      final items = controller.projectsForActiveTab();
      // empty message
      if (items.isEmpty) {
        return CustomRefreshableEmptyMessage(
            onRefresh: controller.loadProjects,
            emptyMessage: _emptyMessageForTab(controller.activeTabIndex.value));
      }

      // project list
      return RefreshIndicator(
        color: AppColors.vividPurple,
        onRefresh: controller.loadProjects,
        child: ListView.builder(
          padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 24.h),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final ProjectModel project = items[index];
            final mode = ClientProjectTile.modeFromStatus(project.status);

            return ClientProjectTile(
              project: project,
              mode: mode,
              onTap: () => _onProjectTap(controller, project, mode),
              tasksDone: project.completedTasksCount,
              tasksTotal: project.tasksCount,
            );
          },
        ),
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
        c.openProjectDetails(project);
        break;
      case ClientProjectTileMode.setup:
      case ClientProjectTileMode.waitingTasksApproval:
      case ClientProjectTileMode.inProgress:
      case ClientProjectTileMode.readyToComplete:
      case ClientProjectTileMode.completed:
      case ClientProjectTileMode.cancelled:
        c.openActiveProject(project);
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
        return 'لا توجد مشاريع مكتملة.';
      case 3:
        return 'لا توجد مشاريع غير مكتملة.';
      default:
        return 'لا توجد بيانات.';
    }
  }
}
