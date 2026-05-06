import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';
import 'package:freelancing_platform/core/widgets/custom_loading.dart';
import 'package:freelancing_platform/models/user_collections/worksamples_model.dart';

class ProfileWorkCard extends StatelessWidget {
  const ProfileWorkCard({
    super.key,
    required this.work,
  });

  final WorksampleModel work;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.owhite,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
                width: 66.w,
                height: 66.h,
                decoration: BoxDecoration(gradient: AppColors.gradientColor),
                child: work.imageUrl != null && work.imageUrl!.trim().isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: work.imageUrl!,
                        placeholder: (context, url) => const CustomLoading(),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.image_not_supported_rounded,
                          color: AppColors.white,
                        ),
                        fit: BoxFit.cover,
                      )
                    : Icon(
                        Icons.no_photography_rounded,
                        color: AppColors.white,
                      )),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(work.title,
                    style: AppTextStyles.inputLabel
                        .copyWith(color: AppColors.vividPurple)),
                SizedBox(height: 4.w),
                Text(
                  work.description,
                  style: AppTextStyles.button.copyWith(color: AppColors.black),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
