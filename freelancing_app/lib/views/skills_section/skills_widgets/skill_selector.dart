import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';
import 'package:freelancing_platform/core/widgets/search_field.dart';
import 'package:freelancing_platform/models/skill_collections/new_skill_model.dart';
import 'package:freelancing_platform/views/skills_section/skills_widgets/skill_tile.dart';
import 'package:freelancing_platform/views/skills_section/skills_widgets/sub_skill_result_item.dart';

class SkillsSelector extends StatelessWidget {
  final List<String> selectedSkills;
  final List sugustSubSpecials;
  final List<String> filteredSubSkills;
  final String searchQuery;

  final Function(String) onSearchChanged;
  final Function(String) onToggleSelectSubSkill;
  final Function(int, String) onToggleSubSkill;
  final Function(int) onToggleSkill;

  const SkillsSelector({
    super.key,
    required this.selectedSkills,
    required this.sugustSubSpecials,
    required this.filteredSubSkills,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onToggleSelectSubSkill,
    required this.onToggleSubSkill,
    required this.onToggleSkill,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchField(
          hint: "ابحث عن مهارة...",
          onChanged: onSearchChanged,
        ),
        SizedBox(height: 12.h),
        searchQuery.isEmpty
            ? Align(
                alignment: Alignment.topRight,
                child: Text(
                  "المهارات المقترحة :",
                  style: AppTextStyles.subheading,
                ))
            : const SizedBox.shrink(),
        Expanded(
          child: searchQuery.isNotEmpty
              ? ListView(
                  children: filteredSubSkills.map((sub) {
                    return SubSkillResultItem(
                      title: sub,
                      isSelected: selectedSkills.contains(sub),
                      onTap: () => onToggleSelectSubSkill(sub),
                    );
                  }).toList(),
                )
              : ListView.builder(
                  itemCount: sugustSubSpecials.length,
                  itemBuilder: (context, index) {
                    final SubspecialModel item = sugustSubSpecials[index];

                    return SkillTile(
                      title: item.name,
                      subSkills: item.skills,
                      isExpanded: item.expanded.value,
                      selectedSubSkills: item.selectedSubSkills,
                      onToggle: () => onToggleSkill(index),
                      onSubSkillToggle: (sub) => onToggleSubSkill(index, sub),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
