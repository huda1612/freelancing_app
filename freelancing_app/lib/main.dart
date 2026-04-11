import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/classes/app_initializer.dart';
// import 'package:freelancing_platform/core/constants/app_constant_data.dart';
import 'package:freelancing_platform/core/constants/app_pages.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:freelancing_platform/services/localization_service.dart';
// import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
// import 'package:get/get.dart';
// import 'package:freelancing_platform/views/account_setup/account_setup_view/freelancer_personal_info_view.dart';
// import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'firebase_options.dart'; // ← مهم جداً

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // ← أهم سطر للويب
  );

  // استدعاء تهيئة البيانات قبل تشغيل التطبيق
  AppInitializer.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(428, 926),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
                return GetMaterialApp(
          locale: Locale('ar'),
          // locale: AppConstantData.lang == null
          //     ? Get.deviceLocale
          //     : Locale(AppConstantData.lang!),
          fallbackLocale: Locale('ar'),
          translations: LocalizationService(),
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.splash,
          getPages: AppPages.pages,
          
        );
      },
    );
  }
}
