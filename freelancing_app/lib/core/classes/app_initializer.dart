import 'package:freelancing_platform/core/classes/user_session.dart';
import 'package:freelancing_platform/core/services/local_storage_service.dart';

class AppInitializer {
  static Future<void> init() async {
    // LocalStorageService.setConstantUid();
    // LocalStorageService.setConstantRole();
    await UserSession.load();
    await LocalStorageService.setConstantFirstOpen();
    await LocalStorageService.setConstantisNotificationsEnable();
    //مافي داعي اله لان مارح احتاجه جوا التطبيق ليش لاعمل مصدرين للتوكن زضل حدثهم مع بعض
    // await LocalStorageService.setConstantFcm();
  }
}
