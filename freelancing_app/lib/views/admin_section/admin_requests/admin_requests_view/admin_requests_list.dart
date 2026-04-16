import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/widgets/custom_app_bar.dart';
import 'package:freelancing_platform/models/user_collections/users_requests_model.dart';
import 'package:freelancing_platform/views/admin_section/admin_requests/widgets/request_shortcut.dart';

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
            body: TabBarView(
              children: [
                //-----tab1-----------
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
                          date: "",
                          onTab: () {},
                        );
                      }),
                ),
              ],
            )));
  }
}
