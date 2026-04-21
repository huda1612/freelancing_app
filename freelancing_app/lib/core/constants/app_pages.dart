import 'package:freelancing_platform/core/bindings/auth_binding.dart';
import 'package:freelancing_platform/core/bindings/onboarding_binding.dart';
import 'package:freelancing_platform/core/bindings/splash_binding.dart';
import 'package:freelancing_platform/core/middleware/auth_middleware.dart';
import 'package:freelancing_platform/views/account_setup/account_setup_view/personal_info_view.dart';
import 'package:freelancing_platform/views/auth_section/auth_views/error_view.dart';
import 'package:freelancing_platform/views/auth_section/auth_views/legal_views/privacy_view.dart';
import 'package:freelancing_platform/views/auth_section/auth_views/legal_views/terms_view.dart';
import 'package:freelancing_platform/views/auth_section/auth_views/login_view/login_view.dart';
import 'package:freelancing_platform/views/auth_section/auth_views/login_view/welcome_view.dart';
import 'package:freelancing_platform/views/auth_section/auth_views/no_internet_view.dart';
import 'package:freelancing_platform/views/auth_section/auth_views/register_view/join_view.dart';
import 'package:freelancing_platform/views/auth_section/auth_views/register_view/register_view.dart';
// import 'package:freelancing_platform/views/auth_section/auth_views/verification_view/verification_view.dart';
import 'package:freelancing_platform/views/auth_section/auth_views/verification_view/verify_email_view.dart';
import 'package:freelancing_platform/views/onboarding_section/onboarding_view/onboarding_view.dart';
import 'package:freelancing_platform/views/splash_section/splash_view/splash_view.dart';
import 'package:freelancing_platform/views/user_request_section/client_request/client_request_views/client_account_info_view.dart';
import 'package:freelancing_platform/views/user_request_section/freelancer_request/freelancer_request_views/freelancer_account_info_view.dart';

import 'package:freelancing_platform/views/user_request_section/freelancer_request/freelancer_request_views/freelancer_work_and_certificates_view.dart';

import 'package:freelancing_platform/views/user_request_section/shared_pages/shared_pages_views/entry_test.dart';
import 'package:freelancing_platform/views/user_request_section/shared_pages/shared_pages_views/pending_view.dart';
import 'package:freelancing_platform/views/user_request_section/shared_pages/shared_pages_views/rejected_view.dart';

import 'package:get/get.dart';

import 'app_routes.dart';

class AppPages {
  static final pages = [
    //**********************************************auth pages****************************************

    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
      // middlewares: [OnboardingMiddleware()],
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
      middlewares: [AuthMiddleware()],
      binding: AuthBinding(),
    ),

    // GetPage(
    //     name: AppRoutes.verification,
    //     page: () => VerificationView(),
    //     middlewares: [AuthMiddleware()]),

    GetPage(name: AppRoutes.privacy, page: () => const PrivacyView()),
    GetPage(name: AppRoutes.terms, page: () => const TermsView()),

    //**********************************************after login page****************************************
    //  GetPage(
    //     name: AppRoutes.home,
    //     page: () => const HomeView(),
    //     middlewares: [HomeMiddleware()]
    //     // binding: SplashBinding(),
    //   ),
    GetPage(
      name: AppRoutes.freelancerAccountInfo,
      page: () => FreelancerAccountInfoView(),
    ),
    GetPage(
      name: AppRoutes.error,
      page: () => ErrorView(),
    ),

    GetPage(
      name: AppRoutes.noInternet,
      page: () => NoInternetView(),
    ),
    //**********************************************request pages****************************************
    GetPage(
      name: AppRoutes.freelancerAccountInfo,
      page: () => FreelancerAccountInfoView(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.clientAccountInfo,
      page: () => ClientAccountInfoView(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.entryTest,
      page: () => EntryTestView(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.pending,
      page: () => PendingView(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.rejected,
      page: () => RejectedView(),
      middlewares: [AuthMiddleware()],
    ),

    //**********************************************settings pages****************************************
    GetPage(
        name: AppRoutes.personalInfo,
        page: () => const PersonalInfoView(),
        middlewares: [AuthMiddleware()]),




    GetPage(
  name: AppRoutes.freelancerWorkAndCertificates,
  page: () => FreelancerWorkAndCertificatesView(),
),

  ];
}
