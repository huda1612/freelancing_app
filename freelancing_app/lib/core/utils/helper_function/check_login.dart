import 'package:freelancing_platform/core/constants/app_constant_data.dart';
// import 'package:freelancing_platform/core/constants/app_routes.dart';
// import 'package:get/get.dart';

bool checkLogin() {
  if (AppConstantData.uid == null || AppConstantData.role == null) {
    return false;
  }
  return true;
}
