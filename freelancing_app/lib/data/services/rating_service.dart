import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:freelancing_platform/core/classes/firebase_crud.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/collections_names.dart';
import 'package:freelancing_platform/models/user_collections/rating_model.dart';
import 'package:freelancing_platform/models/user_collections/user_model.dart';

class RatingService {
  RatingService({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firebaseFirestore;

  Future<Either<StatusClasses, List<RatingModel>>> getAllUserRatings({
    required String uId,
  }) async {
    var query = _firebaseFirestore
        .collection(CollectionsNames.users)
        .doc(uId)
        .collection(CollectionsNames.ratings);
    var response = await FirebaseCrud.runGetQuery<RatingModel>(
        query: query, fromMap: (data, id) => RatingModel.fromMap(data, id));
    return response;
  }

  Future<Either<StatusClasses, List<RatingModel>>> get10UserRatings({
    required String uId,
  }) async {
    var query = _firebaseFirestore
        .collection(CollectionsNames.users)
        .doc(uId)
        .collection(CollectionsNames.ratings)
        .orderBy('createdAt', descending: true) //هي يمكن رح تعطي خطأ
        .limit(10);
    var response = await FirebaseCrud.runGetQuery<RatingModel>(
        query: query, fromMap: (data, id) => RatingModel.fromMap(data, id));
    return response;
  }

  Future<StatusClasses> submitRatingTransaction(
      {required String userId,
      required RatingModel rating,
      required bool isClientSubmitting}) async {
    final userRef =
        _firebaseFirestore.collection(CollectionsNames.users).doc(userId);

    final ratingRef =
        userRef.collection(CollectionsNames.ratings).doc(); // auto id

    final projectRef = _firebaseFirestore
        .collection(CollectionsNames.projects)
        .doc(rating.projectId);

    return await FirebaseCrud.runTransaction(
      action: (transaction) async {
        //  read user
        final userSnap = await transaction.get(userRef);

        if (!userSnap.exists) {
          throw Exception("User not found");
        }

        final data = userSnap.data() as Map<String, dynamic>;
        final user = UserModel.fromMap(data, userId);
      
        //1- add rating document
        transaction.set(ratingRef, rating.toMap());

        //2- update aggregates in user doc 
        transaction.update(userRef, {
          'ratingsCount': user.ratingsCount + 1,
          'professionalismSum':
              user.professionalismSum + rating.professionalism,
          'communicationSum': user.communicationSum + rating.communication,
          'punctualitySum': user.punctualitySum + rating.punctuality,
          'qualitySum': user.qualitySum + rating.quality,
          'workAgainSum': user.workAgainSum + rating.workAgain,
        });
        //3- تحديث حالة التقييم بالمشروع
        transaction.update(projectRef, {
          isClientSubmitting ? 'clientRated' : 'freelancerRated': true,
        });
      },
    );
  }

  Future<Either<StatusClasses, List<RatingModel>>> getUserProjectRatings({
    required String uId,
    required String projectId,
  }) async {
    var query = _firebaseFirestore
        .collection(CollectionsNames.users)
        .doc(uId)
        .collection(CollectionsNames.ratings)
        .where("projectId", isEqualTo: projectId);
    var response = await FirebaseCrud.runGetQuery<RatingModel>(
        query: query, fromMap: (data, id) => RatingModel.fromMap(data, id));
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
