import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';

class CountryPickerField extends StatefulWidget {
  final Function(CountryCode)? onChanged;
  final CountryCode? initialCountry;
  const CountryPickerField({super.key, this.onChanged, this.initialCountry});

  @override
  State<CountryPickerField> createState() => _CountryPickerFieldState();
}

class _CountryPickerFieldState extends State<CountryPickerField> {
  CountryCode? selectedCountry;
  @override
  void initState() {
    super.initState();
    selectedCountry = widget.initialCountry;
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Stack(
        children: [
          /// الحقل الأساسي
          Container(
            width: 380.w,
            height: 55.h,
            padding: EdgeInsets.symmetric(horizontal: AppSpaces.mediumHorizontalPadding.w),
            decoration: BoxDecoration(
              color: AppColors.veryLightGrey,
              border: Border.all(color: AppColors.veryLightGrey),
              borderRadius: BorderRadius.circular(AppSpaces.radiusSmall),
            ),
            child: Row(
              children: [
                SizedBox(width: AppSpaces.width),

                /// اسم الدولة
                Expanded(
                  child: Text(
                    selectedCountry?.name ??
                        (isArabic ? "اختر الدولة" : "Select Country"),
                    style: TextStyle(fontSize: 12.sp,
            color: AppColors.vividPurple,),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                SizedBox(width: AppSpaces.width),

                /// العلم
                if (selectedCountry?.flagUri != null)
                  Image.asset(
                    selectedCountry!.flagUri!,
                    package: 'country_code_picker',
                    width: 24.w,
                    height: 24.h,
                  )
                else
                  Icon(Icons.public, color: AppColors.vividPurple),
              ],
            ),
          ),

          /// CountryCodePicker شفاف فوق الحقل
          Positioned.fill(
            child: Opacity(
              opacity: 0, // نخليه غير مرئي
              child: CountryCodePicker(
                onChanged: (country) {
                  setState(() {
                    selectedCountry = country;
                  });
                  widget.onChanged?.call(country);
                },
                initialSelection: widget.initialCountry?.code ?? 'SY',
                showCountryOnly: true,
                showOnlyCountryWhenClosed: true,
                showFlag: true,
                showFlagDialog: true,
                hideMainText: true,
                showDropDownButton: false,
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
