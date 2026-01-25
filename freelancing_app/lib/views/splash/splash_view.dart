import 'package:flutter/material.dart';
import 'package:freelancing_platform/controllers/splash/splash_controller.dart';
import 'package:freelancing_platform/core/constants/app_assets.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/widgets/base_screen.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_text_styles.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());

    return BaseScreen( 
       body: Center( child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 240.h,
                child: Image.asset(
                 AppAssets.logo,
                  fit: BoxFit.contain,
                ),
              ),

              SizedBox(height: AppSpaces.heightSmall),

              Text(
                "FREELANCITY",
                style: AppTextStyles.heading,
              ),

              SizedBox(height: AppSpaces.heightSmall),

              Text(
                "منصّة تجمع بين الوظائف والعمل الحر",
                style: AppTextStyles.subheading,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
     
    );
  }
}
