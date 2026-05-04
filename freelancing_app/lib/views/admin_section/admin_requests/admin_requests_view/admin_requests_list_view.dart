import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';
import 'package:freelancing_platform/core/constants/user_roles.dart';
import 'package:freelancing_platform/core/widgets/custom_empty_data_text.dart';
import 'package:freelancing_platform/core/widgets/custom_button.dart';
import 'package:freelancing_platform/core/widgets/get_rerponse_handler.dart';
import 'package:freelancing_platform/views/admin_section/admin_requests/admin_requests_controller/admin_requests_list_controller.dart';
import 'package:freelancing_platform/views/admin_section/admin_requests/widgets/request_shortcut.dart';
import 'package:freelancing_platform/views/auth_section/auth_controller/sign_out_controller.dart';
import 'package:get/get.dart';

class AdminRequestsListView extends StatelessWidget {
  const AdminRequestsListView({super.key});

  @override
  Widget build(BuildContext context) {
    SignOutController signOutController = Get.find<SignOutController>();
    return DefaultTabController(
        length: 3,
        child: GetBuilder<AdminRequestsListController>(
            init: Get.find<AdminRequestsListController>(),
            builder: (controller) {
              // if (controller.haveToRefresh == true) {
              //   controller.fetchAllRequests();
              //   controller.haveToRefresh == false;
              // }
              return Scaffold(
                  appBar: AppBar(
                    leading: IconButton(
                        onPressed: signOutController.signOut,
                        icon: Icon(
                          Icons.output_rounded,
                          color: AppColors.black,
                        )),
                    backgroundColor: AppColors
                        .white, //هي لازمها تعديل بالappBar نفسه نخليهم كلهم جوا التطبيق ابيض افتراضيا
                    title: Text(
                      "قائمة الطلبات",
                      style: AppTextStyles.blacksubheading
                          .copyWith(color: AppColors.black),
                    ),
                    centerTitle: true,
                    // leading: Icon(Icons.search),
                    actions: [
                      Container(
                        margin: EdgeInsets.only(left: AppSpaces.paddingMedium),
                        padding: EdgeInsets.all(
                          AppSpaces.paddingSmall,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.veryLightGrey,
                          borderRadius:
                              BorderRadius.circular(AppSpaces.radiusMedium),
                          border: Border.all(color: Colors.grey, width: 0.5),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                              isDense: true,
                              dropdownColor: AppColors.grey,
                              value: controller.selectedFilter,
                              items: [
                                DropdownMenuItem(
                                  value: "all",
                                  child: Text("all"),
                                ),
                                DropdownMenuItem(
                                  value: UserRole.freelancer,
                                  child: Text("freelancers"),
                                ),
                                DropdownMenuItem(
                                  value: UserRole.client,
                                  child: Text("clients"),
                                )
                              ],
                              onChanged: (val) =>
                                  controller.fliterRequest(val)),
                        ),
                      ),
                    ],
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
                  body:
                      // GetBuilder(
                      // init: Get.find<AdminRequestsListController>(),
                      // builder: (controller) {
                      // return
                      UiStateHandler(
                    status: controller.pageState,
                    fetchDataFun: controller.fetchAllRequests,
                    child: TabBarView(
                      children: [
                        //-----tab1-----------
                        Container(
                            color: AppColors.veryLightGrey,
                            child: controller.pendingRequests.isNotEmpty
                                ? ListView.builder(
                                    itemCount:
                                        controller.pendingRequests.length,
                                    itemBuilder: (context, index) {
                                      return RequestShortcut(
                                        // id: controller.pendingRequests[index].id,
                                        requestStatus: controller
                                            .pendingRequests[index].status,
                                        usrename: controller
                                            .pendingRequests[index].userType,
                                        date: controller
                                            .pendingRequests[index].createdAt,
                                        onTab: () async {
                                          final result = await Get.toNamed(
                                              AppRoutes.adminRequestDetails,
                                              arguments: [
                                                controller
                                                    .pendingRequests[index]
                                              ]);
                                          if (result == true) {
                                            controller.fetchAllRequests();
                                          }
                                        },
                                      );
                                    })
                                : customEmptyMessage(
                                    message: "لا يوجد طلبات معلقة")
                            // : Center(
                            //     child: Text(
                            //       "لا يوجد طلبات معلقة",
                            //       style: AppTextStyles.blacksubheading
                            //           .copyWith(color: AppColors.grey),
                            //     ),
                            //   ),
                            ),
                        //-----tab2-----------
                        Container(
                            color: AppColors.veryLightGrey,
                            child: controller.approvedRequests.isNotEmpty
                                ? ListView.builder(
                                    itemCount:
                                        controller.approvedRequests.length,
                                    itemBuilder: (context, index) {
                                      return RequestShortcut(
                                        // id: controller.approvedRequests[index].id,
                                        requestStatus: controller
                                            .approvedRequests[index].status,
                                        usrename: controller
                                            .approvedRequests[index].userType,
                                        date: controller
                                            .approvedRequests[index].createdAt,
                                        onTab: () async {
                                          final result = await Get.toNamed(
                                              AppRoutes.adminRequestDetails,
                                              arguments: [
                                                controller
                                                    .approvedRequests[index]
                                              ]);
                                          if (result == true) {
                                            controller.fetchAllRequests();
                                          }
                                        },
                                      );
                                    })
                                : customEmptyMessage(
                                    message: "لا يوجد طلبات مقبولة")
                            // : Center(
                            //     child: Text(
                            //       "لا يوجد طلبات مقبولة",
                            //       style: AppTextStyles.blacksubheading
                            //           .copyWith(color: AppColors.grey),
                            //     ),
                            //   ),
                            ),
                        //-----tab3-----------
                        Container(
                            color: AppColors.veryLightGrey,
                            child: controller.rejectedRequests.isNotEmpty
                                ? ListView.builder(
                                    itemCount:
                                        controller.rejectedRequests.length,
                                    itemBuilder: (context, index) {
                                      return RequestShortcut(
                                        // id: controller.rejectedRequests[index].id,
                                        requestStatus: controller
                                            .rejectedRequests[index].status,
                                        usrename: controller
                                            .rejectedRequests[index].userType,
                                        date: controller
                                            .rejectedRequests[index].createdAt,
                                        onTab: () async {
                                          final result = await Get.toNamed(
                                              AppRoutes.adminRequestDetails,
                                              arguments: [
                                                controller
                                                    .rejectedRequests[index]
                                              ]);
                                          if (result == true) {
                                            controller.fetchAllRequests();
                                          }
                                        },
                                      );
                                    })
                                : customEmptyMessage(
                                    message: "لا يوجد طلبات مرفوضة")
                            // : Center(
                            //     child: Text(
                            //       "لا يوجد طلبات مرفوضة",
                            //       style: AppTextStyles.blacksubheading
                            //           .copyWith(color: AppColors.grey),
                            //     ),
                            //   ),
                            ),
                      ],
                    ),
                  ),
                  floatingActionButton:
                      controller.pageState != StatusClasses.isloading
                          ? CustomButton(
                              text: "حذف الطلبات القديمة",
                              color: AppColors.red,
                              onTap: controller.runCleanup,
                              isLoading: controller.cleanupLoading,
                              width: 180.w,
                              prefix: Icon(
                                Icons.delete,
                                color: AppColors.white,
                              ),
                            )
                          : SizedBox.shrink());
            }));
  }
}
