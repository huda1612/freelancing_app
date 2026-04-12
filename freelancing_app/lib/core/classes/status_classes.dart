class StatusClasses {
  final String type;
  final String? message;
  const StatusClasses._(this.type, [this.message]);
  static const isloading = StatusClasses._("isloading");
  static const success = StatusClasses._("success");
  static const offlineError = StatusClasses._("offlineError");
  static const serverError = StatusClasses._("serverError");
  // static const error = StatusClasses._("error");
    static const permissionDenied = StatusClasses._("permissionDenied", "انتهت صلاحيتك، يرجى تسجيل الدخول");
    static const unavailable = StatusClasses._("unavailable", "تعذر الاتصال بالخادم، تحقق من اتصال الإنترنت وحاول مرة أخرى");
    static const notFound = StatusClasses._("notFound", "البيانات المطلوبة غير موجودة أو تم حذفها");
    static const indexRequired = StatusClasses._("indexRequired", "حدث خطأ في تحميل البيانات، يرجى المحاولة لاحقًا");
    static const invalidData = StatusClasses._("invalidData", "البيانات المدخلة غير صحيحة، يرجى التحقق والمحاولة مرة أخرى");
    static const unknown = StatusClasses._("unknown", "حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى");

  static const unauthorized = StatusClasses._(
      "unauthorized", "وصول غير مصرح به يرجى تسجيل الدخول اولا");

  factory StatusClasses.customError(String message) =>
      StatusClasses._("customError", message);
}
