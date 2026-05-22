import 'package:freelancing_platform/core/bindings/auth_binding.dart';
import 'package:freelancing_platform/core/bindings/client_request_binding.dart';
import 'package:freelancing_platform/core/bindings/entry_test_binding.dart';
import 'package:freelancing_platform/core/bindings/onboarding_binding.dart';
import 'package:freelancing_platform/core/bindings/freelancer_request_binding.dart';
import 'package:freelancing_platform/core/bindings/splash_binding.dart';
import 'package:freelancing_platform/core/classes/user_session.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/user_roles.dart';
import 'package:freelancing_platform/core/general_controllers.dart/image_upload_controller.dart';
import 'package:freelancing_platform/core/middleware/admin_middleware.dart';
import 'package:freelancing_platform/core/middleware/auth_middleware.dart';
import 'package:freelancing_platform/core/services/navigation_service.dart';
import 'package:freelancing_platform/views/chat_section/chat_views/chat_view.dart';
import 'package:freelancing_platform/views/home_section/home_views/home_view.dart';
import 'package:freelancing_platform/views/main_section/main_views/main_view.dart';
import 'package:freelancing_platform/views/offer_section/offer_controller/project_offers_controller.dart';
import 'package:freelancing_platform/views/offer_section/offer_controller/submit_offer_controller.dart';
import 'package:freelancing_platform/views/offer_section/offer_view/project_offers_view.dart';
import 'package:freelancing_platform/views/offer_section/offer_view/submit_offer_view.dart';
import 'package:freelancing_platform/views/profile_section/profile_controllers/dashboard_controller.dart';
import 'package:freelancing_platform/views/profile_section/profile_controllers/profile_controller.dart';
import 'package:freelancing_platform/views/profile_section/profile_controllers/work_details_controller.dart';
import 'package:freelancing_platform/views/profile_section/profile_views/dashboard_view.dart';
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
import 'package:freelancing_platform/views/profile_section/profile_views/work_details_view.dart';
import 'package:freelancing_platform/views/project_section/project_controller/active_project_controller.dart';
import 'package:freelancing_platform/views/project_section/project_controller/browse_projects_controller.dart';
import 'package:freelancing_platform/views/project_section/project_controller/client_project_controller.dart';
import 'package:freelancing_platform/views/project_section/project_controller/freelance_project_controller.dart';
import 'package:freelancing_platform/views/project_section/project_controller/project_details_controller.dart';
import 'package:freelancing_platform/views/project_section/project_views/active_project_view.dart';
import 'package:freelancing_platform/views/project_section/project_views/bowse_projects_view.dart';
import 'package:freelancing_platform/views/project_section/project_views/client_project_view.dart';
import 'package:freelancing_platform/views/project_section/project_views/create_project_view.dart';
import 'package:freelancing_platform/views/project_section/project_views/freelance_project_view.dart';
import 'package:freelancing_platform/views/project_section/project_views/project_details_view.dart';
import 'package:freelancing_platform/views/search_section/search_controllers/search_clients_controller.dart';
import 'package:freelancing_platform/views/search_section/search_controllers/search_freelancers_controller.dart';
import 'package:freelancing_platform/views/search_section/search_views/search_clients_view.dart';
import 'package:freelancing_platform/views/search_section/search_views/search_freelancers_view.dart';
import 'package:freelancing_platform/views/search_section/search_views/search_view.dart';
import 'package:freelancing_platform/views/skills_section/skills_controller/skills_selection_controller.dart';
import 'package:freelancing_platform/views/skills_section/skills_view/skills_selection_view.dart';
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

