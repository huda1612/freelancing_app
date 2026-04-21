import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';
import 'package:freelancing_platform/core/widgets/base_screen.dart';
import 'package:freelancing_platform/core/widgets/custom_button.dart';

class RejectedView extends StatelessWidget {
  const RejectedView({super.key});

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
                      EdgeInsets.symmetric(horizontal: AppSpaces.marginMedium),
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
                          Icons.close_rounded,
                          size: 50,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        " تم رفض طلبك ",
                        style: AppTextStyles.heading.copyWith(
                          // fontSize: 18,
                          color: AppColors.darkGrey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "يؤسفنا اخبارك بأنه قد تم رفض طلب الانضمام الى المنصة الذي قدمته مسبقا ",
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.darkGrey,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: AppSpaces.heightSmall,
                      ),
                      Text(
                        "سبب الرفض :",
                        style: AppTextStyles.body.copyWith(
                            color: AppColors.red, fontWeight: FontWeight.bold
                            // fontSize: 13,
                            ),
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        "تعليق الادمن هون",
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.darkGrey,
                          // fontSize: 13,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: AppSpaces.heightLarge,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CustomButton(
                            text: "حذف الحساب",
                            onTap: () {},
                            prefix: Icon(
                              Icons.delete,
                              color: AppColors.white,
                            ),
                            width: 150.w,
                          ),
                          CustomButton(
                            text: "اعادة تقديم الطلب",
                            onTap: () {},
                            prefix: Icon(
                              Icons.restore_page_rounded,
                              color: AppColors.white,
                            ),
                            width: 170.w,
                          )
                        ],
                      )
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
