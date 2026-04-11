import 'package:flutter/material.dart';
// import 'package:freelancing_platform/core/constants/app_assets.dart';
// import 'package:freelancing_platform/core/constants/app_spaces.dart';
// import 'package:freelancing_platform/core/constants/app_text_styles.dart';
import 'package:freelancing_platform/core/widgets/app_brand.dart';
import 'package:freelancing_platform/core/widgets/base_screen.dart';
import 'package:freelancing_platform/views/splash_section/splash_controller/splash_controller.dart';
import 'package:get/get.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
      Get.find<SplashController>();

    return BaseScreen( 
       body: Center( child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
           
              AppBrand(),
            ],
          ),
        ),
     
    );
  }
}
