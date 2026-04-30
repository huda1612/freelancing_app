import 'package:freelancing_platform/core/bindings/auth_binding.dart';
import 'package:freelancing_platform/core/bindings/client_request_binding.dart';
import 'package:freelancing_platform/core/bindings/entry_test_binding.dart';
import 'package:freelancing_platform/core/bindings/onboarding_binding.dart';
import 'package:freelancing_platform/core/bindings/freelancer_request_binding.dart';
import 'package:freelancing_platform/core/bindings/splash_binding.dart';
import 'package:freelancing_platform/core/middleware/admin_middleware.dart';
import 'package:freelancing_platform/core/middleware/auth_middleware.dart';
import 'package:freelancing_platform/views/profile_section/profile_views/personal_info_view.dart';
import 'package:freelancing_platform/views/admin_section/admin_requests/admin_requests_controller/admin_request_datails_controller.dart';
import 'package:freelancing_platform/views/admin_section/admin_requests/admin_requests_controller/admin_requests_list_controller.dart';
import 'package:freelancing_platform/views/admin_section/admin_requests/admin_requests_view/adimn_request_detail_view.dart';
import 'package:freelancing_platform/views/admin_section/admin_requests/admin_requests_view/admin_requests_list_view.dart';
import 'package:freelancing_platform/views/auth_section/auth_controller/sign_out_controller.dart';
import 'package:freelancing_platform/views/auth_section/auth_views/error_view.dart';
import 'package:freelancing_platform/views/auth_section/auth_views/legal_views/privacy_view.dart';
import 'package:freelancing_platform/views/auth_section/auth_views/legal_views/terms_view.dart';
import 'package:freelancing_platform/views/auth_section/auth_views/login_view/login_view.dart';
import 'package:freelancing_platform/views/auth_section/auth_views/login_view/welcome_view.dart';
import 'package:freelancing_platform/views/auth_section/auth_views/no_internet_view.dart';
import 'package:freelancing_platform/views/auth_section/auth_views/register_view/join_view.dart';
import 'package:freelancing_platform/views/auth_section/auth_views/register_view/register_view.dart';
import 'package:freelancing_platform/views/auth_section/auth_views/verification_view/verify_email_view.dart';
import 'package:freelancing_platform/views/onboarding_section/onboarding_view/onboarding_view.dart';
import 'package:freelancing_platform/views/profile_section/profile_views/profile_view.dart';
import 'package:freelancing_platform/views/splash_section/splash_view/splash_view.dart';
import 'package:freelancing_platform/views/user_request_section/request_controller/rejected_controller.dart';
import 'package:freelancing_platform/views/user_request_section/request_view/client_request_views/client_account_info_view.dart';
import 'package:freelancing_platform/views/user_request_section/request_view/client_request_views/client_work_view.dart';
import 'package:freelancing_platform/views/user_request_section/request_view/freelancer_request_views/freelancer_account_info_view.dart';
import 'package:freelancing_platform/views/user_request_section/request_view/freelancer_request_views/freelancer_work_and_certificates_view.dart';
import 'package:freelancing_platform/views/user_request_section/request_view/shared_pages_views/entry_test.dart';
import 'package:freelancing_platform/views/user_request_section/request_view/shared_pages_views/pending_view.dart';
import 'package:freelancing_platform/views/user_request_section/request_view/shared_pages_views/rejected_view.dart';
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
      name: AppRoutes.error,
      binding: BindingsBuilder(() {
        Get.lazyPut(() => SignOutController());
      }),
      page: () => ErrorView(),
    ),

    GetPage(
      name: AppRoutes.noInternet,
      page: () => NoInternetView(),
    ),
    //**********************************************request pages****************************************
    //صفحات المستقل
    GetPage(
      name: AppRoutes.freelancerAccountInfo,
      page: () => FreelancerAccountInfoView(),
      binding: FreelancerRequestBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.freelancerWorkAndCertificates,
      page: () => FreelancerWorkAndCertificatesView(),
      binding: FreelancerRequestBinding(),
      middlewares: [AuthMiddleware()],
    ),

    //صفحات العميل
    GetPage(
      name: AppRoutes.clientAccountInfo,
      page: () => ClientAccountInfoView(),
      binding: ClientRequestBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.clinetWork,
      page: () => ClientWorkView(),
      binding: ClientRequestBinding(),
      middlewares: [AuthMiddleware()],
    ),

    //صفحات مشتركه
    GetPage(
      name: AppRoutes.entryTest,
      page: () => EntryTestView(),
      binding: EntryTestBinding(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: AppRoutes.pending,
      page: () => PendingView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => SignOutController());
      }),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: AppRoutes.rejected,
      page: () => RejectedView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => RejectedController());
        Get.lazyPut(() => SignOutController());
      }),
      middlewares: [AuthMiddleware()],
    ),

    //**********************************************admin pages****************************************
    // GetPage(
    //   name: AppRoutes.adminHome,
    //   page: () => AdminHome(),
    //   middlewares: [AdminMiddleware()],
    // ),
    GetPage(
      name: AppRoutes.adminRequests,
      page: () => AdminRequestsListView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AdminRequestsListController());
        Get.lazyPut(() => SignOutController());
      }),
      middlewares: [AdminMiddleware()],
    ),
    GetPage(
      name: AppRoutes.adminRequestDetails,
      page: () => AdimnRequestDetailView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AdminRequestDatailsController());
      }),
      middlewares: [AdminMiddleware()],
    ),

    //**********************************************profile pages****************************************
    GetPage(
      name: AppRoutes.profile,
      page: () => ProfileView(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
        name: AppRoutes.personalInfo,
        page: () => const PersonalInfoView(),
        middlewares: [AuthMiddleware()]),
  ];
}
