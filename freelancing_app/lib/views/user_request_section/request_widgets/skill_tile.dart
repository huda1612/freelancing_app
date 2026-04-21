import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';

class SkillTile extends StatelessWidget {
  final String title;
  final List<String> subSkills;
  final bool isExpanded;
  final VoidCallback onToggle;

  /// المهارات الفرعية المختارة
  final List<String> selectedSubSkills;

  /// عند اختيار مهارة فرعية
  final Function(String) onSubSkillToggle;

  const SkillTile({
    super.key,
    required this.title,
    required this.subSkills,
    required this.isExpanded,
    required this.onToggle,
    required this.selectedSubSkills,
    required this.onSubSkillToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppSpaces.smallVerticalSpacing),
      decoration: BoxDecoration(
        color: AppColors.owhite,
        borderRadius: BorderRadius.circular(AppSpaces.radiusMedium),
        border: Border.all(color: AppColors.owhite),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(title),
            trailing: IconButton(
              icon: Icon(
                isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
              ),
              onPressed: onToggle,
            ),
          ),

          if (isExpanded)
            Padding(
              padding: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: subSkills.map((s) {
                  final bool isSelected = selectedSubSkills.contains(s);

                  return GestureDetector(
                    onTap: () => onSubSkillToggle(s),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpaces.mediumHorizontalPadding,
                        vertical: AppSpaces.smallVerticalSpacing,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.lightPink
                              : AppColors.veryLightGrey,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.lightPink
                              : AppColors.veryLightGrey,
                        ),
                      ),
                      child: Text(
                        s,
                        style: TextStyle(
                          fontSize: 14,
                          color: isSelected ? AppColors.white : AppColors.blue ,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            )
        ],
      ),
    );
  }
}
