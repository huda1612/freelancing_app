import 'package:freelancing_platform/views/auth/account_selection_view.dart';
import 'package:freelancing_platform/views/auth/join_view.dart';
import 'package:freelancing_platform/views/auth/login_view.dart';
import 'package:freelancing_platform/views/auth/register_view.dart';
import 'package:freelancing_platform/views/auth/verify_email_view.dart';
import 'package:freelancing_platform/views/auth/welcome_view.dart';
import 'package:freelancing_platform/views/onboarding/onboarding_view.dart';
import 'package:freelancing_platform/views/splash/splash_view.dart';
import 'package:get/get.dart';

import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),
    GetPage(name: AppRoutes.onboarding, page: () => const OnboardingScreen()),
    GetPage(name: AppRoutes.login, page: () => const LoginView()),
    GetPage(name: AppRoutes.welcome, page: () => const WelcomeView()),
    GetPage(name: AppRoutes.register, page: () => const RegisterView()),
    GetPage(name: AppRoutes.join, page: () => const JoinView()),
    GetPage(
        name: AppRoutes.accountSelection, page: () => AccountSelectionView()),
    GetPage(name: AppRoutes.verifyEmail, page: () => const VerifyEmailView()),

    // GetPage(
    //   name: AppRoutes.privacy,
    //   page: () => const PrivacyScreen(),
    // ),
    // GetPage(
    //   name: AppRoutes.terms,
    //   page: () => const TermsScreen(),
    // ),
  ];
}
