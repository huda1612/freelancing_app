import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/core/services/navigation_service.dart';
import 'package:freelancing_platform/models/search/search_option_model.dart';
import 'package:get/get.dart';

class SearchPageController extends GetxController {
  var options = <SearchOptionModel>[
    SearchOptionModel(
      title: "تصفح المشاريع",
      icon: Icons.folder_open,
      route: AppRoutes.browseProjects,
    ),
    SearchOptionModel(
      title: "ابحث عن عملاء",
      icon: Icons.person_search,
      route: AppRoutes.searchClients,
    ),
    SearchOptionModel(
      title: "ابحث عن مستقلين",
      icon: Icons.work_outline,
      route: AppRoutes.searchFreelancers,
    ),
  ].obs;

  void navigateTo(String route) {
    NavigationService.toNamed(route);
  }
}
