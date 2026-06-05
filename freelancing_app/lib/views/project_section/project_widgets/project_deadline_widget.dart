import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';

class ProjectDeadlineWidget extends StatelessWidget {
  final int totalDays;
  final DateTime acceptedAt;

  const ProjectDeadlineWidget({
    super.key,
    required this.totalDays,
    required this.acceptedAt,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    // الأيام التي مرّت من قبول العرض
    final passedDays = now.difference(acceptedAt).inDays;

    // الأيام المتبقية
    final daysLeft = totalDays - passedDays;

    // نسبة التقدم
    double progress = passedDays / totalDays;
    if (progress < 0) progress = 0;

    // النص واللون
    String statusText;
    Color statusColor;

    if (progress < 0.5) {
      // بداية المشروع
      statusText = "باقي $daysLeft يوم للتسليم";
      // statusColor = AppColors.lightPurple;
      statusColor = AppColors.purple;
    } else if (progress < 1) {
      // بعد نص المدة
      statusText = "باقي $daysLeft يوم للتسليم";
      statusColor = const Color.fromARGB(255, 253, 176, 23);
    } else {
      // انتهت المدة
      final lateDays = passedDays - totalDays;
      statusText = "المشروع متأخر بـ $lateDays يوم";
      statusColor = AppColors.red;
    }

    return
        // Container(
        //   width: double.infinity,
        // padding: const EdgeInsets.all(16),
        // decoration: BoxDecoration(
        //   color: statusColor,
        //   borderRadius: BorderRadius.circular(AppSpaces.radiusLarge),
        //   boxShadow: [
        //     BoxShadow(
        //       color: Colors.black.withOpacity(0.06),
        //       blurRadius: 10,
        //       offset: const Offset(0, 4),
        //     ),
        //   ],
        // ),
        // child:
        Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.timer_outlined,
          color: statusColor,
        ),
        SizedBox(width: AppSpaces.heightSmall),
        Text(
          statusText,
          style: AppTextStyles.body.copyWith(
            color: statusColor, // مهم جداً
          ),
        ),
      ],
      // ),
    );
  }
}
