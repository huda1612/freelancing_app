import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/services/navigation_service.dart';
import 'package:freelancing_platform/core/widgets/custom_app_bar.dart';
import 'package:freelancing_platform/core/widgets/custom_empty_data_text.dart';
import 'package:freelancing_platform/core/widgets/get_rerponse_handler.dart';
import 'package:freelancing_platform/core/widgets/search_field.dart';
import 'package:freelancing_platform/views/project_section/project_controller/browse_projects_controller.dart';
import 'package:freelancing_platform/views/project_section/project_widgets/project_card.dart';
import 'package:get/get.dart';

class BrowseProjectsView extends StatelessWidget {
  BrowseProjectsView({super.key});

  final BrowseProjectsController controller =
      Get.find<BrowseProjectsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: 'تصفح المشاريع',
        backgroundGradient: AppColors.gradientColor,
        trailingIcon: const Icon(
          Icons.filter_alt_outlined,
          color: AppColors.white,
        ),
        onTrailingPressed: () => _showSpecializationFilter(context),
      ),
      body: Obx(() {
        return UiStateHandler(
          status: controller.pageState.value,
          fetchDataFun: controller.fetchOpenProjectAndSpec,
          child: SafeArea(
            top: false,
            child: Obx(() {
              if (controller.projects.isEmpty) {
                return customEmptyMessage(
                    message: 'لا توجد مشاريع مفتوحة حالياً');
              }
              final filteredProjects = controller.filteredProjects;

              return RefreshIndicator(
                onRefresh: controller.fetchOpenProjectAndSpec,
                color: AppColors.vividPurple,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(AppSpaces.paddingMedium),
                  children: [
                    SearchField(
                      hint: 'ابحث عن مشروع...',
                      onChanged: controller.onSearchChanged,
                    ),
                    SizedBox(height: AppSpaces.heightMedium),
                    if (filteredProjects.isEmpty)
                      customEmptyMessage(
                        message: 'لا توجد نتائج مطابقة للبحث أو الفلترة',
                      )
                    else
                      ...filteredProjects.map(
                        (project) => GestureDetector(
                            onTap: () {
                              print(
                                  "currentTab = ${NavigationService.currentTab}");
                              print("args = ${{"project": project}}");
                              NavigationService.toNamed(
                                  AppRoutes.projectDetails,
                                  arguments: {"project": project});
                            },
                            child: ProjectCard(project: project)),
                      ),
                  ],
                ),
              );
            }),
          ),
        );
      }),
    );
  }

  //هالتابع لاظهار خيارات الفلتره حسب الاختصاص
  void _showSpecializationFilter(BuildContext context) {
    final options = controller.allSpecializations;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) {
        if (options.isEmpty) {
          return SizedBox(
            height: 140,
            child: Center(
              child:
                  customEmptyMessage(message: 'لا توجد اختصاصات متاحة حالياً'),
            ),
          );
        }
        return Obx(
          () => ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(AppSpaces.paddingMedium),
            children: [
              ListTile(
                title: const Text(
                  'كل الاختصاصات',
                  textDirection: TextDirection.rtl,
                ),
                leading: Radio<String?>(
                  value: null,
                  groupValue: controller.selectedSpecialization.value,
                  onChanged: controller.selectSpecializationFilter,
                ),
                onTap: () => controller.selectSpecializationFilter(null),
              ),
              ...options.map(
                (spec) => ListTile(
                  title: Text(
                    spec.name,
                    textDirection: TextDirection.rtl,
                  ),
                  leading: Radio<String?>(
                    value: spec.slug,
                    groupValue: controller.selectedSpecialization.value,
                    onChanged: controller.selectSpecializationFilter,
                  ),
                  onTap: () => controller.selectSpecializationFilter(spec.slug),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
