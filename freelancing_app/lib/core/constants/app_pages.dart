
import 'package:freelancing_platform/core/bindings/auth_binding.dart';
import 'package:freelancing_platform/core/bindings/onboarding_binding.dart';
import 'package:freelancing_platform/core/bindings/splash_binding.dart';
import 'package:freelancing_platform/views/auth_section/auth_views/legal_views/privacy_view.dart';
import 'package:freelancing_platform/views/auth_section/auth_views/legal_views/terms_view.dart';
import 'package:freelancing_platform/views/auth_section/auth_views/login_view/login_view.dart';
import 'package:freelancing_platform/views/auth_section/auth_views/login_view/welcome_view.dart';
import 'package:freelancing_platform/views/auth_section/auth_views/register_view/join_view.dart';
import 'package:freelancing_platform/views/auth_section/auth_views/register_view/register_view.dart';
import 'package:freelancing_platform/views/auth_section/auth_views/verification_view/verify_email_view.dart';
import 'package:freelancing_platform/views/onboarding_section/onboarding_view/onboarding_view.dart';
import 'package:freelancing_platform/views/splash_section/splash_view/splash_view.dart';
import 'package:get/get.dart';

import 'app_routes.dart';

class AppPages {
  static final pages = [
      GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: AppRoutes.welcome,
      page: () => const WelcomeView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.join,
      page: () => const JoinView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.verifyEmail,
      page: () => const VerifyEmailView(),
      binding: AuthBinding(),
    ),
    GetPage(name: AppRoutes.privacy, page: () => const PrivacyView()),
    GetPage(name: AppRoutes.terms, page: () => const TermsView()),
  ];
}
