import 'package:freelancing_platform/core/constants/app_keys.dart';
import 'package:freelancing_platform/core/services/local_storage_service.dart';

class UserSession {
  static String? uid;
  static String? role;

  //هالتابع يستخدم بعد الدخول للتطبيق
  /// تحميل البيانات من التخزين إلى الذاكرة
  static Future<void> load() async {
    uid = await LocalStorageService.getStringValue(AppKeys.uid);
    role = await LocalStorageService.getStringValue(AppKeys.role);

  }

  /// حفظ session عند login / register
  static Future<void> save({
    required String uidValue,
    required String roleValue,
  }) async {

    await LocalStorageService.setStringValue(AppKeys.uid, uidValue);
    await LocalStorageService.setStringValue(AppKeys.role, roleValue);

    uid = uidValue;
    role = roleValue;

  }

  /// حذف session عند logout
  static Future<void> clear() async {
    uid = null;
    role = null;

    await LocalStorageService.removeValue(AppKeys.uid);
    await LocalStorageService.removeValue(AppKeys.role);

  }
}
