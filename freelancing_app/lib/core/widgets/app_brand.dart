import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/constants/app_assets.dart';
// import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';

class AppBrand extends StatelessWidget {
  const AppBrand({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // مهم جداً
      children: [
        SizedBox(
          height: 180, // أو 160 حسب ما بتحبي
          child: Image.asset(
            AppAssets.logo1,
            fit: BoxFit.contain,
          ),
        ),
        Text("Freelancity", style: AppTextStyles.heading),

        Text(
          "منصّة تجمع بين الوظائف والعمل الحر",
          style: AppTextStyles.subheading,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
