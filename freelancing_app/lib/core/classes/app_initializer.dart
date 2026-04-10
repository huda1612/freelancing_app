import 'package:freelancing_platform/services/local_storage_service.dart';

class AppInitializer {
  static Future<void> init() async {
    LocalStorageService.setConstantUid();
    LocalStorageService.setConstantRole();
    LocalStorageService.setConstantFirstOpen();
    LocalStorageService.setConstantLang();
  }
}
