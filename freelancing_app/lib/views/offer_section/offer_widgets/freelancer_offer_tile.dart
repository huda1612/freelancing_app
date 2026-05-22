import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
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
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.symmetric(
          horizontal: AppSpaces.smallHorizontalPadding.w,
          vertical: AppSpaces.smallVerticalSpacing.h,
        ),
        decoration: BoxDecoration(
          color: AppColors.owhite,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.vividPurple.withOpacity(0.32),
            width: 0.85.w,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 8.h),
            _buildPriceAndDuration(),
            SizedBox(height: 8.h),
            _buildProposalText(),
            SizedBox(height: 8.h),
            _buildStatusBadge(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(Icons.description_outlined,
            size: 20.sp, color: AppColors.purple),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            'عرض على المشروع #${offer.projectId}',
            style: AppTextStyles.inputLabel.copyWith(
              color: AppColors.black,
              fontSize: 14.sp,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        _buildStatusIcon(),
      ],
    );
  }

  Widget _buildStatusIcon() {
    IconData icon;
    Color color;

    switch (offer.status) {
      case OfferStatus.pending:
        icon = Icons.pending_outlined;
        color = Colors.orange;
        break;
      case OfferStatus.accepted:
        icon = Icons.check_circle_outline;
        color = Colors.green;
        break;
      case OfferStatus.rejected:
        icon = Icons.cancel_outlined;
        color = Colors.red;
        break;
      case OfferStatus.withdrawn:
        icon = Icons.delete_outline;
        color = Colors.grey;
        break;
      default:
        icon = Icons.help_outline;
        color = Colors.grey;
    }

    return Icon(icon, size: 20.sp, color: color);
  }

  Widget _buildPriceAndDuration() {
    return Row(
      children: [
        Icon(Icons.attach_money, size: 16.sp, color: AppColors.purple),
        SizedBox(width: 4.w),
        Text(
          '${offer.price.toString()} \$',
          style: AppTextStyles.body.copyWith(
            color: AppColors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: 16.w),
        Icon(Icons.timer_outlined, size: 16.sp, color: AppColors.purple),
        SizedBox(width: 4.w),
        Text(
          '${offer.durationDays} يوم',
          style: AppTextStyles.body.copyWith(color: AppColors.black),
        ),
      ],
    );
  }

  Widget _buildProposalText() {
    return Text(
      offer.proposalText.isNotEmpty
          ? offer.proposalText
          : 'لا يوجد وصف للعرض.',
      style: AppTextStyles.body.copyWith(
        color: AppColors.black,
        fontSize: 13.sp,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildStatusBadge() {
    String label;
    Color badgeColor;

    switch (offer.status) {
      case OfferStatus.pending:
        label = 'معلقة';
        badgeColor = Colors.orange.withOpacity(0.1);
        break;
      case OfferStatus.accepted:
        label = 'مقبولة';
        badgeColor = Colors.green.withOpacity(0.1);
        break;
      case OfferStatus.rejected:
        label = 'مرفوضة';
        badgeColor = Colors.red.withOpacity(0.1);
        break;
      case OfferStatus.withdrawn:
        label = 'مسحوبة';
        badgeColor = Colors.grey.withOpacity(0.1);
        break;
      default:
        label = 'غير معروف';
        badgeColor = Colors.grey.withOpacity(0.1);
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
          color: _getStatusTextColor(offer.status),
        ),
      ),
    );
  }

  Color _getStatusTextColor(String status) {
    switch (status) {
      case OfferStatus.pending:
        return Colors.orange.shade700;
      case OfferStatus.accepted:
        return Colors.green.shade700;
      case OfferStatus.rejected:
        return Colors.red.shade700;
      case OfferStatus.withdrawn:
        return Colors.grey.shade700;
      default:
        return Colors.grey;
    }
  }
}
