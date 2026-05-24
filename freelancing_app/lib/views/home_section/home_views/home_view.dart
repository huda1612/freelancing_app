import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';
import 'package:freelancing_platform/core/widgets/custom_app_bar.dart';
import 'package:freelancing_platform/core/widgets/get_rerponse_handler.dart';
import 'package:freelancing_platform/models/project_collections/project_model.dart';
import 'package:freelancing_platform/models/user_collections/user_model.dart';
import 'package:freelancing_platform/views/home_section/home_controller/home_controller.dart';
import 'package:freelancing_platform/views/home_section/home_widgets/home_freelancer_card.dart';
import 'package:freelancing_platform/views/home_section/home_widgets/home_project_card.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.veryLightGrey,
      appBar: CustomAppBar(
        title: ' الصفحة الرئيسية ',
        backgroundGradient: AppColors.gradientColor,
        trailingIcon: Obx(() => Stack(
              children: [
                const Icon(Icons.notifications_outlined,
                    color: AppColors.white),
                if (controller.hasUnreadNotifications.value)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: AppColors.vividPurple,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            )),
        onTrailingPressed: controller.openNotifications,
      ),
      body: Obx(
        () => UiStateHandler(
          status: controller.pageState.value,
          fetchDataFun: controller.fetchHomeData,
          child: SafeArea(
            top: false,
            child: RefreshIndicator(
              onRefresh: controller.fetchHomeData,
              color: AppColors.vividPurple,
              child: ListView(
                padding: EdgeInsets.all(AppSpaces.paddingMedium),
                children: [
                  _buildWelcomeSection(),
                  SizedBox(height: AppSpaces.heightLarge),
                  if (controller.isFreelancer) ...[
                    _buildSuggestedProjectsSection(),
                    SizedBox(height: AppSpaces.heightLarge),
                    _buildNewProjectsSection(),
                  ] else if (controller.isClient) ...[
                    _buildFeaturedFreelancersSection(),
                    SizedBox(height: AppSpaces.heightLarge),
                    _buildNewFreelancersSection(),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'مرحباً، ${controller.welcomeMessage} 👋',
          style: AppTextStyles.heading.copyWith(
            color: AppColors.darkPurple,
            fontSize: 24.sp,
          ),
        ),
        SizedBox(height: AppSpaces.heightSmall),
        Text(
          controller.isFreelancer
              ? 'إليك المشاريع المقترحة لك'
              : 'اكتشف أفضل المستقلين لمشاريعك',
          style: AppTextStyles.body.copyWith(
            color: AppColors.darkGrey,
            fontSize: 16.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestedProjectsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'مشاريع مقترحة لك',
          style: AppTextStyles.blacksubheading.copyWith(
            color: AppColors.darkPurple,
            fontSize: 20.sp,
          ),
        ),
        SizedBox(height: AppSpaces.heightMedium),
        _buildProjectsGrid(controller.suggestedProjects,
            showAcceptanceRate: true),
      ],
    );
  }

  Widget _buildNewProjectsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'مشاريع جديدة في تخصصك',
          style: AppTextStyles.blacksubheading.copyWith(
            color: AppColors.darkPurple,
            fontSize: 20.sp,
          ),
        ),
        SizedBox(height: AppSpaces.heightMedium),
        _buildProjectsGrid(controller.newProjects, showAcceptanceRate: false),
      ],
    );
  }

  Widget _buildProjectsGrid(RxList<ProjectModel> projects,
      {required bool showAcceptanceRate}) {
    if (projects.isEmpty) {
      return const Center(
        child: Text(
          'لا توجد مشاريع حالياً',
          style: TextStyle(color: AppColors.darkGrey),
        ),
      );
    }

    // تقسيم إلى صفين
    final firstRow = projects.take(5).toList();
    final secondRow = projects.skip(5).take(5).toList();

    return Column(
      children: [
        _buildProjectRow(firstRow, showAcceptanceRate),
        if (secondRow.isNotEmpty) SizedBox(height: AppSpaces.heightMedium),
        if (secondRow.isNotEmpty)
          _buildProjectRow(secondRow, showAcceptanceRate),
      ],
    );
  }

  Widget _buildProjectRow(
      List<ProjectModel> rowProjects, bool showAcceptanceRate) {
    return SizedBox(
      height: 180.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: rowProjects.length,
        separatorBuilder: (_, __) => SizedBox(width: AppSpaces.width),
        itemBuilder: (context, index) {
          final project = rowProjects[index];
          return SizedBox(
            width: 280.w,
            child: HomeProjectCard(
              project: project,
              showAcceptanceRate: showAcceptanceRate,
              onTap: () => controller.openProjectDetails(project),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeaturedFreelancersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'فريلانسر مميزين',
          style: AppTextStyles.blacksubheading.copyWith(
            color: AppColors.darkPurple,
            fontSize: 20.sp,
          ),
        ),
        SizedBox(height: AppSpaces.heightMedium),
        _buildFreelancersList(controller.featuredFreelancers, showStats: true),
      ],
    );
  }

  Widget _buildNewFreelancersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'فريلانسر جدد',
          style: AppTextStyles.blacksubheading.copyWith(
            color: AppColors.darkPurple,
            fontSize: 20.sp,
          ),
        ),
        SizedBox(height: AppSpaces.heightMedium),
        _buildFreelancersList(controller.newFreelancers, showStats: false),
      ],
    );
  }

  Widget _buildFreelancersList(RxList<UserModel> freelancers,
      {required bool showStats}) {
    if (freelancers.isEmpty) {
      return const Center(
        child: Text(
          'لا يوجد فريلانسر حالياً',
          style: TextStyle(color: AppColors.darkGrey),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: freelancers.length,
      separatorBuilder: (_, __) => SizedBox(height: AppSpaces.heightSmall),
      itemBuilder: (context, index) {
        final freelancer = freelancers[index];
        return HomeFreelancerCard(
          freelancer: freelancer,
          showStats: showStats,
          onTap: () => controller.openFreelancerProfile(freelancer),
        );
      },
    );
  }
}
