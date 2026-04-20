import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';
import 'package:freelancing_platform/core/utils/helper_function/validators.dart';
import 'package:freelancing_platform/core/widgets/base_screen.dart';
import 'package:freelancing_platform/core/widgets/custom_app_bar.dart';
import 'package:freelancing_platform/core/widgets/custom_error_widget.dart';
import 'package:freelancing_platform/core/widgets/custom_loading.dart';
import 'package:freelancing_platform/core/widgets/custom_text_field.dart';
import 'package:freelancing_platform/core/widgets/location_field.dart';
import 'package:freelancing_platform/core/widgets/gender_field.dart';
import 'package:freelancing_platform/core/widgets/birth_date_field.dart';
import 'package:freelancing_platform/views/account_setup/account_setup_controller/personal_info_controller.dart';
import 'package:get/get.dart';

class PersonalInfoView extends StatelessWidget {
  const PersonalInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(PersonalInfoController());

    return BaseScreen(
      appBar: CustomAppBar(
        title: "المعلومات الشخصية",
      ),
      body: GetBuilder<PersonalInfoController>(
        builder: (_) {
          return c.infoIsLoading.value
              ? const CustomLoading()
              : (c.isErrorOccure.value
                  ? CustomErrorWidget(
                      title: "لا يوجد انترنت",
                      message: StatusClasses.offlineError.message,
                      onRetry: c.loadData,
                    )
                  : SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: AppSpaces.screenHorizontalPadding.h,
                          horizontal: AppSpaces.mediumVerticalSpacing.w,
                        ),
                        child: Form(
                          key: c.formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: AppSpaces.heightMedium2),

                              Text("حدّث بياناتك لتجربة أفضل في المنصة",
                                  style: AppTextStyles.body),

                              SizedBox(height: AppSpaces.heightLarge),
                              CustomTextField(
                                controller: c.usernameController,
                                hintText: "اسم المستخدم",
                                keyboardType: TextInputType.name,
                                onChanged: c.onUsernameChanged,
                                // validator: Validators.username,//شلتها مشان ما يطلعوا خطأين فوق بعض
                              ),
                              Obx(() {
                                if (c.usernameError.value != null) {
                                  return Text(
                                    c.usernameError.value!,
                                    style:
                                        const TextStyle(color: AppColors.red),
                                  );
                                } else {
                                  return SizedBox.shrink();
                                }
                              }),

                              SizedBox(height: AppSpaces.heightMedium2),

                              /// الاسم الأول
                              CustomTextField(
                                controller: c.firstNameController,
                                hintText: "الاسم الأول",
                                validator: Validators.firstName,
                                onChanged: (v) => c.refreshForm(),
                              ),

                              SizedBox(height: AppSpaces.heightMedium2),

                              /// الاسم الأخير
                              CustomTextField(
                                controller: c.lastNameController,
                                hintText: "الاسم الأخير",
                                validator: Validators.lastName,
                                onChanged: (v) => c.refreshForm(),
                              ),

                              SizedBox(height: AppSpaces.heightMedium2),

                              /// الدولة
                              CountryPickerField(
                                initialCountry: c.countryCode.value != null
                                    ? CountryCode.fromCountryCode(
                                        c.countryCode.value!)
                                    : null,
                                onChanged: (countryCode) {
                                  c.countryCode.value = countryCode.code;
                                  c.refreshForm();
                                },
                              ),

                              SizedBox(height: AppSpaces.heightMedium2),

                              /// الجنس
                              GenderField(
                                value: c.gender.value,
                                onChanged: (v) {
                                  c.gender.value = v;
                                  c.refreshForm();
                                },
                              ),

                              SizedBox(height: AppSpaces.heightMedium2),
                              Center(
                                child:

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
                              ),
                              SizedBox(height: AppSpaces.heightMedium2),

                              /// الموافقة على الشروط
                              // Row(
                              //   children: [
                              //     Obx(() => Checkbox(
                              //           value: c.agreed.value,
                              //           onChanged: (v) {
                              //             c.agreed.value = v!;
                              //             c.refreshForm();
                              //           },
                              //         )),
                              //     const Expanded(
                              //       child: Text(
                              //         "أوافق على سياسة الخصوصية وشروط الخدمة",
                              //         style: TextStyle(fontSize: 12),
                              //       ),
                              //     ),
                              //   ],
                              // ),

                              SizedBox(height: AppSpaces.heightLarge),

                              /// زر 
                              Align(
                                  alignment: Alignment.center,
                                  child: GetBuilder<PersonalInfoController>(
                                    builder: (_) => ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.vividPurple,
                                        ),
                                        onPressed: (c.isFormValid &&
                                                !c.savingIsLoading.value)
                                            ? () async {
                                                await c.saveUserPersonalData();
                                              }
                                            : null,
                                        child: c.savingIsLoading.value
                                            ? SizedBox(
                                                height: 48.h,
                                                width: 250.w,
                                                child: const CustomLoading())
                                            : SizedBox(
                                                height: 48.h,
                                                width: 250.w,
                                                child: Center(
                                                  child: Text(
                                                    "حفظ التعديلات",
                                                    style: AppTextStyles.button,
                                                  ),
                                                ),
                                              )),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ));
        },
      ),
    );
  }
}
