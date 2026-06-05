import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/project_status.dart';
import 'package:freelancing_platform/views/project_section/project_widgets/project_section_card.dart';

class ProjectSummarySection extends StatelessWidget {
  final String status;
  final double progress;
  final int tasksCount;
  final int completedTasksCount;
  final int extraTasksCount;
  final int completedExtraTasksCount;
  final double totalAmount;
  final double paidAmount;
  final String? cancelReason;

  final Widget partnerMiniProfile;
  final Widget deadlineWidget;

  final VoidCallback onRatingTap;
  final bool showRating;
  final bool isRated;
  final bool ratingIsLoading;

  const ProjectSummarySection({
    super.key,
    required this.status,
    required this.progress,
    required this.tasksCount,
    required this.completedTasksCount,
    required this.extraTasksCount,
    required this.completedExtraTasksCount,
    required this.totalAmount,
    required this.paidAmount,
    this.cancelReason,
    required this.deadlineWidget,
    required this.onRatingTap,
    required this.isRated,
    required this.showRating,
    this.ratingIsLoading = false,
    required this.partnerMiniProfile,
  });

  @override
  Widget build(BuildContext context) {
    return ProjectSectionCard(
        child: ExpansionTile(
      shape: const Border(), //  يشيل الخط العلوي
      collapsedShape: const Border(), //  يشيل الخط السفلي

      initiallyExpanded: true,

      title: Text(
        "لوحة تقدم المشروع",
        style: AppTextStyles.subheading.copyWith(color: AppColors.darkPurple),
      ),
      leading: Icon(
        Icons.dashboard_outlined,
        color: AppColors.darkPurple,
      ),
      children: [
        partnerMiniProfile,
        SizedBox(height: 14.h),
        Align(alignment: Alignment.topRight, child: _projectStatusCard()),
        if (status == ProjectStatus.cancelled &&
            cancelReason != null &&
            cancelReason!.trim().isNotEmpty) ...[
          SizedBox(height: 4.h),
          Align(
            alignment: Alignment.topRight,
            child: Text(
              "سبب الإلغاء : $cancelReason",
              style: AppTextStyles.link.copyWith(color: AppColors.red),
            ),
          )
        ],
        SizedBox(height: 14.h),
        _progressCard(),
        SizedBox(height: 14.h),
        _miniStatsGrid(),
        SizedBox(height: 14.h),
        _moneySection(),
        SizedBox(height: 12.h),
        deadlineWidget,
        if (showRating) ...[
          SizedBox(height: 12.h),
          _ratingSection(),
        ],
      ],
    ));
  }

// ---------------- STATUS ----------------
  Widget _projectStatusCard() {
    Map<String, Map<String, dynamic>> projectStatusMeta = {
      ProjectStatus.newProject: {
        "label": "مشروع جديد",
        "icon": Icons.fiber_new,
        "color": Colors.blue,
      },
      ProjectStatus.setup: {
        "label": "قيد الإعداد",
        "icon": Icons.settings_outlined,
        "color": Colors.orange,
      },
      ProjectStatus.waitingTasksApproval: {
        "label": "بانتظار اعتماد المهام",
        "icon": Icons.hourglass_bottom,
        "color": Colors.amber,
      },
      ProjectStatus.inProgress: {
        "label": "قيد التنفيذ",
        "icon": Icons.play_circle_outline,
        "color": Colors.green,
      },
      ProjectStatus.readyToComplete: {
        "label": "جاهز للإغلاق",
        "icon": Icons.verified_outlined,
        "color": Colors.orange,
      },
      ProjectStatus.completed: {
        "label": "مكتمل",
        "icon": Icons.check_circle_outline,
        "color": Colors.teal,
      },
      ProjectStatus.cancelled: {
        "label": "غير مكتمل",
        "icon": Icons.cancel_outlined,
        "color": Colors.red,
      },
    };
    final meta = projectStatusMeta[status];
    //  ??
    //     {
    //       "label": status,
    //       "icon": Icons.info_outline,
    //       "color": AppColors.purple,
    //     };

    return meta != null
        ? Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: (meta["color"] as Color).withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  meta["icon"],
                  size: 16.sp,
                  color: meta["color"],
                ),
                SizedBox(width: 6.w),
                Text(
                  meta["label"],
                  style: TextStyle(
                    color: meta["color"],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          )
        : SizedBox.shrink();
  }

