import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:freelancing_platform/core/bindings/initial_binding.dart';
import 'package:freelancing_platform/core/classes/app_initializer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:freelancing_platform/core/constants/app_constant_data.dart';
import 'package:freelancing_platform/core/constants/app_pages.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/core/services/notification_services.dart';
import 'package:freelancing_platform/core/utils/helper_function/check_fcm_token.dart';
import 'package:get/get.dart';
import 'firebase_options.dart'; //  مهم جداً

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, //  أهم سطر للويب
  );

  // استدعاء تهيئة البيانات قبل تشغيل التطبيق
  await AppInitializer.init();

  // set the publishable key for Stripe
  Stripe.publishableKey =
      "pk_test_51TfFzwJXDELQTpeAlceJvM2d6PUoE9riusuMpWuYB6O2HWH7RG3ls4gszx1rLrWIEIaho4Mn9PVtfOyp8HX2OJPF00J6vLDEv4";
  await Stripe.instance.applySettings();
  runApp(const MyApp());

  //الغاء تهيئة الاشعارات لو المستخدم لغالها من داخل التطبيق
  if (AppConstantData.notificationsEnable == false) {
    return;
  }

  final notificationServices = Get.put(NotificationServices());
  await notificationServices.initialize(
    onToken: checkFcmToken,
  );
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
          fallbackLocale: Locale('ar'),
          debugShowCheckedModeBanner: false,
          initialBinding: InitialBinding(),
          initialRoute: AppRoutes.splash,

          // initialRoute: AppRoutes.projectDetails,
          // initialRoute: AppRoutes.createProject,
          getPages: AppPages.pages,
        );
      },
    );
  }
}
