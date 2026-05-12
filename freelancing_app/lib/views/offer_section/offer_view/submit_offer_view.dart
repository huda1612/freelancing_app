import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';
import 'package:freelancing_platform/core/widgets/custom_app_bar.dart';
import 'package:freelancing_platform/core/widgets/custom_button.dart';
import 'package:freelancing_platform/core/widgets/custom_text_field.dart';
import 'package:freelancing_platform/views/offer_section/offer_controller/submit_offer_controller.dart';
import 'package:get/get.dart';

class SubmitOfferView extends StatelessWidget {
  SubmitOfferView({super.key});

  final SubmitOfferController controller = Get.find<SubmitOfferController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: 'تقديم عرض',
        backgroundGradient: AppColors.gradientColor,
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpaces.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionTitle(text: 'قيمة العرض'),
              CustomTextField(
                controller: controller.priceController,
                hintText: 'المبلغ',
                validator: (val) => controller.priceValidation(val),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                // prefixText: r'$ ',
              ),
              SizedBox(height: AppSpaces.heightMedium2),
              _SectionTitle(text: 'مدة التسليم'),
              CustomTextField(
                controller: controller.durationController,
                hintText: 'عدد الأيام',
                validator: (val) => controller.durationValidation(val),
                keyboardType: TextInputType.number,
                prefixIcon: Icon(
                  Icons.timer_outlined,
                  color: AppColors.vividPurple,
                  size: 22.w,
                ),
              ),
              SizedBox(height: AppSpaces.heightMedium2),
              _SectionTitle(text: 'تفاصيل العرض'),
              CustomTextField(
                controller: controller.detailsController,
                hintText: 'اكتب تفاصيل عرضك هنا...',
                validator: (val) => controller.descriptionValidation(val),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: AppSpaces.heightLarge1),
              Obx(
                () => CustomButton(
                  text: 'إرسال العرض ',
                  onTap: controller.submitOffer,
                  isLoading: controller.submitLoading,
                  gradient: AppColors.gradientColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        style: AppTextStyles.subheading.copyWith(
          color: AppColors.darkPurple,
        ),
      ),
    );
  }
}
