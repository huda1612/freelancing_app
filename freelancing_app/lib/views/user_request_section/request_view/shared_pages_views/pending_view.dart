import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';
import 'package:freelancing_platform/core/widgets/base_screen.dart';

class PendingView extends StatelessWidget {
  const PendingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: AppSpaces.marginSmall),
                  padding: EdgeInsets.all(AppSpaces.paddingMedium),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.black,
                          blurRadius: AppSpaces.radiusSmall),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.veryLightGrey,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_circle,
                          size: 50,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "طلبك قيد المراجعة",
                        style: AppTextStyles.heading.copyWith(
                          fontSize: 18,
                          color: AppColors.darkGrey,
                        ),
                        // textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "تم إرسال طلبك بنجاح، سيتم مراجعته خلال 24 ساعة.\nسيتم إشعارك عند قبول حسابك.",
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.darkGrey,
                          fontSize: 13,
                        ),
                        // textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
