import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';
import 'package:get/get.dart';

class TermsView extends StatelessWidget {
  const TermsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.softPurple, AppColors.softBlue],
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
                        "شروط الخدمة",
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
                    "باستخدامك لهذا التطبيق، فإنك توافق على الالتزام بالشروط والأحكام التالية:",
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
                          "استخدام التطبيق",
                          "يجب استخدام التطبيق بطريقة قانونية، ويُمنع:\n"
                              "- إساءة استخدام الخدمات\n"
                              "- نشر محتوى غير لائق أو مضلل\n"
                              "- انتحال شخصية الآخرين",
                          Icons.check_circle,
                        ),
                        _section(
                          "الحسابات",
                          "- المستخدم مسؤول عن معلومات حسابه\n"
                              "- يجب الحفاظ على سرية بيانات تسجيل الدخول",
                          Icons.person,
                        ),
                        _section(
                          "الخدمات",
                          "يوفر التطبيق منصة لربط العملاء بالمستقلين، ولا يتحمل مسؤولية الاتفاقات المباشرة بينهم.",
                          Icons.work,
                        ),
                        _section(
                          "المحتوى",
                          "جميع المحتويات داخل التطبيق مملوكة للتطبيق أو لمستخدميه، ولا يجوز استخدامها بدون إذن.",
                          Icons.article,
                        ),
                        _section(
                          "إيقاف الحساب",
                          "يحق لإدارة التطبيق إيقاف أي حساب يخالف الشروط دون إشعار مسبق.",
                          Icons.warning,
                        ),
                        _section(
                          "إخلاء المسؤولية",
                          "التطبيق غير مسؤول عن أي خسائر أو مشاكل ناتجة عن استخدام المنصة.",
                          Icons.error,
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

  /// 🔹 الكرت
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
