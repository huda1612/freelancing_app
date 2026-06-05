import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';

class UserRatingAvg extends StatelessWidget {
  final double average;
  final List<double>? starsCount;
  final List<String> titles;
  final int total;

  const UserRatingAvg({
    super.key,
    required this.average,
    required this.starsCount,
    required this.titles,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //  Average
        Row(
          children: [
            Icon(Icons.star, color: Colors.amber, size: 28),
            const SizedBox(width: 6),
            Text(
              average.toStringAsFixed(1),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              "من $total تقييم",
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),

        SizedBox(height: 10.h),

        //  Breakdown (5 - 1)
        ...List.generate(5, (index) {
          return _ratingRow(
              title: titles[index],
              value: total != 0 ? (starsCount?[index] ?? 0) / total : 0);
        }),
      ],
    );
  }
}

Widget _ratingRow({
  required String title,
  required double value,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...List.generate(5, (i) {
          final starValue = (i + 1).toDouble();
          final selected = starValue <= value;

          return Icon(
            Icons.star,
            size: 22.w,
            color: selected ? Colors.amber : Colors.grey[300],
          );
        }),
        SizedBox(
          width: 10.w,
        ),
        Text(
          value.toString(),
          style: AppTextStyles.link.copyWith(color: Colors.amber),
        )
      ],
    ),
  );
}
