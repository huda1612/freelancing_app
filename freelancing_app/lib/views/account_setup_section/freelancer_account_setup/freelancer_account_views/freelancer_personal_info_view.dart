

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/utils/helper_function/validators.dart';
import 'package:freelancing_platform/core/widgets/base_screen.dart';
import 'package:freelancing_platform/core/widgets/custom_app_bar.dart';
import 'package:freelancing_platform/core/widgets/custom_text_field.dart';
import 'package:freelancing_platform/core/widgets/location_field.dart';
import 'package:freelancing_platform/core/widgets/gender_field.dart';
import 'package:freelancing_platform/core/widgets/birth_date_field.dart';
import 'package:freelancing_platform/views/account_setup_section/freelancer_account_setup/freelancer_account_controller/freelancer_personal_info_controller.dart';
import 'package:get/get.dart';



class FreelancerPersonalInfoView extends StatelessWidget {
  const FreelancerPersonalInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(FreelancerPersonalInfoController());

    return BaseScreen(
      appBar: CustomAppBar(
        leadingIcon: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: GetBuilder<FreelancerPersonalInfoController>(
        builder: (_) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: AppSpaces.screenHorizontalPadding.h,
                horizontal: AppSpaces.mediumVerticalSpacing.w,
              ),
              child: Form(
                key: c.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// الاسم الأول
                    CustomTextField(
                      controller: c.firstNameController,
                      hintText: "الاسم الأول",
                      validator: Validators.firstName,
                      onChanged: (v) => c.refreshForm(),
                    ),

                    SizedBox(height: AppSpaces.heightMedium),

                    /// الاسم الأخير
                    CustomTextField(
                      controller: c.lastNameController,
                      hintText: "الاسم الأخير",
                      validator: Validators.lastName,
                      onChanged: (v) => c.refreshForm(),
                    ),

                    SizedBox(height: AppSpaces.heightMedium),

                    /// الدولة
                    const CountryPickerField(),

                    SizedBox(height: AppSpaces.heightMedium),

                    /// الجنس
                    GenderField(
                      value: c.gender.value,
                      onChanged: (v) {
                        c.gender.value = v;
                        c.refreshForm();
                      },
                    ),

                    SizedBox(height: AppSpaces.heightMedium),

                    /// تاريخ الميلاد
                    BirthDateField(
                      year: c.year.value,
                      month: c.month.value,
                      day: c.day.value,
                      onYearChanged: (v) {
                        c.year.value = v;
                        c.refreshForm();
                      },
                      onMonthChanged: (v) {
                        c.month.value = v;
                        c.refreshForm();
                      },
                      onDayChanged: (v) {
                        c.day.value = v;
                        c.refreshForm();
                      },
                    ),

                    SizedBox(height: AppSpaces.heightMedium),

                    /// الموافقة على الشروط
                    Row(
                      children: [
                        Obx(() => Checkbox(
                              value: c.agreed.value,
                              onChanged: (v) {
                                c.agreed.value = v!;
                                c.refreshForm();
                              },
                            )),
                        const Expanded(
                          child: Text(
                            "أوافق على سياسة الخصوصية وشروط الخدمة",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: AppSpaces.heightLarge),

                    /// زر التالي
                    Align(
                      alignment: Alignment.centerRight,
                      child:GetBuilder<FreelancerPersonalInfoController>(
  builder: (_) => ElevatedButton(
    onPressed: c.isFormValid
        ? () {
            if (c.formKey.currentState!.validate()) {
              // الانتقال للصفحة التالية
            }
          }
        : null,
    child: const Text("التالي"),
  ),
)

                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
