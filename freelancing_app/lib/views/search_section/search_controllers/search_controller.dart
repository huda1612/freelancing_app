import 'package:flutter/material.dart';
import 'package:freelancing_platform/models/search/search_option_model.dart';
import 'package:get/get.dart';

class SearchPageController extends GetxController {
  var options = <SearchOptionModel>[
    SearchOptionModel(
      title: "تصفح المشاريع",
      icon: Icons.folder_open,
      route: "/browseProjects",
    ),
    SearchOptionModel(
      title: "ابحث عن عملاء",
      icon: Icons.person_search,
      route: "/searchClients",
    ),
    SearchOptionModel(
      title: "ابحث عن مستقلين",
      icon: Icons.work_outline,
      route: "/searchFreelancers",
    ),
  ].obs;

  void navigateTo(String route) {
    Get.toNamed(route);
  }
}
