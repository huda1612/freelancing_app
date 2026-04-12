import 'package:freelancing_platform/core/constants/app_constant_data.dart';

bool checkLogin() {
  if (AppConstantData.uid == null || AppConstantData.role == null) {
    return false;
  }
  return true;
}
