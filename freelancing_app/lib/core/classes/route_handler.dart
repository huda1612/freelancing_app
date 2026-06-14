import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freelancing_platform/core/classes/firebase_crud.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/classes/user_session.dart';
import 'package:freelancing_platform/core/constants/app_constant_data.dart';
import 'package:freelancing_platform/core/constants/app_notification_types.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/collections_names.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/user_roles.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/user_status.dart';
import 'package:freelancing_platform/core/services/navigation_service.dart';
import 'package:freelancing_platform/core/utils/helper_function/check_login.dart';
import 'package:freelancing_platform/models/user_collections/user_model.dart';
import 'package:get/get.dart';

class RouteHandler {
  //اول ما يدخل او بعد تسجيل الدخول او بعد انشاء الحساب
  static Future<String> firstRoutHandler() async {
    //اول شي بشوف اذا هي اول مره بيفتح التطبيق
    if (AppConstantData.firstOpen == null) {
      return AppRoutes.onboarding;
    }

    //بعدين بشوف اذا مسجل دخول ولا لا
    if (!isLogin()) {
      return AppRoutes.welcome;
    }

    //نتحقق اذا ادمن مناخده فورا على صفحته
    if (UserSession.role == UserRole.admin) {
      // return AppRoutes.adminHome;
      return AppRoutes.adminRequests;
    }

    //منتحقق من الايميل
    if (!FirebaseAuth.instance.currentUser!.emailVerified) {
      return AppRoutes.verifyEmail;
    }

    //اذا ما ادمن فمنتحقق من حالة المستخدم
    final docRef = FirebaseFirestore.instance
        .collection(CollectionsNames.users)
        .doc(UserSession.uid);

    final response = await FirebaseCrud.fetchDocument(
        docRef: docRef, fromMap: (map, id) => UserModel.fromMap(map, id));

    return response.fold((error) {
      //لو صار خطأ بجلب بيانات المستخدم
      if (error == StatusClasses.offlineError) {
        return AppRoutes.noInternet;
      }
      if (error == StatusClasses.unauthorized) {
        return AppRoutes.login;
      }
      print("!!!!!!!!!!!!!! error");
      print(error.message);
      return AppRoutes.error;
    }, (user) {
      //لو تم جلب بيانات المستخدم بنجاح منتأكد من حالته
      var status = user.status;
      switch (status) {
        case UserStatus.incomplete:
          {
            return UserSession.role == UserRole.freelancer
                ? AppRoutes.freelancerAccountInfo
                : AppRoutes.clientAccountInfo;
          }
        case UserStatus.rejected:
          {
            return AppRoutes.rejected;
          }
        case UserStatus.approved:
          {
            return AppRoutes.main;
          }
        case UserStatus.pending:
          {
            return AppRoutes.pending;
          }
        default:
          return UserSession.role == UserRole.freelancer
              ? AppRoutes.freelancerAccountInfo
              : AppRoutes.clientAccountInfo;
      }
    });
  }

  static Future<void> notificationRouteHandler(
      Map<String, dynamic> data) async {
    final String? type = data['type'];
    final String? id = data['id'];

    if (type == null) return;

    switch (type) {
      case AppNotificationTypes.userRequest:
        final route = await RouteHandler.firstRoutHandler();
        Get.offAllNamed(route);
        break;

      case AppNotificationTypes.newOffer:
        // 1. روحي لتاب العروض
        NavigationService.changeTab(3);
        // 2. افتحي صفحة داخل نفس التاب
        NavigationService.toNamed(
          AppRoutes.projectOffers,
          arguments: {
            "projectId": id,
          },
          id: 3, // مهم جداً = نفس التاب navigator
        );

        break;
      // case AppNotificationTypes.offerAccepted:
      //   NavigationService.changeTab(3);
      //   NavigationService.toNamed(
      //     AppRoutes.activeProject,
      //     arguments: {
      //       "projectId": id,
      //     },
      //     id: 3,
      //   );
      //   break;
      case AppNotificationTypes.offerRejected:
        NavigationService.changeTab(3);
        NavigationService.toNamed(
          AppRoutes.projectDetails,
          arguments: {
            "projectId": id,
          },
          id: 3,
        );
        break;
      case AppNotificationTypes.hireMe:
        NavigationService.changeTab(0);
        NavigationService.toNamed(
          AppRoutes.projectDetails,
          arguments: {
            "projectId": id,
          },
          id: 0,
        );
        break;
      case AppNotificationTypes.offerAccepted:
      case AppNotificationTypes.sendTasks:
      case AppNotificationTypes.rejectTasks:
      case AppNotificationTypes.approveTasks:
      case AppNotificationTypes.endTask:
      case AppNotificationTypes.rejectTask:
      case AppNotificationTypes
            .approveTask: //لغيتها بس اسا في اشعارات قديمه هيك
      case AppNotificationTypes.approveTaskWithPayment:
      case AppNotificationTypes.requestExtraTask:
      case AppNotificationTypes.cancelRequestExtraTask:
      case AppNotificationTypes.rejectRequestedExtraTask:
      case AppNotificationTypes.approveRequestExtraTask:
      case AppNotificationTypes.completeProject:
      case AppNotificationTypes.cancelProject:
      case AppNotificationTypes.newRating:
        Get.toNamed(
          AppRoutes.activeProject,
          arguments: {
            "projectId": id,
          },
        );
        // if (Get.isRegistered<ActiveProjectController>()) {
        //   unawaited(Get.find<ActiveProjectController>().loadTasks());
        // }
        // print("!!!!!!!!!!!!!! projectId : $id");
        // NavigationService.changeTab(3);
        // NavigationService.toNamed(
        //   AppRoutes.activeProject,
        //   arguments: {
        //     "projectId": id,
        //   },
        //   id: 3,
        // );
        break;
    }
  }
}
