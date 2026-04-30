import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/classes/app_date_formatter.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';
import 'package:freelancing_platform/core/widgets/custom_loading.dart';
import 'package:freelancing_platform/models/user_collections/worksamples_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/models/user_collections/certificate_model.dart';

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
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [AppColors.softPurple, AppColors.softBlue])
                  // AppColors.gradientColor
                  ),
              child: CachedNetworkImage(
                imageUrl: work.imageUrl,
                placeholder: (context, url) => const CustomLoading(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
              ),
              // child: const Icon(Icons.work_outline, color: Colors.white),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(work.title,
                    style: AppTextStyles.inputLabel
                        .copyWith(color: AppColors.black)),
                const SizedBox(height: 4),
                Text(
                  work.description,
                  style:
                      AppTextStyles.subheading.copyWith(color: AppColors.black),
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

class ProfileCertificateTile extends StatelessWidget {
  const ProfileCertificateTile({
    super.key,
    required this.certificate,
  });

  final CertificateModel certificate;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.owhite,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent),
        child: ExpansionTile(
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            tilePadding: const EdgeInsets.symmetric(
                horizontal: AppSpaces.smallHorizontalPadding,
                vertical: AppSpaces.smallVerticalSpacing),
            childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 52.w,
                height: 52.h,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [AppColors.softPurple, AppColors.softBlue])
                    // AppColors.gradientColor
                    ),
                // child: const Icon(Icons.workspace_premium, color: Colors.white),
                child: certificate.imageURL != null
                    ? CachedNetworkImage(
                        imageUrl: certificate.imageURL!,
                        placeholder: (context, url) => const CustomLoading(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        fit: BoxFit.cover,
                      )
                    : const Icon(Icons.workspace_premium, color: Colors.white),
              ),
            ),
            title: Text(
              certificate.title,
              style: AppTextStyles.inputLabel.copyWith(color: AppColors.black),
            ),
            subtitle: Text(
              certificate.source != null
                  ? "المصدر : ${certificate.source}"
                  : 'اضغط لعرض التفاصيل',
              style: AppTextStyles.link,
            ),
            children: [
              Align(
                  alignment: Alignment.centerRight,
                  child: _titleText("الوصف :")),
              Text(
                (certificate.description ?? '').isEmpty
                    ? 'لا يوجد تفاصيل متاحة.'
                    : certificate.description!,
                style:
                    AppTextStyles.subheading.copyWith(color: AppColors.black),
              ),
              _titleText("رقم التحقق :"),
              Text(
                (certificate.credentialID ?? '').isEmpty
                    ? 'لا يوجد رقم تحقق .'
                    : certificate.credentialID!,
                style:
                    AppTextStyles.subheading.copyWith(color: AppColors.black),
              ),
              _titleText("رابط التحقق :"),
              Text(
                (certificate.credentialURL ?? '').isEmpty
                    ? 'لا يوجد رابط تحقق .'
                    : certificate.credentialURL!,
                style:
                    AppTextStyles.subheading.copyWith(color: AppColors.black),
              ),
              _titleText("تاريخ الحصول :"),
              Text(
                (certificate.date == null)
                    ? 'لا يوجد رابط تحقق .'
                    : AppDateFormatter.ymd(certificate.date!),
                style:
                    AppTextStyles.subheading.copyWith(color: AppColors.black),
              ),
              _titleText("المهارات المرتبطة"),
              SkillsCards(
                skills: certificate.skills,
              ),
            ]),
      ),
    );
  }
}

Widget _titleText(String t) {
  return Text(
    t,
    style: AppTextStyles.subheading.copyWith(color: AppColors.darkPurple),
  );
}

//ويدجيت عرض المهارات
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
