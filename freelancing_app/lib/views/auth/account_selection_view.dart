import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_assets.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';
import 'package:get/get.dart';
import '../../core/constants/app_routes.dart';

class AccountSelectionView extends StatelessWidget {
  final List<String> previousAccounts = [
    "user1@example.com",
    "user2@example.com",
  ];

   AccountSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body:Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.softPurple, // بنفسجي
              AppColors.softBlue, // أزرق
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 240.h,
                child: Image.asset(AppAssets.logo1, fit: BoxFit.contain),
              ),

              SizedBox(height: AppSpaces.heightSmall),

              Text("بيزي نحول", style: AppTextStyles.heading),

              SizedBox(height: AppSpaces.heightSmall),

              Text(
                "منصّة تجمع بين الوظائف والعمل الحر",
                style: AppTextStyles.subheading,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSpaces.heightLarge),
                Text("اختر حسابك السابق للدخول", 
                style: AppTextStyles.subheading,
                textAlign: TextAlign.left,),
             SizedBox(height: 24),

            ...previousAccounts.map(
              (email) => ListTile(
                title: Text(email),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () => Get.toNamed(AppRoutes.login),
              ),
            ),
          ],
        ),
      ),
      )
    );
  }
}
