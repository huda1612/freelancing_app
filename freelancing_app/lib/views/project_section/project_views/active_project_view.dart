import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/classes/user_session.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/user_roles.dart';
import 'package:freelancing_platform/core/widgets/custom_app_bar.dart';
import 'package:freelancing_platform/core/widgets/custom_button.dart';
import 'package:freelancing_platform/core/widgets/custom_error_widget.dart';
import 'package:freelancing_platform/views/project_section/project_controller/active_project_controller.dart';
import 'package:freelancing_platform/views/project_section/project_widgets/project_card.dart';
import 'package:get/get.dart';

class ActiveProjectView extends StatelessWidget {
  ActiveProjectView({super.key});

  final ActiveProjectController controller = Get.find<ActiveProjectController>();

  @override
  Widget build(BuildContext context) {
    final project = controller.project;
    if (project == null) {
      return const Scaffold(
        body: Center(child: CustomErrorWidget(message: "تعذر تحميل المشروع")),
      );
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: CustomAppBar(
          title: 'المشروع النشط',
          backgroundGradient: AppColors.gradientColor,
          leadingIcon: const Icon(Icons.arrow_back, color: AppColors.white),
          onLeadingPressed: () => Get.back(),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpaces.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProjectCard(project: project),
              SizedBox(height: 16.h),
              _sectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'وصف المشروع',
                      style: AppTextStyles.subheading.copyWith(
                        color: AppColors.purple,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      project.description,
                      style: AppTextStyles.body.copyWith(height: 1.6),
                    ),
                  ],
                ),
              ),
              if (UserSession.role == UserRole.client) ...[
                SizedBox(height: AppSpaces.heightMedium),
                CustomButton(
                  text: 'عرض العروض والتفاصيل',
                  onTap: controller.openOffers,
                  prefix:
                      const Icon(Icons.content_paste, color: AppColors.white),
                  gradient: AppColors.gradientColor,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpaces.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
