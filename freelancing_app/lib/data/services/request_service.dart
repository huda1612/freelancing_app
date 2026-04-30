import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:freelancing_platform/core/classes/firebase_crud.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/constants/collections_names.dart';
import 'package:freelancing_platform/core/constants/reuest_status.dart';
import 'package:freelancing_platform/data/services/user_service.dart';
import 'package:freelancing_platform/models/user_collections/user_request_snapshot_model.dart';
import 'package:freelancing_platform/models/user_collections/users_requests_model.dart';

class RequestService {
  RequestService({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firebaseFirestore;

  Future<Either<StatusClasses, List<UserRequestModel>>> getAllRequests() async {
    var query = _firebaseFirestore.collection(CollectionsNames.userRequests);
    var response = await FirebaseCrud.runGetQuery<UserRequestModel>(
        query: query,
        fromMap: (data, id) => UserRequestModel.fromMap(data, id));
    return response;
  }

  Future<Either<StatusClasses, UserRequestModel>> fetchRequest(
      String rId) async {
    var docRef =
        _firebaseFirestore.collection(CollectionsNames.userRequests).doc(rId);
    var response = await FirebaseCrud.fetchDocument<UserRequestModel>(
        docRef: docRef,
        fromMap: (data, id) => UserRequestModel.fromMap(data, id));
    return response;
  }

  //اضافة طلب جديد
  Future<StatusClasses> addUserRequest(
      {required String uId,
      required String userType,
      required UserRequestSnapshotModel snapshot,
      Timestamp? createdAt}) async {
    var now = Timestamp.now();
    var collection =
        _firebaseFirestore.collection(CollectionsNames.userRequests);

    var requestBody = {
      "uId": uId,
      "userType": userType,
      "snapshot": snapshot.toMap(),
      "status": RequestStatus.pending,
      "updateStateAt": now,
      "createdAt": now
    };

    var response = await FirebaseCrud.createDocument(
        docId: uId, collectionRef: collection, body: requestBody);

    return response;
  }

  // //تحديث حالة طلب
  // Future<StatusClasses> updateUserRequestStatus(
  //     {required String id, required RequestStatus status}) async {
  //   var collection =
  //       _firebaseFirestore.collection(CollectionsNames.userRequests);
  //   if (status != RequestStatus.approved ||
  //       status != RequestStatus.rejected ||
  //       status != RequestStatus.pending) {
  //     return StatusClasses.invalidData;
  //   }
  //   var requestBody = {"status": status};

  //   var response = await FirebaseCrud.updateDocument(
  //       collectionRef: collection, docId: id, body: requestBody);

  //   return response;
  // }

  //حذف طلب
  Future<StatusClasses> deleteUserRequest({required String id}) async {
    var collection =
        _firebaseFirestore.collection(CollectionsNames.userRequests);

    var response =
        await FirebaseCrud.deleteDocument(collectionRef: collection, docId: id);

    return response;
  }

  //بدي اعمل الزر بصفحة التفاصيل يحذف المستخدم والطلب بدل بس حذف الظلب!!!!!!!!
  Future<StatusClasses> cleanOldRejectedRequestesAndUsers() async {
    //استعلام بجيب اللي تاريخهم اكثر من 15
    final query = _firebaseFirestore
        .collection(CollectionsNames.userRequests)
        .where("status", isEqualTo: RequestStatus.rejected)
        .where(
          "updateStateAt",
          isLessThan: Timestamp.fromDate(
            DateTime.now().subtract(const Duration(days: 15)),
          ),
        );
    final rejectedRequestsResponse = await FirebaseCrud.runGetQuery(
        query: query,
        fromMap: (data, id) => UserRequestModel.fromMap(data, id));

    return rejectedRequestsResponse.fold((error) async {
      return error;
    }, (request) async {
      UserService rs = UserService();
      await Future.wait(request.map((r) async {
        final res = await deleteUserRequest(id: r.id);

        if (res == StatusClasses.success) {
          final res2 = await rs.deleteUser(r.uId);
          if (res2 != StatusClasses.success) {
            print("!!!!!!!!!!!!!!!!${res2.message}");
          }
        } else {
          print("!!!!!!!!!!!!!!!!${res.message}");
        }
      }));

      return StatusClasses.success;
    });
  }

  //حذف الطلبات المقبولة القديمة
  Future<StatusClasses> cleanOldAcceptedRequest() async {
    //استعلام بجيب اللي تاريخهم اكثر من 15
    final query = _firebaseFirestore
        .collection(CollectionsNames.userRequests)
        .where("status", isEqualTo: RequestStatus.approved)
        .where(
          "updateStateAt",
          isLessThan: Timestamp.fromDate(
            DateTime.now().subtract(const Duration(days: 15)),
          ),
        );
    final acceptedResponse = await FirebaseCrud.runGetQuery(
        query: query,
        fromMap: (data, id) => UserRequestModel.fromMap(data, id));

    return acceptedResponse.fold((error) async {
      return error;
    }, (request) async {
      await Future.wait(request.map((r) async {
        await deleteUserRequest(id: r.id);
      }));

      return StatusClasses.success;
    });
  }
}
