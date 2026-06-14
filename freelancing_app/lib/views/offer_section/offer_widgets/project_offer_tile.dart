import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/offer_status.dart';
import 'package:freelancing_platform/core/widgets/custom_button.dart';
import 'package:freelancing_platform/core/widgets/custom_loading.dart';
import 'package:freelancing_platform/models/project_collections/offer_model.dart';

/// بطاقة عرض قابلة للتوسّع (ExpansionTile + زوايا دائرية).
class ProjectOfferTile extends StatelessWidget {
  const ProjectOfferTile({
    super.key,
    required this.offer,
    required this.isProjectOwner,
    required this.isBusy,
    required this.onProfileTap,
    this.onAccept,
    this.onReject,
    this.onDelete,
  });

  final OfferModel offer;
  final bool isProjectOwner;

  /// طلب شبكة على هذا العرض (قبول / رفض / سحب)
  final bool isBusy;

  final VoidCallback onProfileTap;

  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  final VoidCallback? onDelete;

  // bool get _isOfferOwner =>
  //     UserSession.uid != null && UserSession.uid == offer.freelancerId;

  bool get _showClientDecision =>
      isProjectOwner &&
      offer.status == OfferStatus.pending &&
      onAccept != null &&
      onReject != null;

  // bool get _showFreelancerActions =>
  //     _isOfferOwner &&
  //     offer.status == OfferStatus.pending &&
  //     (onWithdraw != null || onEdit != null);

  bool get _showDeleteButton =>
      isProjectOwner &&
      offer.status == OfferStatus.withdrawn &&
      onDelete != null;


  @override
  Widget build(BuildContext context) {
    final snap = offer.freelancerSnapshot;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.owhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.vividPurple.withOpacity(0.32),
          width: 0.85.w,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(
            horizontal: AppSpaces.smallHorizontalPadding,
            vertical: AppSpaces.smallVerticalSpacing,
          ),
          childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          leading: _LeadingAvatar(name: snap.fullName),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snap.fullName.isNotEmpty ? snap.fullName : snap.username,
                      style: AppTextStyles.inputLabel.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      snap.jobTitle.isNotEmpty
                          ? snap.jobTitle
                          : snap.specialization,
                      style: AppTextStyles.link,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Column(
                children: [
                  Icon(Icons.star_rounded,
                      color: Colors.amber.shade700, size: 18.sp),
                  Text(
                    snap.rating.toStringAsFixed(1),
                    style: AppTextStyles.link.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkPurple,
                    ),
                  ),
                ],
              ),
            ],
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.timer_outlined,
                        size: 16.sp, color: AppColors.purple),
                    SizedBox(width: 6.w),
                    Text(
                      '${offer.durationDays} يوم',
                      style:
                          AppTextStyles.body.copyWith(color: AppColors.black),
                    ),
                    SizedBox(width: 16.w),
                    Icon(Icons.attach_money,
                        size: 16.sp, color: AppColors.purple),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        offer.price.toString(),
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  offer.proposalText,
                  style: AppTextStyles.body.copyWith(color: AppColors.black),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: isBusy ? null : onProfileTap,
                child: Text(
                  'عرض البروفايل',
                  style: AppTextStyles.link,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Text(
                offer.proposalText.isNotEmpty
                    ? offer.proposalText
                    : 'لا يوجد وصف للعرض.',
                style: AppTextStyles.body.copyWith(color: AppColors.black),
              ),
            ),
            SizedBox(height: 12.h),
            if (isBusy)
              CustomLoading()
            else if (_showClientDecision) ...[
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'موافقة',
                      width: null,
                      onTap: onAccept!,
                      gradient: AppColors.gradientColor,
                      textStyle:
                          AppTextStyles.button.copyWith(color: AppColors.white),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: CustomButton(
                      text: 'رفض',
                      width: null,
                      onTap: onReject!,
                      color: AppColors.owhite,
                      textStyle:
                          AppTextStyles.link.copyWith(color: AppColors.red),
                    ),
                  ),
                ],
              ),
            ]
            // else if (_showFreelancerActions) ...[
            //   Row(
            //     mainAxisAlignment: MainAxisAlignment.end,
            //     children: [
            //       if (onWithdraw != null)
            //         IconButton(
            //           tooltip: 'سحب العرض',
            //           onPressed: onWithdraw,
            //           icon: Icon(Icons.delete, color: AppColors.darkPurple),
            //         ),
            //       if (onEdit != null)
            //         IconButton(
            //           tooltip: 'تعديل العرض',
            //           onPressed: onEdit,
            //           icon: Icon(Icons.edit_rounded, color: AppColors.purple),
            //         ),
            //     ],
            //   ),
            // ]
            else if (_showDeleteButton) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    tooltip: 'حذف العرض',
                    onPressed: onDelete,
                    icon: Icon(Icons.delete_forever, color: AppColors.red),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LeadingAvatar extends StatelessWidget {
  const _LeadingAvatar({required this.name});

  final String name;

  String get _initial {
    final t = name.trim();
    if (t.isEmpty) return '?';
    return t.substring(0, 1);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 52.w,
        height: 52.h,
        decoration: BoxDecoration(gradient: AppColors.gradientColor),
        alignment: Alignment.center,
        child: Text(
          _initial,
          style: AppTextStyles.button.copyWith(
            color: AppColors.white,
            fontSize: 20.sp,
          ),
        ),
      ),
    );
  }
}
