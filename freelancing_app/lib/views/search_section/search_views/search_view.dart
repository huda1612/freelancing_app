import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/widgets/custom_app_bar.dart';
import 'package:freelancing_platform/views/search_section/search_controllers/search_controller.dart';
import 'package:freelancing_platform/views/search_section/search_widgets/search_option_card.dart';
import 'package:get/get.dart';

class SearchView extends StatelessWidget {
  final controller = Get.put(SearchPageController());

  SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "البحث",
        backgroundGradient: AppColors.gradientColor,
      ),
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // // Search bar
            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            //   decoration: BoxDecoration(
            //     color: Colors.grey.shade100,
            //     borderRadius: BorderRadius.circular(12),
            //   ),
            //   child: const Row(
            //     children: [
            //       Icon(Icons.search, color: Colors.grey),
            //       SizedBox(width: 10),
            //       Expanded(
            //         child: TextField(
            //           decoration: InputDecoration.collapsed(hintText: "ابحث..."),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

            SizedBox(height: AppSpaces.heightMedium),

            // Options
            Obx(() => Column(
                  children: controller.options
                      .map(
                        (opt) => SearchOptionCard(
                          title: opt.title,
                          icon: opt.icon,
                          onTap: () => controller.navigateTo(opt.route),
                        ),
                      )
                      .toList(),
                )),
          ],
        ),
      ),
    );
  }
}
