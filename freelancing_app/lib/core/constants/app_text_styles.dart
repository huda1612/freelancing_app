import 'app_colors.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyles {
  //جاهز
  // العنوان الرئيسي (مثل "Welcome to HappWork")
  static TextStyle get heading => TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
    fontFamilyFallback: ["Poppins"],
    color: AppColors.black,
  );
  static TextStyle get blacksubheading => TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.bold,
    fontFamilyFallback: ["Poppins"],
    color: AppColors.black,
  );
   //جاهز
  // العنوان الثانوي (مثل "Job and Freelancing Marketplace!")
  static TextStyle get subheading => TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
   fontFamilyFallback: ["Poppins"],
    color: AppColors.veryLightGrey,
  );
   //جاهز
 //للنصوص التوضسيحية الرئيسية
  static TextStyle get meduimstyle => TextStyle(
    fontSize: 22.sp,
    fontWeight:FontWeight.bold,
   fontFamilyFallback: ["Poppins"],
    color: AppColors.purple,
  );
//جاهز
  // النص التوضيحي (مثل "We help you finding the best partners for work")
  static TextStyle get body => TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
  fontFamilyFallback: ["Poppins"],
    color:  AppColors.white,
  );

  //جاهز
    // زر "Get Started"
  static TextStyle get button => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w200,
    fontFamilyFallback: ["Poppins"],
    color: AppColors.white,
  );








  // النصوص التفاعلية (مثل "Create Account", "Sign In", "Forgot Password?")
  static TextStyle get link => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.bold,
    fontFamilyFallback: ["Poppins"],
    color: AppColors.vividPurple,
    
  );



  // نصوص الحقول (مثل "Email Address", "Password")
  static TextStyle get inputLabel => TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    fontFamilyFallback: ["Poppins"],
    color: Colors.white,
  );
 
}
