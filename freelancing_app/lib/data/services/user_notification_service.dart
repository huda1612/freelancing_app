import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:freelancing_platform/core/classes/firebase_crud.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/collections_names.dart';
import 'package:freelancing_platform/models/user_collections/notification_model.dart';

class UserNotificationService {
  UserNotificationService({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firebaseFirestore;
//احسن اعمل limit بعدد محدد يمكن ما اعرض كل الاشعارات
  Future<Either<StatusClasses, List<NotificationModel>>> getUserNotifications({
    required String uId,
  }) async {
    var query = _firebaseFirestore
        .collection(CollectionsNames.users)
        .doc(uId)
        .collection(CollectionsNames.notifications)
        .orderBy('createdAt', descending: true)
        .limit(50);

    var response = await FirebaseCrud.runGetQuery<NotificationModel>(
        query: query,
        fromMap: (data, id) => NotificationModel.fromMap(data, id));
    return response;
  }

  String generateNotificationId(String uId) {
    return _firebaseFirestore
        .collection(CollectionsNames.users)
        .doc(uId)
        .collection(CollectionsNames.notifications)
        .doc()
        .id;
  }

  //اضافة اشعار جديد
  Future<StatusClasses> addUserNotification({
    required String uId,
    required String notificationId,
    required NotificationModel notification,
  }) async {
    final collection = _firebaseFirestore
        .collection(CollectionsNames.users)
        .doc(uId)
        .collection(CollectionsNames.notifications);

    final response = await FirebaseCrud.createDocument(
      collectionRef: collection,
      docId: notificationId,
      body: notification.toMap(),
    );

    return response;
  }

  ///تحديث قيمة القراءه للاشعار
  Future<StatusClasses> updateIsReade({
    required String uId,
    required String notificationId,
    // bool value = true,
  }) async {
    final collection = _firebaseFirestore
        .collection(CollectionsNames.users)
        .doc(uId)
        .collection(CollectionsNames.notifications);

    final response = await FirebaseCrud.updateDocument(
      collectionRef: collection,
      docId: notificationId,
      body: {"isRead": true},
    );

    return response;
  }
}
