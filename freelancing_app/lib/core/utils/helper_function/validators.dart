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

  //  فاليديتور الاسم الأول
  static String? firstName(String value) {
    if (value.trim().isEmpty) return "الاسم الأول مطلوب";
    if (value.length < 2) return "الاسم الأول يجب أن يكون حرفين على الأقل";
    if (!RegExp(r"^[a-zA-Z\u0600-\u06FF\s]+$").hasMatch(value)) {
      return "الاسم الأول يجب أن يحتوي على أحرف فقط";
    }
    return null;
  }

  //  فاليديتور الاسم الأخير
  static String? lastName(String value) {
    if (value.trim().isEmpty) return "الاسم الأخير مطلوب";
    if (value.length < 2) return "الاسم الأخير يجب أن يكون حرفين على الأقل";
    if (!RegExp(r"^[a-zA-Z\u0600-\u06FF\s]+$").hasMatch(value)) {
      return "الاسم الأخير يجب أن يحتوي على أحرف فقط";
    }
    return null;
  }
}