  // ---------------- STATUS ----------------
  // Widget _pillStatus() {
  //   Map<String, Map<String, dynamic>> projectStatusMeta = {
  //     ProjectStatus.newProject: {
  //       "label": "مشروع جديد",
  //       "icon": Icons.fiber_new,
  //       "color": Colors.blue,
  //     },
  //     ProjectStatus.setup: {
  //       "label": "قيد الإعداد",
  //       "icon": Icons.settings_outlined,
  //       "color": Colors.orange,
  //     },
  //     ProjectStatus.waitingTasksApproval: {
  //       "label": "بانتظار اعتماد المهام",
  //       "icon": Icons.hourglass_bottom,
  //       "color": Colors.amber,
  //     },
  //     ProjectStatus.inProgress: {
  //       "label": "قيد التنفيذ",
  //       "icon": Icons.play_circle_outline,
  //       "color": Colors.green,
  //     },
  //     ProjectStatus.readyToComplete: {
  //       "label": "جاهز للإغلاق",
  //       "icon": Icons.verified_outlined,
  //       "color": Colors.purple,
  //     },
  //     ProjectStatus.completed: {
  //       "label": "مكتمل",
  //       "icon": Icons.check_circle_outline,
  //       "color": Colors.teal,
  //     },
  //     ProjectStatus.cancelled: {
  //       "label": "ملغي",
  //       "icon": Icons.cancel_outlined,
  //       "color": Colors.red,
  //     },
  //   };
  //   final meta = projectStatusMeta[status] ??
  //       {
  //         "label": status,
  //         "icon": Icons.info_outline,
  //         "color": AppColors.purple,
  //       };

  //   return Container(
  //     padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
  //     decoration: BoxDecoration(
  //       color: (meta["color"] as Color).withOpacity(0.12),
  //       borderRadius: BorderRadius.circular(20),
  //     ),
  //     child: Row(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Icon(
  //           meta["icon"],
  //           size: 16.sp,
  //           color: meta["color"],
  //         ),
  //         SizedBox(width: 6.w),
  //         Text(
  //           meta["label"],
  //           style: TextStyle(
  //             color: meta["color"],
  //             fontWeight: FontWeight.w600,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _pillStatus() {
  //   return Container(
  //     padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
  //     decoration: BoxDecoration(
  //       color: AppColors.purple.withOpacity(0.1),
  //       borderRadius: BorderRadius.circular(20),
  //     ),
  //     child: Row(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Icon(Icons.flag_outlined, size: 16.sp, color: AppColors.purple),
  //         SizedBox(width: 6.w),
  //         Text(
  //           status,
  //           style: TextStyle(
  //             color: AppColors.purple,
  //             fontWeight: FontWeight.w600,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // ---------------- PROGRESS ----------------
  Widget _progressCard() {
    final percent = (progress * 100).toStringAsFixed(0);

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        // color: Colors.grey.shade50,
        color: AppColors.lightPurple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.show_chart, size: 18.sp, color: AppColors.darkPurple),
              SizedBox(width: 6.w),
              Text("نسبة الإنجاز"),
              Spacer(),
              Text(
                "$percent%",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.purple,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              color: AppColors.purple,
              backgroundColor: Colors.grey.shade200,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- TASKS GRID ----------------
  Widget _miniStatsGrid() {
    return Row(
      children: [
        Expanded(
          child: _miniStatCard(
            icon: Icons.task_alt,
            title: "أساسية",
            value: "$completedTasksCount/$tasksCount",
          ),
        ),
        if (extraTasksCount > 0) ...[
          SizedBox(width: 8.w),
          Expanded(
            child: _miniStatCard(
              icon: Icons.add_task,
              title: "إضافية",
              value: "$completedExtraTasksCount/$extraTasksCount",
            ),
          ),
        ],
      ],
    );
  }

  Widget _miniStatCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: AppColors.lightPurple.withOpacity(0.1),

        // color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18.sp, color: AppColors.darkPurple),
              SizedBox(width: 6.h),
              Text(
                title,
                style: TextStyle(color: AppColors.darkPurple),
              ),
            ],
          ),
          // SizedBox(height: 6.h),
          // Text(title),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // ---------------- MONEY ----------------
  Widget _moneySection() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        children: [
          _moneyRow(Icons.attach_money, "الإجمالي", "$totalAmount\$"),
          SizedBox(height: 6.h),
          _moneyRow(Icons.payments, "المدفوع", "$paidAmount\$"),
        ],
      ),
    );
  }

  Widget _moneyRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, size: 18.sp, color: Colors.green),
        SizedBox(width: 6.w),
        Text(title),
        Spacer(),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // ---------------- RATING ----------------
  Widget _ratingSection() {
    return InkWell(
      onTap: ratingIsLoading ? null : onRatingTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          children: [
            Icon(
              isRated ? Icons.star : Icons.star_border,
              color: ratingIsLoading ? AppColors.grey : AppColors.purple,
            ),
            SizedBox(width: 8.w),
            Text(
              ratingIsLoading
                  ? (!isRated
                      ? "جار ارسال التقييم ..."
                      : "جار تحميل التقييم ...")
                  : (isRated ? "تم تقييم الطرف الآخر" : "قيّم الطرف الآخر"),
              style: TextStyle(
                color:
                    isRated || ratingIsLoading ? Colors.grey : AppColors.purple,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
