import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/data/services/request_service.dart';
import 'package:freelancing_platform/models/user_collections/users_requests_model.dart';
import 'package:get/get.dart';

class AdminRequestsListController extends GetxController {
  List<UserRequestModel> allRequests = [];
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
      pageState = StatusClasses.success;
      update();
    });
  }
}
