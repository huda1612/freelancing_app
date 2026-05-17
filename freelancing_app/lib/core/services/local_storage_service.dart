import 'package:freelancing_platform/core/constants/app_constant_data.dart';
import 'package:freelancing_platform/core/constants/app_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static Future<void> setStringValue(String key, String value) async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    await sh.setString(key, value);
  }

  static Future<String?> getStringValue(String key) async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    return sh.getString(key);
  }

  static Future<void> removeValue(String key) async {
    final sh = await SharedPreferences.getInstance();
    await sh.remove(key); // هذا يحذف القيمة اللي تحت المفتاح
  }

  static Future<void> setBoolValue(String key, bool value) async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    await sh.setBool(key, value);
  }

  static Future<bool?> getBoolValue(String key) async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    return sh.getBool(key);
  }

  static Future<void> setConstantFirstOpen() async {
    AppConstantData.firstOpen = await getStringValue(AppKeys.firstOpen);
  }

  static Future<void> setConstantisNotificationsEnable() async {
    AppConstantData.notificationsEnable =
        await getBoolValue(AppKeys.notificationsEnable) ?? true;
  }

  // static setConstantFcm() async {
  //   AppConstantData.fcm = await getStringValue(AppKeys.fcm);
  // }

  // static setConstantLang() async {
  //   AppConstantData.lang = await getStringValue(AppKeys.lang);
  // }

  // static setConstantUid() async {
  //   AppConstantData.uid = await getStringValue(AppKeys.uid);
  // }

  // static setConstantRole() async {
  //   AppConstantData.role = await getStringValue(AppKeys.role);
  // }
}
