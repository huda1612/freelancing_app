import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/widgets/custom_app_bar.dart';

class AdminRequestsListView extends StatelessWidget {
  const AdminRequestsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: CustomAppBar(
              title: "All Requests",
              trailingIcon: Icon(Icons.search),
              bottom: const TabBar(tabs: [
                Tab(
                  text: "معلقة",
                ),
                Tab(
                  text: "مقبولة",
                ),
                Tab(
                  text: "مرفوضة",
                )
              ]),
            ),
            body: Container(
              color: AppColors.veryLightGrey,
              child: ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    // return RequestShortcut(id , RequestStatus , usrename , date);
                  }),
              // child: ,
            ),
          )),

      // children:[], Center(
      //   child: Padding(
      //     padding: EdgeInsets.symmetric(vertical: 40.h),
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         //الشعار
      //                         SizedBox(height: AppSpaces.heightMedium2),

      //         AppBrand(),

      //         SizedBox(height: AppSpaces.heightLarge),
      //         Text("انضم إلى المنصة", style: AppTextStyles.blacksubheading),
      //         SizedBox(height: AppSpaces.heightMedium2),
      //         //زر انشاء حساب بالايميل
      //         SizedBox(
      //           width: 380.w,
      //           child: CustomButton(
      //             text: "إنشاء حساب عبر البريد الإلكتروني",
      //             onTap: () => Get.toNamed(AppRoutes.register),
      //           ),
      //         ),
      //         SizedBox(height: AppSpaces.heightMedium),
      //         //زر بالجوجل
      //         SizedBox(
      //           width: 380.w,
      //           child: CustomButton(
      //             text: "الدخول باستخدام حساب جوجل",
      //             textStyle:
      //                 AppTextStyles.button.copyWith(color: AppColors.black),
      //             color: AppColors.white,
      //             prefix: Image.asset(
      //               AppIcons.google,
      //               width: 24.w,
      //               height: 24.h,
      //             ),
      //             onTap: () async {
      //               await googleController.signInWithGoogle();
      //             },
      //           ),
      //         ),
      //         SizedBox(
      //           height: AppSpaces.heightMedium,
      //         ),
      //         SizedBox(
      //           width: double.infinity,
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: [
      //               Text(
      //                 "لديك حساب ؟ ",
      //                 style:
      //                     AppTextStyles.link.copyWith(color: AppColors.grey),
      //               ),
      //               InteractiveTextLink(
      //                 text: "تسجيل الدخول",
      //                 onTap: () => Get.toNamed(AppRoutes.login),
      //               ),
      //             ],
      //           ),
      //         ),
      //         SizedBox(height: AppSpaces.heightLarge),
      //         SizedBox(
      //           width: double.infinity,
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: [
      //               Text(
      //                 "بالتسجيل، أنت توافق على ",
      //                 style:
      //                     AppTextStyles.link.copyWith(color: AppColors.grey),
      //               ),
      //               InteractiveTextLink(
      //                 text: "شروط الخدمة",
      //                 onTap: () {
      //                   // افتحي صفحة الشروط
      //                   Get.toNamed(AppRoutes.terms);
      //                 },
      //               ),
      //               Text(
      //                 " و ",
      //                 style:
      //                     AppTextStyles.link.copyWith(color: AppColors.grey),
      //               ),
      //               InteractiveTextLink(
      //                 text: "سياسة الخصوصية",
      //                 onTap: () {
      //                   // افتحي صفحة الخصوصية
      //                   Get.toNamed(AppRoutes.privacy);
      //                 },
      //               ),
      //             ],
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
