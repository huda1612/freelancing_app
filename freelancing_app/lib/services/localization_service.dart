import 'package:freelancing_platform/core/lang/arabic.dart';
import 'package:freelancing_platform/core/lang/english.dart';
import 'package:get/get.dart';

class LocalizationService implements Translations {
  @override
  Map<String, Map<String, String>> get keys => {"ar": ar, "en": en};
}
