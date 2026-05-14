// import 'package:flutter/material.dart';
// import 'package:freelancing_platform/core/classes/user_session.dart';
// import 'package:freelancing_platform/core/constants/data_constsnats/user_roles.dart';
// import 'package:freelancing_platform/core/widgets/custom_bottom_nav_bar.dart';
// import 'package:freelancing_platform/views/main_section/main_controllers/main_controller.dart';
// import 'package:get/get.dart';

// class MainView extends StatelessWidget {
//   MainView({super.key});

//   final controller = Get.find<NavigationController>();

//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () => Scaffold(
//         body: controller.pages[controller.currentIndex.value],
//         bottomNavigationBar: CustomBottomNavBar(
//           currentIndex: controller.currentIndex.value,
//           onTap: controller.changePage,
//           isClient:
//               UserSession.role == UserRole.client, // أو false حسب نوع المستخدم
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freelancing_platform/core/classes/user_session.dart';
import 'package:freelancing_platform/core/constants/app_pages.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/user_roles.dart';
import 'package:freelancing_platform/core/widgets/custom_bottom_nav_bar.dart';
import 'package:freelancing_platform/views/chat_section/chat_views/chat_view.dart';
import 'package:freelancing_platform/views/home_section/home_views/home_view.dart';
import 'package:freelancing_platform/views/main_section/main_controllers/main_controller.dart';
import 'package:freelancing_platform/views/profile_section/profile_views/profile_view.dart';
import 'package:freelancing_platform/views/search_section/search_views/search_view.dart';
import 'package:get/get.dart';

class MainView extends StatelessWidget {
  MainView({super.key});

  final NavigationController controller = Get.find<NavigationController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;

          final shouldPop = await controller.onWillPop();

          if (shouldPop) {
            SystemNavigator.pop();
          }
        },
        child: Scaffold(
          body: IndexedStack(
            index: controller.currentIndex.value,
            children: [
              _buildTabNavigator(
                navigatorKey: controller.navigatorKeys[0]!,
                // child: HomeView(),
                initialRoute: AppRoutes.home,
              ),
              _buildTabNavigator(
                navigatorKey: controller.navigatorKeys[1]!,
                // child: SearchView(),
                initialRoute: AppRoutes.search,
              ),
              _buildTabNavigator(
                navigatorKey: controller.navigatorKeys[2]!,
                // child: ChatView(),
                initialRoute: AppRoutes.chat,
              ),
              _buildTabNavigator(
                navigatorKey: controller.navigatorKeys[3]!,
                // child: ProfileView(),
                initialRoute: AppRoutes.profile,
              ),
            ],
          ),
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: controller.currentIndex.value,
            onTap: controller.changePage,
            isClient: UserSession.role == UserRole.client,
          ),
        ),
      ),
    );
  }

  // Widget _buildTabNavigator({
  //   required GlobalKey<NavigatorState> navigatorKey,
  //   required Widget child,
  // }) {
  //   return Navigator(
  //     key: navigatorKey,
  //     onGenerateRoute: (settings) {
  //       final page = AppPages.pages.firstWhere(
  //         (route) => route.name == settings.name,
  //         orElse: () => GetPage(
  //           name: '/',
  //           page: () => child,
  //         ),
  //       );

  //       return GetPageRoute(
  //         routeName: settings.name,
  //         page: page.page,
  //         binding: page.binding,
  //         middlewares: page.middlewares,
  //         transition: page.transition,
  //         settings: settings,
  //       );
  //     },
  //   );
  // }
  Widget _buildTabNavigator({
    required GlobalKey<NavigatorState> navigatorKey,
    required String initialRoute,
  }) {
    return Navigator(
      key: navigatorKey,
      initialRoute: initialRoute,
      onGenerateRoute: (settings) {
        final page = AppPages.pages.firstWhere(
          (route) => route.name == settings.name,
          orElse: () => GetPage(
            name: initialRoute,
            page: () => const SizedBox(),
          ),
        );

        return GetPageRoute(
          routeName: settings.name,
          page: page.page,
          binding: page.binding,
          middlewares: page.middlewares,
          transition: page.transition,
          // settings: settings
          settings: RouteSettings(
            name: settings.name,
            arguments: settings.arguments, // 👈 مهم جدًا
          ),
        );
      },
    );
  }
//   Widget _buildTabNavigator({
//   required GlobalKey<NavigatorState> navigatorKey,
//   required String initialRoute,
// }) {
//   return Navigator(
//     key: navigatorKey,
//     initialRoute: initialRoute,
//     onGenerateRoute: (settings) {

//       final page = AppPages.pages.firstWhere(
//         (route) => route.name == settings.name,
//         orElse: () => GetPage(
//           name: initialRoute,
//           page: () => const SizedBox(),
//         ),
//       );

//       return GetPageRoute(
//         routeName: settings.name,

//         page: () {
//           // inject current arguments manually
//           Get.arguments = settings.arguments;

//           return page.page();
//         },

//         binding: page.binding,
//         middlewares: page.middlewares,
//         transition: page.transition,

//         settings: settings,
//       );
//     },
//   );
// }
}
