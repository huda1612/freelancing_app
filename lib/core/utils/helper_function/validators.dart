class Validators {
  static String? email(String value) {
    if (value.isEmpty) return "البريد الإلكتروني مطلوب";
    if (!value.contains("@") || !value.contains(".")) {
      return "الرجاء إدخال بريد إلكتروني صالح";
    }
    return null;
  }

  static String? password(String value) {
    if (value.isEmpty) return "كلمة المرور مطلوبة";
    if (value.length < 6) return "كلمة المرور يجب أن تكون 6 أحرف على الأقل";
    return null;
  }

  static String? confirmPassword(String value, String original) {
    if (value != original) return "كلمتا المرور غير متطابقتين";
    return null;
  }
}
