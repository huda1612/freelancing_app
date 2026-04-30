import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/classes/app_date_formatter.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';
import 'package:freelancing_platform/core/widgets/custom_loading.dart';
import 'package:freelancing_platform/models/user_collections/certificate_model.dart';
import 'package:freelancing_platform/views/profile_section/profile_widgets/certificate_skill_card.dart';
import 'package:freelancing_platform/views/profile_section/profile_widgets/title_text.dart';

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
                  child: titleText("الوصف :")),
              Text(
                (certificate.description ?? '').isEmpty
                    ? 'لا يوجد تفاصيل متاحة.'
                    : certificate.description!,
                style:
                    AppTextStyles.body.copyWith(color: AppColors.black),
              ),
              titleText("رقم التحقق :"),
              Text(
                (certificate.credentialID ?? '').isEmpty
                    ? 'لا يوجد رقم تحقق .'
                    : certificate.credentialID!,
                style:
                    AppTextStyles.body.copyWith(color: AppColors.black),
              ),
              titleText("رابط التحقق :"),
              Text(
                (certificate.credentialURL ?? '').isEmpty
                    ? 'لا يوجد رابط تحقق .'
                    : certificate.credentialURL!,
                style:
                    AppTextStyles.body.copyWith(color: AppColors.black),
              ),
              titleText("تاريخ الحصول :"),
              Text(
                (certificate.date == null)
                    ? 'لا يوجد رابط تحقق .'
                    : AppDateFormatter.ymd(certificate.date!),
                style:
                    AppTextStyles.body.copyWith(color: AppColors.black),
              ),
              titleText("المهارات المرتبطة"),
              SkillsCards(
                skills: certificate.skills,
              ),
            ]),
      ),
    );
  }
}