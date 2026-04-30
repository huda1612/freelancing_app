import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';
import 'package:get/get.dart';

class PrivacyView extends StatelessWidget {
  const PrivacyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.softPurple,
                AppColors.softBlue,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                /// 🔹 Header
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        color: AppColors.white,
                        onPressed: () => Get.back(),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "سياسة الخصوصية",
                        style: AppTextStyles.heading.copyWith(
                          color: AppColors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),

                /// 🔹 Subtitle
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "نحن نحترم خصوصيتك ونلتزم بحماية بياناتك الشخصية.",
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.white,
                      fontSize: 15,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// 🔹 Body
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(25),
                      ),
                    ),
                    child: ListView(
                      children: [
                        _section(
                          "المعلومات التي نجمعها",
                          "نقوم بجمع المعلومات التي يقدمها المستخدم مثل:\n"
                              "- الاسم\n"
                              "- البريد الإلكتروني\n"
                              "- معلومات الحساب (فريلانسر أو عميل)\n"
                              "- أي بيانات يتم إدخالها داخل التطبيق",
                          Icons.info,
                        ),
                        _section(
                          "كيف نستخدم المعلومات",
                          "نستخدم البيانات من أجل:\n"
                              "- إنشاء وإدارة الحسابات\n"
                              "- تسهيل التواصل بين العملاء والمستقلين\n"
                              "- تحسين تجربة المستخدم داخل التطبيق\n"
                              "- إرسال إشعارات مهمة",
                          Icons.settings,
                        ),
                        _section(
                          "مشاركة المعلومات",
                          "نحن لا نقوم ببيع أو مشاركة بيانات المستخدمين مع أي طرف ثالث، باستثناء الحالات التي يفرضها القانون.",
                          Icons.lock,
                        ),
                        _section(
                          "حماية المعلومات",
                          "نلتزم بحماية بيانات المستخدمين واتخاذ الإجراءات المناسبة لمنع الوصول غير المصرح به.",
                          Icons.security,
                        ),
                        _section(
                          "حقوق المستخدم",
                          "يحق للمستخدم:\n"
                              "- تعديل بياناته\n"
                              "- طلب حذف حسابه\n"
                              "- التواصل معنا لأي استفسار متعلق بالخصوصية",
                          Icons.verified_user,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 🔹 كرت التصميم (نفس الشروط)
  Widget _section(String title, String content, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.veryLightGrey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 أيقونة
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.lightPurple,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.white, size: 18),
          ),

          const SizedBox(width: 12),

          /// 🔹 النص
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.meduimstyle.copyWith(
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  content,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.darkGrey,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
