import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/reuest_status.dart';

class RequestType extends StatelessWidget {
  final String requestStatus;

  const RequestType(
    this.requestStatus, {
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    const List<Color> colors = [
      AppColors.veryLightBlue,
      AppColors.lightGreen,
      AppColors.lightRed
    ];
    const List<Color> contentColors = [
      AppColors.blue,
      AppColors.green,
      AppColors.red
    ];
    const List<IconData> icons = [
      Icons.new_releases_rounded,
      Icons.check,
      Icons.close
    ];
    const List<String> text = ["New", "Approved", "Rejected"];
    int i = (requestStatus == RequestStatus.pending)
        ? 0
        : (requestStatus == RequestStatus.approved ? 1 : 2);

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: colors[i],
      ),
      child: Row(
        children: [
          Icon(
            icons[i],
            color: contentColors[i],
          ),
          Text(
            text[i],
            style: TextStyle(color: contentColors[i]),
          )
        ],
      ),
    );
  }
}
