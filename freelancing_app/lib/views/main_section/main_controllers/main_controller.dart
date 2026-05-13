import 'package:freelancing_platform/views/chat_section/chat_views/chat_view.dart';
import 'package:freelancing_platform/views/home_section/home_views/home_view.dart';
import 'package:freelancing_platform/views/profile_section/profile_views/profile_view.dart';
import 'package:freelancing_platform/views/search_section/search_views/search_view.dart';
import 'package:get/get.dart';
class MainController extends GetxController {
  var currentIndex = 0.obs;

  final pages = [
    HomeView(),
    SearchView(),
    ChatView(),
    ProfileView(),
  ];

  void changePage(int index) {
    currentIndex.value = index;
  }
}
