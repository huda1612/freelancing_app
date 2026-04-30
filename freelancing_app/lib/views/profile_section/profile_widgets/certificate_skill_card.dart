import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';

class SkillsCards extends StatelessWidget {
  final List<String> skills;
  final TextStyle? emptyHintTextStyle;
  const SkillsCards({super.key, required this.skills, this.emptyHintTextStyle});

  @override
  Widget build(BuildContext context) {
    return skills.isNotEmpty
        ? Wrap(
            spacing: 8,
            children: skills
                .map((e) => Chip(
                    label: Text(e), backgroundColor: AppColors.lightPurple))
                .toList(),
          )
        : Center(
            child: Text(
              "لا يوجد مهارات",
              style: emptyHintTextStyle ??
                  AppTextStyles.blacksubheading.copyWith(color: AppColors.grey),
            ),
          );
  }
}
