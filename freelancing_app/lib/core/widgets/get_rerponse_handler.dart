import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/widgets/custom_error_widget.dart';
import 'package:freelancing_platform/core/widgets/custom_loading.dart';

//(للـ GET screens)
//معالجة حاله البيانات فاضيه بتصير بالUI بعدين
//🎯 استخدمي UiStateHandler فقط لما الصفحة كلها تعتمد على request واحد أساسي لعرضها
//اما صفحة فيها أجزاء متعددة data sources
//❌ إذا API واحد فشل → الصفحة كلها بتنهار

// هون لازم تفصلي UI state
// بدل wrapper واحد للصفحة كلها:
// ✔ كل جزء له state خاص فيه

// ⚠️ الفرق المهم جدًا
// 🟢 UiStateHandler = Screen-level

// "هل الصفحة تنعرض أصلاً؟"

// 🔵 Obx / local state = Component-level

// "هل جزء من الصفحة تغير أو يحمل بيانات؟"

// إذا data = تمنع عرض الصفحة → استخدمي UiStateHandler
// 🎯 إذا data = جزء من الصفحة → لا تستخدميه

//❗ مو كل data لازم تتحكم بفتح الصفحة كلها

//يعني على حسب الصفحه اذا ممكن افتحها بلا ما يكون نجح تحميل كل البيانات او لا

class UiStateHandler extends StatelessWidget {
  final StatusClasses status;
  final Widget child;
  final VoidCallback fetchDataFun;

  const UiStateHandler({
    super.key,
    required this.status,
    required this.child,
    required this.fetchDataFun,
  });

  @override
  Widget build(BuildContext context) {
    if (status == StatusClasses.success || status == StatusClasses.idle) {
      return child;
    }

    if (status == StatusClasses.isloading) {
      return CustomLoading();
    }
    print(status.type);
    return CustomErrorWidget(
      title: status.type,
      message: status.message,
      onRetry: fetchDataFun,
    );
  }
}
