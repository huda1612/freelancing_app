import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/classes/user_session.dart';

import 'package:freelancing_platform/data/services/request_service.dart';
import 'package:freelancing_platform/data/services/user_service.dart';

import 'package:get/get.dart';

//انتهى
class RejectedController extends GetxController {
  //متغيرات اختبار القبول
  String rejectComment = '';
  StatusClasses pageState = StatusClasses.isloading;
  String _rId = '';

  @override
  void onInit() {
    super.onInit();
    //احضار البيانات من السيرفر وتجهيزها بالمتغيرات
    Future.wait([fetchRequest()]);
  }

  Future<void> fetchRequest() async {
    pageState = StatusClasses.isloading;
    update();
    final RequestService requestService = RequestService();
    final response = await requestService.fetchRequest(UserSession.uid!);

    response.fold((errorState) {
      //بحال كان الطلب محذوف
      if (errorState == StatusClasses.notFound) {
        rejectComment = "عذرا ، لم يتم العثور على سبب الرفض";
        Get.snackbar(
            "عذرا", "لقد تم حذف طلبك من النظام ، لذا لا يمكن ايجاد سبب الرفض");
        pageState = StatusClasses.success;
        update();
        return;
      }

      pageState = errorState;
      Get.snackbar(errorState.type,
          errorState.message ?? "حدث خطأ في جلب بيانات المستخدم");
      update();
    }, (data) {
      rejectComment = data.rejectComment ?? "لا يوجد سبب محدد";
      _rId = data.id;
      pageState = StatusClasses.success;
      update();
    });
  }

  Future<void> deleteUserAndRequest() async {
    pageState = StatusClasses.isloading;
    update();

    final RequestService rs = RequestService();
    final UserService us = UserService();

    final r1 = await us.deleteUser(UserSession.uid!);
    if (r1 != StatusClasses.success) {
      Get.snackbar("خطأ : ${r1.type}", r1.type);
      pageState = StatusClasses.success;
      update();
      return;
    }
    final r2 = await rs.deleteUserRequest(id: _rId);
    if (r2 != StatusClasses.success) {
      Get.snackbar("خطأ : ${r2.type}", r2.type);
      pageState = StatusClasses.success;
      update();
      return;
    }
    pageState = StatusClasses.success;
    update();
    Get.snackbar("نجاح", "تم الحذف بنجاح");
  }
}