import '../../views/project_section/project_controller/create_project_controller.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    //**********************************************auth pages****************************************
    GetPage(
      name: "/main", page: () => MainView(),
      //  binding: MainBinding()
      // binding: BindingsBuilder(() {
      //   Get.lazyPut(() => MainController());
      // }),
    ),
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

    GetPage(name: AppRoutes.privacy, page: () => const PrivacyView()),
    GetPage(name: AppRoutes.terms, page: () => const TermsView()),

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
        // Get.lazyPut(() => PendingController());
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

    //**********************************************main pages****************************************
    GetPage(
      name: AppRoutes.home,
      page: () => HomeView(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.chat,
      page: () => ChatView(),
      middlewares: [AuthMiddleware()],
    ),

    //**********************************************profile pages****************************************
    GetPage(
      name: AppRoutes.myProfile,
      page: () => ProfileView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => SignOutController());
        Get.lazyPut(
          () => ProfileController(userId: UserSession.uid!),
          tag: UserSession.uid!,
        );
        Get.lazyPut(() => ImageUploadController());
      }),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: AppRoutes.userProfile,
      page: () => ProfileView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => SignOutController());
        // Get.lazyPut(() => ProfileController());\
        // final userId =
        // NavigationService.routeArguments(AppRoutes.userProfile)?['userId'];
        final userId = Get.arguments['userId'];
        Get.lazyPut(
          () => ProfileController(userId: userId),
          tag: userId,
        );
        // Get.lazyPut(() => ImageUploadController());
      }),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
        name: AppRoutes.personalInfo,
        page: () => const PersonalInfoView(),
        middlewares: [AuthMiddleware()]),

    GetPage(
        name: AppRoutes.workDetails,
        page: () => WorkDetailsView(),
        binding: BindingsBuilder(() {
          Get.lazyPut(() => WorkDetailsController());
        }),
        middlewares: [AuthMiddleware()]),

    GetPage(
      name: AppRoutes.dashboard,
      page: () => DashboardView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => DashboardController());
      }),
      middlewares: [AuthMiddleware()],
    ),

    //**********************************************helpful pages****************************************

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

    GetPage(
      name: AppRoutes.skillsSelection,
      page: () => SkillsSelectionView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => SkillsSelectionController());
      }),
      // middlewares: [AuthMiddleware()])
    ),

    GetPage(
      name: AppRoutes.search,
      page: () => SearchView(),
    ),
    GetPage(
      name: AppRoutes.searchClients,
      page: () => SearchClientsView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => SearchClientsController());
      }),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.searchFreelancers,
      page: () => SearchFreelancersView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => SearchFreelancersController());
      }),
      middlewares: [AuthMiddleware()],
    ),
    //**********************************************project pages****************************************

    GetPage(
      name: AppRoutes.createProject,
      page: () => CreateProjectView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => CreateProjectController());
      }),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
        name: AppRoutes.browseProjects,
        page: () => BrowseProjectsView(),
        binding: BindingsBuilder(() {
          Get.lazyPut(() => BrowseProjectsController());
        }),
        middlewares: [AuthMiddleware()]),

    GetPage(
      name: AppRoutes.projectDetails,
      page: () => ProjectDetailsView(),
      binding: BindingsBuilder(() {
        Get.create(() => ProjectDetailsController(), permanent: false);
        // ⚠️ كل مرة تستدعي Get.find
        // رح يطلع controller جديد.
      }),
      // binding: ProjectBinding(),
      middlewares: [AuthMiddleware()],
    ),
    //جديدة
    GetPage(
      name: AppRoutes.myProjects,
      page: () => UserSession.role == UserRole.freelancer
          ? FreelancerProjectView()
          : ClientProjectView(),
      binding: BindingsBuilder(() {
        if (UserSession.role == UserRole.freelancer) {
          Get.lazyPut(() => FreelancerProjectController());
        } else {
          Get.lazyPut(() => ClientProjectController());
        }
      }),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: AppRoutes.activeProject,
      page: () => const ActiveProjectView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => ActiveProjectController());
      }),
      middlewares: [AuthMiddleware()],
    ),
    //جديدة

    //**********************************************offer pages****************************************
    GetPage(
      name: AppRoutes.submitOffer,
      page: () => SubmitOfferView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => SubmitOfferController());
      }),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.projectOffers,
      page: () => ProjectOffersView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => ProjectOffersController());
      }),
      middlewares: [AuthMiddleware()],
    ),
    //********************************************************************************************************
  ];
}
