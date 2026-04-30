class Validators {
  // البريد الإلكتروني
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return "البريد الإلكتروني مطلوب";
    }
    if (!value.contains("@") || !value.contains(".")) {
      return "الرجاء إدخال بريد إلكتروني صالح";
    }
    return null;
  }

  // كلمة المرور
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return "كلمة المرور مطلوبة";
    }
    if (value.length < 6) {
      return "كلمة المرور يجب أن تكون 6 أحرف على الأقل";
    }
    return null;
  }

  // تأكيد كلمة المرور
  static String? confirmPassword(String? value, String original) {
    if (value == null || value.isEmpty) {
      return "الرجاء تأكيد كلمة المرور";
    }
    if (value != original) {
      return "كلمتا المرور غير متطابقتين";
    }
    return null;
  }

  // الاسم الأول
  static String? firstName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "الاسم الأول مطلوب";
    }
    if (value.length < 2) {
      return "الاسم الأول يجب أن يكون حرفين على الأقل";
    }
    if (!RegExp(r"^[a-zA-Z\u0600-\u06FF\s]+$").hasMatch(value)) {
      return "الاسم الأول يجب أن يحتوي على أحرف فقط";
    }
    return null;
  }

  // الاسم الأخير
  static String? lastName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "الاسم الأخير مطلوب";
    }
    if (value.length < 2) {
      return "الاسم الأخير يجب أن يكون حرفين على الأقل";
    }
    if (!RegExp(r"^[a-zA-Z\u0600-\u06FF\s]+$").hasMatch(value)) {
      return "الاسم الأخير يجب أن يحتوي على أحرف فقط";
    }
    return null;
  }

  // اسم المستخدم
  static String? username(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "اسم المستخدم مطلوب";
    }

    if (value.length < 3) {
      return "اسم المستخدم يجب أن يكون 3 أحرف على الأقل";
    }
    if (value.length > 30) {
      return "اسم المستخدم يجب أن يكون أقل من 30 محرف";
    }

    // يسمح بالعربي + الإنجليزي + الأرقام + _ فقط
    // if (!RegExp(r'^[a-zA-Z0-9\u0600-\u06FF_]+$').hasMatch(value)) {
    //   return "اسم المستخدم يجب أن يحتوي على أحرف أو أرقام أو _ فقط";
    // }
    if (!RegExp(
      r'^(?!^[0-9]+$)(?!^_+$)[a-zA-Z0-9\u0600-\u06FF_]+$',
    ).hasMatch(value)) {
      return "اسم المستخدم يجب أن يحتوي على أحرف أو أرقام أو _ فقط";
    }

    return null;
  }

  static String? validateSpecialization(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "الرجاء إدخال التخصص";
    }
    if (value.length < 3) {
      return "التخصص يجب أن يكون 3 أحرف على الأقل";
    }
    return null;
  }

  static String? validateJobTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "الرجاء إدخال المسمى الوظيفي";
    }
    if (value.length < 3) {
      return "المسمى الوظيفي يجب أن يكون 3 أحرف على الأقل";
    }
    return null;
  }

  static String? validateBio(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "الرجاء كتابة نبذة قصيرة";
    }
    if (value.length < 20) {
      return "النبذة يجب أن تكون 20 حرفًا على الأقل";
    }
    return null;
  }

  static bool validateWork(Map item) {
    return
        // item["image"] != "" &&
        item["title"].toString().trim().isNotEmpty &&
            item["description"].toString().trim().isNotEmpty;
  }

  static bool validateCertificate(Map item) {
    return item["image"] != "" &&
        item["title"].toString().trim().isNotEmpty &&
        item["description"].toString().trim().isNotEmpty;
  }
}
