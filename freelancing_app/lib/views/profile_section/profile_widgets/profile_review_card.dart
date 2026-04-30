import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';

class ProfileReviewCard extends StatelessWidget {
  const ProfileReviewCard({
    super.key,
    required this.rating,
    required this.title,
  });

  final double rating;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 120,
        maxWidth: 190,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title.isEmpty ? 'عنوان التقييم' : title,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: Color(0xFF303042),
                height: 1.35,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, size: 16, color: Colors.amber),
                const SizedBox(width: 5),
                Text(
                  rating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
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
