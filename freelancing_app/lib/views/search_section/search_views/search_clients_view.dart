import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/widgets/custom_app_bar.dart';
import 'package:freelancing_platform/core/widgets/custom_empty_data_text.dart';
import 'package:freelancing_platform/core/widgets/get_rerponse_handler.dart';
import 'package:freelancing_platform/core/widgets/search_field.dart';
import 'package:freelancing_platform/views/search_section/search_controllers/search_clients_controller.dart';
import 'package:freelancing_platform/views/search_section/search_widgets/user_profile_search_card.dart';
import 'package:get/get.dart';

class SearchClientsView extends StatelessWidget {
  SearchClientsView({super.key});

  final SearchClientsController controller = Get.find<SearchClientsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: 'ابحث عن عملاء',
        backgroundGradient: AppColors.gradientColor,
      ),
      body: Obx(
        () => UiStateHandler(
          status: controller.pageState.value,
          fetchDataFun: controller.fetchSuggestedClients,
          child: SafeArea(
            top: false,
            child: RefreshIndicator(
              onRefresh: controller.fetchSuggestedClients,
              color: AppColors.vividPurple,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(AppSpaces.paddingMedium),
                children: [
                  SearchField(
                    hint: 'ابحث عن عميل...',
                    onChanged: controller.onSearchChanged,
                  ),
                  SizedBox(height: AppSpaces.heightMedium),
                  Obx(() {
                    final result = controller.filteredUsers;
                    if (result.isEmpty) {
                      return customEmptyMessage(
                        message: 'لا يوجد عملاء مطابقين للبحث',
                      );
                    }

                    return Column(
                      children: result
                          .map(
                            (user) => UserProfileSearchCard(
                              title: '${user.fname} ${user.lname}'.trim().isEmpty
                                  ? user.username
                                  : '${user.fname} ${user.lname}'.trim(),
                              rating: user.overallRating,
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
