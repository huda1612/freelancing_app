import 'package:freelancing_platform/core/classes/user_session.dart';
import 'package:freelancing_platform/core/services/local_storage_service.dart';

class AppInitializer {
  static Future<void> init() async {
    // LocalStorageService.setConstantUid();
    // LocalStorageService.setConstantRole();
    UserSession.load();
    LocalStorageService.setConstantFirstOpen();
    // LocalStorageService.setConstantLang();
  }
}
