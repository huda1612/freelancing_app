import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freelancing_platform/core/classes/firebase_crud.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/core/constants/collections_names.dart';
import 'package:freelancing_platform/core/constants/reuest_status.dart';
import 'package:freelancing_platform/core/constants/user_status.dart';
import 'package:freelancing_platform/data/services/user_service.dart';
import 'package:freelancing_platform/models/user_collections/users_requests_model.dart';
import 'package:freelancing_platform/views/admin_section/admin_requests/admin_requests_controller/admin_requests_list_controller.dart';
import 'package:freelancing_platform/views/admin_section/admin_requests/admin_requests_view/admin_requests_list_view.dart';
import 'package:get/get.dart';

class AdminRequestDatailsController extends GetxController {
  StatusClasses nameLoadingState = StatusClasses.isloading;
  StatusClasses sendingState = StatusClasses.success;

  final UserRequestModel request = Get.arguments[0];
  String fname = '';
  String lname = '';
  final expendedWork = RxInt(-1);
  final expendedcertificate = RxInt(-1);
  String rejectComment = '';

  @override
  void onInit() {
    super.onInit();
    Future.wait([fetchRequestedUserData()]);
  }

  Future<void> fetchRequestedUserData() async {
    nameLoadingState = StatusClasses.isloading;
    update();
    // print("REQUEST UID: ${request.uId}");
    final UserService us = UserService();
    final response = await us.fetchUserData2(request.uId);
    response.fold((error) {
      nameLoadingState = error;
      update();
    }, (user) {
      fname = user.fname;
      lname = user.lname;
      nameLoadingState = StatusClasses.success;
      update();
    });
  }

  Future<void> onReject() async {
    if (rejectComment.isEmpty) {
      Get.snackbar("تعذر الرفض", "يجب ادخال سبب الرفض أولا");
      return;
    }
    sendingState = StatusClasses.isloading;
    update();

    var response =
        await FirebaseCrud.runTransaction(action: (transaction) async {
      final firestore = FirebaseFirestore.instance;

      final requestRef =
          firestore.collection(CollectionsNames.userRequests).doc(request.id);

      final userRef =
          firestore.collection(CollectionsNames.users).doc(request.uId);

      ///  قراءة الطلب
      final requestSnap = await transaction.get(requestRef);

      if (!requestSnap.exists || requestSnap.data() == null) {
        //بحال رمي خطأ جوا مناقله بيطلع من كل المناقله وبينرمى الخطأ للCrud اللي بعالجه
        //غلط اعمل return جوا مناقله!!!
        throw Exception("Request not found");
      }
      final UserRequestModel requestData =
          UserRequestModel.fromMap(requestSnap.data()!, requestSnap.id);

      /// تحقق من الحالة
      if (requestData.status != RequestStatus.pending) {
        throw Exception("Request is not pending");
      }

      ///  تحديث الطلب
      transaction.update(requestRef, {
        'status': RequestStatus.rejected,
        'rejectComment': rejectComment,
        'updateStateAt': Timestamp.now()
      });

      /// تحديث المستخدم
      transaction.update(userRef, {
        'status': UserStatus.rejected,
      });
    });
    if (response == StatusClasses.success) {
      sendingState = StatusClasses.success;

      Get.back();

      update();
      Get.back(result: true);
      Get.snackbar("نجاح", "تم رفض الطلب بنجاح");

      return;
    } else {
      sendingState = response;
      Get.snackbar("خطأ", response.message ?? "حدث خطأ ما");
      update();

      return;
    }
  }

  Future<void> onAccept() async {
    sendingState = StatusClasses.isloading;
    update();

    var response =
        await FirebaseCrud.runTransaction(action: (transaction) async {
      final firestore = FirebaseFirestore.instance;

      final requestRef =
          firestore.collection(CollectionsNames.userRequests).doc(request.id);

      final userRef =
          firestore.collection(CollectionsNames.users).doc(request.uId);

      ///  قراءة الطلب
      final requestSnap = await transaction.get(requestRef);

      if (!requestSnap.exists || requestSnap.data() == null) {
        //بحال رمي خطأ جوا مناقله بيطلع من كل المناقله وبينرمى الخطأ للCrud اللي بعالجه
        //غلط اعمل return جوا مناقله!!!
        throw Exception("Request not found");
      }
      final UserRequestModel requestData =
          UserRequestModel.fromMap(requestSnap.data()!, requestSnap.id);

      /// تحقق من الحالة
      if (requestData.status != RequestStatus.pending) {
        throw Exception("Request is not pending");
      }

      ///  تحديث الطلب
      transaction.update(requestRef, {
        'status': RequestStatus.approved,
        // 'rejectComment': null,
        'updateStateAt': Timestamp.now()
      });

      /// تحديث المستخدم
      transaction.update(userRef, {
        'status': UserStatus.approved,
      });
    });
    if (response == StatusClasses.success) {
      sendingState = StatusClasses.success;

      update();
      Get.back(result: true);
      Get.snackbar("نجاح", "تم قبول الطلب بنجاح");

      return;
      // true;
    } else {
      sendingState = response;
      Get.snackbar("خطأ", response.message ?? "حدث خطأ ما");
      update();

      return;
      // false;
    }
  }

  Future<void> deleteRequest() async {
    sendingState = StatusClasses.isloading;
    update();
    //   final firestore = FirebaseFirestore.instance;

    final collection =
        FirebaseFirestore.instance.collection(CollectionsNames.userRequests);
    var response = await FirebaseCrud.deleteDocument(
        collectionRef: collection, docId: request.id);

    if (response == StatusClasses.success) {
      sendingState = StatusClasses.success;

      update();
      Get.back(result: true);
      Get.snackbar("نجاح", "تم حذف الطلب بنجاح");

      return;
    } else {
      sendingState = response;
      Get.snackbar("خطأ", response.message ?? "حدث خطأ ما");
      update();

      return;
    }
  }

  void onWorkExpend(int i) {
    if (expendedWork.value == i) {
      expendedWork.value = -1;
      return;
    }
    expendedWork.value = i;
    return;
  }

  void onCertificateExpend(int i) {
    if (expendedcertificate.value == i) {
      expendedcertificate.value = -1;
      return;
    }
    expendedcertificate.value = i;
    return;
  }
}
