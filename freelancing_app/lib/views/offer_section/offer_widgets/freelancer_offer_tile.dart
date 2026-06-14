import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/classes/app_date_formatter.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/offer_status.dart';
import 'package:freelancing_platform/models/project_collections/offer_model.dart';

/// بطاقة عرض الفريلانسر - تعرض معلومات العرض المقدم من الفريلانسر
class FreelancerOfferTile extends StatelessWidget {
  const FreelancerOfferTile({
    super.key,
    required this.offer,
    required this.onTap,
  });

  final OfferModel offer;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: AppColors.purple.withOpacity(0.1),
      highlightColor: Colors.transparent,
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        margin: EdgeInsets.only(bottom: 13.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 10.h),
            _buildPriceAndDuration(),
            SizedBox(height: 10.h),
            _buildProposalText(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: AppColors.purple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            Icons.work_outline,
            size: 18.sp,
            color: AppColors.purple,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                offer.projectTitle ?? 'مشروع غير معروف',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 3.h),
              Row(
                children: [
                  Text(
                    'عرض مقدم',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    '•',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    AppDateFormatter.smartTime(offer.createdAt),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        _buildStatusBadge(),
      ],
    );
  }

  Widget _buildPriceAndDuration() {
    return Row(
      children: [
        _miniInfo(Icons.attach_money, '${offer.price} \$'),
        SizedBox(width: 12.w),
        _miniInfo(Icons.timer_outlined, '${offer.durationDays} يوم'),
      ],
    );
  }

  Widget _miniInfo(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16.sp, color: AppColors.purple),
          SizedBox(width: 4.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProposalText() {
    return Text(
      offer.proposalText.isNotEmpty ? offer.proposalText : 'لا يوجد وصف للعرض.',
      style: AppTextStyles.body.copyWith(
        fontSize: 14.sp,
        color: Colors.grey.shade800,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildStatusBadge() {
    String label;
    Color badgeColor;
    Color textColor;
    switch (offer.status) {
      case OfferStatus.pending:
        label = 'معلق';
        badgeColor = Colors.orange.withOpacity(0.1);
        textColor = Colors.orange.shade700;
        break;
      case OfferStatus.accepted:
        label = 'مقبول';
        badgeColor = Colors.green.withOpacity(0.1);
        textColor = Colors.green.shade700;
        break;
      case OfferStatus.rejected:
        label = 'مرفوض';
        badgeColor = Colors.red.withOpacity(0.1);
        textColor = Colors.red.shade700;

        break;
      case OfferStatus.withdrawn:
        label = 'مسحوب';
        badgeColor = Colors.grey.withOpacity(0.1);
        textColor = Colors.grey.shade700;

        break;
      default:
        label = 'غير معروف';
        badgeColor = Colors.grey.withOpacity(0.1);
        textColor = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: AppTextStyles.link.copyWith(
          fontSize: 11.sp,
          color: textColor,
        ),
      ),
    );
  }

}
