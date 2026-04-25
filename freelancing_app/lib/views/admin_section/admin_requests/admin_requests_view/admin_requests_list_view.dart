import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/core/constants/reuest_status.dart';
import 'package:freelancing_platform/core/widgets/custom_app_bar.dart';
import 'package:freelancing_platform/core/widgets/get_rerponse_handler.dart';
import 'package:freelancing_platform/views/admin_section/admin_requests/admin_requests_controller/admin_requests_list_controller.dart';
import 'package:freelancing_platform/views/admin_section/admin_requests/widgets/request_shortcut.dart';
import 'package:get/get.dart';

class AdminRequestsListView extends StatelessWidget {
  const AdminRequestsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: CustomAppBar(
              backgroundColor: AppColors
                  .white, //هي لازمها تعديل بالappBar نفسه نخليهم كلهم جوا التطبيق ابيض افتراضيا
              title: "All Requests",
              leadingIcon: Icon(Icons.search),
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
            body: GetBuilder(
                init: Get.find<AdminRequestsListController>(),
                builder: (controller) {
                  return UiStateHandler(
                    status: controller.pageState,
                    fetchDataFun: controller.fetchAllRequests,
                    child: TabBarView(
                      children: [
                        //-----tab1-----------
                        Container(
                          color: AppColors.veryLightGrey,
                          child: ListView.builder(
                              itemCount: controller.allRequests.length,
                              itemBuilder: (context, index) {
                                if (controller.allRequests[index].status ==
                                    RequestStatus.pending) {
                                  return RequestShortcut(
                                    id: controller.allRequests[index].id,
                                    requestStatus:
                                        controller.allRequests[index].status,
                                    usrename:
                                        controller.allRequests[index].userType,
                                    date:
                                        controller.allRequests[index].createdAt,
                                    onTab: () {
                                      Get.toNamed(
                                          "${AppRoutes.adminRequestDetails}/id=${controller.allRequests[index].id}");
                                    },
                                  );
                                }
                              }),
                        ),
                        //-----tab2-----------
                        Container(
                          color: AppColors.veryLightGrey,
                          child: ListView.builder(
                              itemCount: 10,
                              itemBuilder: (context, index) {
                                // return RequestShortcut(id , RequestStatus , usrename , date);
                                return RequestShortcut(
                                  id: "",
                                  requestStatus: RequestStatus.approved,
                                  usrename: "HudaAhmed",
                                  date: null,
                                  onTab: () {},
                                );
                              }),
                        ),
                        //-----tab3-----------
                        Container(
                          color: AppColors.veryLightGrey,
                          child: ListView.builder(
                              itemCount: 10,
                              itemBuilder: (context, index) {
                                // return RequestShortcut(id , RequestStatus , usrename , date);
                                return RequestShortcut(
                                  id: "",
                                  requestStatus: RequestStatus.rejected,
                                  usrename: "HudaAhmed",
                                  date: null,
                                  onTab: () {},
                                );
                              }),
                        ),
                      ],
                    ),
                  );
                })));
  }
}
