import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';

class UserProfileSearchCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final double rating;
  final VoidCallback onTap;

  const UserProfileSearchCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.rating,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSpaces.radiusMedium),
          boxShadow: const [
            BoxShadow(color: AppColors.grey, blurRadius: 4),
          ],
          border: Border.all(color: AppColors.veryLightGrey),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.veryLightPurple,
                  child: Icon(Icons.person, color: AppColors.vividPurple),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: AppTextStyles.link.copyWith(color: AppColors.darkGrey),
              ),
            ],
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 18),
                const SizedBox(width: 4),
                Text(
                  rating.toStringAsFixed(1),
                  style: AppTextStyles.link.copyWith(color: AppColors.darkGrey),
                ),
                const Spacer(),
                Text(
                  'عرض الملف الشخصي',
                  style: AppTextStyles.link.copyWith(
                    color: AppColors.vividPurple,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
