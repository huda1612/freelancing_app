import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/constants/reuest_status.dart';
import 'package:freelancing_platform/core/constants/user_roles.dart';
import 'package:freelancing_platform/data/services/request_service.dart';
import 'package:freelancing_platform/models/user_collections/users_requests_model.dart';
import 'package:get/get.dart';

class AdminRequestsListController extends GetxController {
  // var arg = Get.arguments[0]  ;
  List<UserRequestModel> allRequests = [];

  List<UserRequestModel> pendingRequests = [];

  List<UserRequestModel> approvedRequests = [];

  List<UserRequestModel> rejectedRequests = [];

  String selectedFilter = "all";

  StatusClasses pageState = StatusClasses.isloading;
  @override
  void onInit() {
    Future.wait([fetchAllRequests()]);
    super.onInit();
  }
  
  Future<void> fetchAllRequests() async {
    pageState = StatusClasses.isloading;
    update();
    RequestService rs = RequestService();
    final response = await rs.getAllRequests();
    response.fold((error) {
      pageState = error;
      update();
    }, (list) {
      allRequests = list;
      pendingRequests =
          list.where((r) => r.status == RequestStatus.pending).toList();

      approvedRequests =
          list.where((r) => r.status == RequestStatus.approved).toList();

      rejectedRequests =
          list.where((r) => r.status == RequestStatus.rejected).toList();

      pageState = StatusClasses.success;
      update();
    });
  }

  void fliterRequest(String? val) {
    if (val == "all") {
      selectedFilter = "all";
      pendingRequests =
          allRequests.where((r) => r.status == RequestStatus.pending).toList();

      approvedRequests =
          allRequests.where((r) => r.status == RequestStatus.approved).toList();

      rejectedRequests =
          allRequests.where((r) => r.status == RequestStatus.rejected).toList();
      update();
      return;
    }
    if (val == UserRole.freelancer) {
      selectedFilter = UserRole.freelancer;

      pendingRequests = allRequests
          .where((r) =>
              r.userType == UserRole.freelancer &&
              r.status == RequestStatus.pending)
          .toList();

      approvedRequests = allRequests
          .where((r) =>
              r.userType == UserRole.freelancer &&
              r.status == RequestStatus.approved)
          .toList();

      rejectedRequests = allRequests
          .where((r) =>
              r.userType == UserRole.freelancer &&
              r.status == RequestStatus.rejected)
          .toList();
      update();
      return;
    }
    if (val == UserRole.client) {
      selectedFilter = UserRole.client;

      pendingRequests = allRequests
          .where((r) =>
              r.userType == UserRole.client &&
              r.status == RequestStatus.pending)
          .toList();

      approvedRequests = allRequests
          .where((r) =>
              r.userType == UserRole.client &&
              r.status == RequestStatus.approved)
          .toList();

      rejectedRequests = allRequests
          .where((r) =>
              r.userType == UserRole.client &&
              r.status == RequestStatus.rejected)
          .toList();
      update();
      return;
    }
  }
}
