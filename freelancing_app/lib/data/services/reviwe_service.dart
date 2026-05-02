import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:freelancing_platform/core/classes/firebase_crud.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/constants/collections_names.dart';
import 'package:freelancing_platform/models/user_collections/review_model.dart';

class ReviweService {
  ReviweService({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firebaseFirestore;

  Future<Either<StatusClasses, List<ReviewModel>>> getAllUserReview({
    required String uId,
  }) async {
    var query = _firebaseFirestore.collection(CollectionsNames.reviews);
    var response = await FirebaseCrud.runGetQuery<ReviewModel>(
        query: query, fromMap: (data, id) => ReviewModel.fromMap(data, id));
    return response;
  }

  Future<Either<StatusClasses, List<ReviewModel>>> get10UserReview({
    required String uId,
  }) async {
    var query = _firebaseFirestore
        .collection(CollectionsNames.users)
        .doc(uId)
        .collection('reviews')
        .orderBy('createdAt', descending: true)
        .limit(10);
    var response = await FirebaseCrud.runGetQuery<ReviewModel>(
        query: query, fromMap: (data, id) => ReviewModel.fromMap(data, id));
    return response;
  }
  // //اضافة تقييم جديد
  // Future<StatusClasses> addUserReview(
  //     {required String uId,
  //     required String userType,
  //     required UserRequestSnapshotModel snapshot,
  //     Timestamp? createdAt}) async {
  //   var now = Timestamp.now();
  //   var collection =
  //       _firebaseFirestore.collection(CollectionsNames.userRequests);

  //   var requestBody = {
  //     "uId": uId,
  //     "userType": userType,
  //     "snapshot": snapshot.toMap(),
  //     "status": RequestStatus.pending,
  //     "updateStateAt": now,
  //     "createdAt": now
  //   };

  //   var response = await FirebaseCrud.createDocument(
  //       docId: uId, collectionRef: collection, body: requestBody);

  //   return response;
  // }

  // //حذف
  // Future<StatusClasses> deleteUserRequest({required String id}) async {
  //   var collection =
  //       _firebaseFirestore.collection(CollectionsNames.userRequests);

  //   var response =
  //       await FirebaseCrud.deleteDocument(collectionRef: collection, docId: id);

  //   return response;
  // }
}
