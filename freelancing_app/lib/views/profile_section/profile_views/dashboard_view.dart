import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';
import 'package:freelancing_platform/core/widgets/custom_app_bar.dart';
import 'package:freelancing_platform/views/profile_section/profile_controllers/dashboard_controller.dart';
import 'package:get/get.dart';

class DashboardView extends StatelessWidget {
  DashboardView({super.key});

  final DashboardController controller = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: CustomAppBar(
          title: 'لوحة التحكم',
          backgroundGradient: AppColors.gradientColor,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpaces.paddingMedium),
          child: Column(
            children: [
              /// قسم الإحصائيات
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppSpaces.radiusMedium),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.oblack,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    /// الإحصائيات
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
                      child: Row(
                        children: [
                          Icon(Icons.bar_chart_rounded,
                              color: AppColors.purple, size: 22),
                          const SizedBox(width: 8),
                          Text(
                            'الإحصائيات',
                            style: AppTextStyles.blacksubheading.copyWith(
                              color: AppColors.darkPurple,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// المحتوى
                    Obx(
                      () => Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _statCard(
                                    title: 'التقييم',
                                    value: controller.ratingText,
                                    icon: Icons.star_rounded,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _statCard(
                                    title: 'مكتملة',
                                    value: controller.completedProjectsText,
                                    icon: Icons.check_circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _statCard(
                                    title: 'النقاط',
                                    value: controller.totalPointsText,
                                    icon: Icons.workspace_premium,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: _wideCard(
                                    title: 'مشاريع نشطة',
                                    value: controller.activeProjectsText,
                                    icon: Icons.work_outline_rounded,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _wideCard(
                                    title: 'الأرباح',
                                    value: controller.expectedEarningsText,
                                    icon: Icons.attach_money_rounded,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: _wideCard(
                                    title: 'أقرب تسليم',
                                    value: controller.nearestDeliveryText,
                                    icon: Icons.timer,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _wideCard(
                                    title: 'أبعد تسليم',
                                    value: controller.farthestDeliveryText,
                                    icon: Icons.calendar_month,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppSpaces.heightLarge),
            ],
          ),
        ),
      ),
    );
  }

  /// الكروت الداخلية
  BoxDecoration get _cardDecoration => BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        // ignore: deprecated_member_use
        border: Border.all(color: AppColors.darkGrey.withOpacity(0.12)),
      );

  /// كرت صغير
  Widget _statCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 7),
      decoration: _cardDecoration,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.link.copyWith(
              color: AppColors.darkGrey,
              fontWeight: FontWeight.w600,
              fontSize: 10,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: AppColors.purple, size: 17),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.meduimstyle.copyWith(
                    color: AppColors.purple,
                    fontSize: 13,
                    height: 1.15,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// كرت عريض
  Widget _wideCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      decoration: _cardDecoration,
      child: Row(
        children: [
          Icon(icon, color: AppColors.purple, size: 18),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.link.copyWith(
                    color: AppColors.darkGrey,
                    fontWeight: FontWeight.w500,
                    fontSize: 10,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.meduimstyle.copyWith(
                    color: AppColors.purple,
                    fontSize: 12,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
