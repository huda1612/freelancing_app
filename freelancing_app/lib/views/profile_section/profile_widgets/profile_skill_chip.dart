import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';

class ProfileSkillChip extends StatelessWidget {
  const ProfileSkillChip({super.key, required this.skill});

  final String skill;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.lightPurple),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        skill,
        style: const TextStyle(
          color: Color(0xFF303042),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
