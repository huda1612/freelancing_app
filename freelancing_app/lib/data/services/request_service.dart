import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:freelancing_platform/core/classes/firebase_crud.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/constants/collections_names.dart';
import 'package:freelancing_platform/core/constants/reuest_status.dart';
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
      "createdAt": now
    };

    var response = await FirebaseCrud.createDocument(
        collectionRef: collection, body: requestBody);

    return response;
  }

  //تحديث حالة طلب
  Future<StatusClasses> updateUserRequestStatus(
      {required String id, required RequestStatus status}) async {
    var collection =
        _firebaseFirestore.collection(CollectionsNames.userRequests);
    if (status != RequestStatus.approved ||
        status != RequestStatus.rejected ||
        status != RequestStatus.pending) {
      return StatusClasses.invalidData;
    }
    var requestBody = {"status": status};

    var response = await FirebaseCrud.updateDocument(
        collectionRef: collection, docId: id, body: requestBody);

    return response;
  }

  //حذف طلب
  Future<StatusClasses> deleteUserRequest({required String id}) async {
    var collection =
        _firebaseFirestore.collection(CollectionsNames.userRequests);

    var response =
        await FirebaseCrud.deleteDocument(collectionRef: collection, docId: id);

    return response;
  }
}
