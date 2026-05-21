import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/widgets/custom_app_bar.dart';
import 'package:freelancing_platform/core/widgets/custom_empty_data_text.dart';
import 'package:freelancing_platform/core/widgets/get_rerponse_handler.dart';
import 'package:freelancing_platform/core/widgets/search_field.dart';
import 'package:freelancing_platform/views/search_section/search_controllers/search_freelancers_controller.dart';
import 'package:freelancing_platform/views/search_section/search_widgets/user_profile_search_card.dart';
import 'package:get/get.dart';

class SearchFreelancersView extends StatelessWidget {
  SearchFreelancersView({super.key});

  final SearchFreelancersController controller =
      Get.find<SearchFreelancersController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: 'ابحث عن مستقلين',
        backgroundGradient: AppColors.gradientColor,
      ),
      body: Obx(
        () => UiStateHandler(
          status: controller.pageState.value,
          fetchDataFun: controller.fetchSuggestedFreelancers,
          child: SafeArea(
            top: false,
            child: RefreshIndicator(
              onRefresh: controller.fetchSuggestedFreelancers,
              color: AppColors.vividPurple,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(AppSpaces.paddingMedium),
                children: [
                  SearchField(
                    hint: 'ابحث عن مستقل...',
                    onChanged: controller.onSearchChanged,
                  ),
                  SizedBox(height: AppSpaces.heightMedium),
                  Obx(() {
                    final result = controller.filteredUsers;
                    if (result.isEmpty) {
                      return customEmptyMessage(
                        message: 'لا يوجد مستقلين مطابقين للبحث',
                      );
                    }

                    return Column(
                      children: result
                          .map(
                            (user) => UserProfileSearchCard(
                              title: '${user.fname} ${user.lname}'.trim().isEmpty
                                  ? user.username
                                  : '${user.fname} ${user.lname}'.trim(),
                              subtitle: user.specialization?.name.isNotEmpty == true
                                  ? user.specialization?.name
                                  : (user.jobTitle.isNotEmpty
                                      ? user.jobTitle
                                      : 'اختصاص غير محدد'),
                              rating: user.rating,
                              onTap: () => controller.openProfile(user),
                            ),
                          )
                          .toList(),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
