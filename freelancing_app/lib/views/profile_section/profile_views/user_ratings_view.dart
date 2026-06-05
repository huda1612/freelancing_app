import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/classes/app_date_formatter.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';
import 'package:freelancing_platform/core/widgets/custom_app_bar.dart';
import 'package:freelancing_platform/core/widgets/custom_rating_widget.dart';
import 'package:freelancing_platform/core/widgets/get_rerponse_handler.dart';
import 'package:freelancing_platform/views/profile_section/profile_controllers/user_ratings_controller.dart';
import 'package:get/get.dart';

class UserRatingsView extends StatelessWidget {
  const UserRatingsView({super.key});

  @override
  Widget build(BuildContext context) {
    // final controller = Get.find<UserRatingsController>();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: CustomAppBar(
        title: 'التقييمات',
        backgroundGradient: AppColors.gradientColor,
      ),
      body: GetBuilder<UserRatingsController>(
          init: Get.find<UserRatingsController>(),
          builder: (controller) {
            return UiStateHandler(
              status: controller.pageState,
              fetchDataFun: controller.loadRatings,
              child: controller.ratings.isEmpty
                  ? _buildEmptyState()
                  : SingleChildScrollView(
                      padding: EdgeInsets.all(AppSpaces.paddingMedium),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "تقييمات ${controller.userFullName ?? "unKown"}",
                            style: AppTextStyles.heading
                                .copyWith(color: AppColors.darkPurple),
                          ),
                          SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 18),
                              SizedBox(width: 4),
                              Text(
                                controller.ratingAvg?.toStringAsFixed(1) ??
                                    "0.0",
                                style: AppTextStyles.blacksubheading
                                    .copyWith(color: AppColors.darkPurple),
                              ),
                              SizedBox(width: 10),
                              Text(
                                "(${controller.ratings.length} تقييم)",
                                style: AppTextStyles.body.copyWith(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          // SizedBox(height: 20),
                          Divider(height: 30),
                          _buildRatingsList(controller),
                        ],
                      ),
                    ),
            );
          }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.star_outline,
            size: 80.sp,
            color: AppColors.grey,
          ),
          SizedBox(height: AppSpaces.heightMedium),
          Text(
            'لا توجد تقييمات بعد',
            style: AppTextStyles.subheading.copyWith(
              color: AppColors.darkGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingsList(UserRatingsController controller) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.ratings.length,
      separatorBuilder: (context, index) => SizedBox(
        height: AppSpaces.heightMedium,
      ),
      itemBuilder: (context, index) {
        final rating = controller.ratings[index];
        return CustomRatingWidget(
          ratingModel: rating,
          projectName: rating.projectName,
          category: rating.category,
          projectStatus: rating.projectStatus,
          formattedDate: AppDateFormatter.smartTime(rating.createdAt),
        );
      },
    );
  }
}
