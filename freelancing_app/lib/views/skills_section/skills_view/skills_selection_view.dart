import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/widgets/base_screen.dart';
import 'package:freelancing_platform/core/widgets/custom_app_bar.dart';
import 'package:freelancing_platform/core/widgets/get_rerponse_handler.dart';
import 'package:freelancing_platform/views/skills_section/skills_controller/skills_selection_controller.dart';
import 'package:freelancing_platform/views/skills_section/skills_widgets/bottom_skills_bar.dart';
import 'package:freelancing_platform/views/skills_section/skills_widgets/skill_selector.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';

class SkillsSelectionView extends StatelessWidget {
  SkillsSelectionView({super.key});
  final SkillsSelectionController controller =
      Get.find<SkillsSelectionController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return BaseScreen(
        appBar: CustomAppBar(
          title: "المهارات",
        ),
        body: UiStateHandler(
          fetchDataFun: controller.fetchPageData,
          status: controller.pageState.value,
          child: Padding(
            padding: EdgeInsets.all(AppSpaces.paddingSmall),
            child: Column(
              children: [
                Expanded(
                  child: SkillsSelector(
                    selectedSkills: controller.selectedSkills.toList(),
                    sugustSubSpecials: controller.sugustSubSpecials.toList(),
                    filteredSubSkills: controller.filteredSubSkills.toList(),
                    searchQuery: controller.searchQuery.value,
                    onSearchChanged: controller.onSearchChanged,
                    onToggleSelectSubSkill: controller.toggleSelectSkill,
                    onToggleSkill: controller.toggleSubspecial,
                    onToggleSubSkill: controller.toggleSkill,
                  ),
                ),
                BottomSkillsBar(
                  selectedSkills: controller.selectedSkills.toList(),
                  toggleSelectSkill: controller.toggleSelectSkill,
                  onButtonPress: controller.onEnd,
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
