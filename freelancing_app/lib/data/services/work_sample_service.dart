import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:freelancing_platform/core/classes/firebase_crud.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/constants/collections_names.dart';
import 'package:freelancing_platform/models/user_collections/worksamples_model.dart';

class WorkSampleService {
  WorkSampleService({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firebaseFirestore;

  Future<Either<StatusClasses, List<WorksampleModel>>> getAllUserWorkSample(
      {required String uid}) async {
    var query = _firebaseFirestore
        .collection(CollectionsNames.users)
        .doc(uid)
        .collection(CollectionsNames.workSamples);
    var response = await FirebaseCrud.runGetQuery<WorksampleModel>(
        query: query, fromMap: (data, id) => WorksampleModel.fromMap(data, id));
    return response;
  }

  //اضافة عينه جديده
  Future<StatusClasses> addWorkSample({
    required String uid,
    required WorksampleModel workSample,
  }) async {
    var collection = _firebaseFirestore
        .collection(CollectionsNames.users)
        .doc(uid)
        .collection(CollectionsNames.workSamples);

    var requestBody = workSample.toMap();

    var response = await FirebaseCrud.createDocument(
        collectionRef: collection, body: requestBody);

    return response;
  }


  //حذف عينة
  Future<StatusClasses> deleteWorkSample({required String uId , required String wsId }) async {
    var collection =
        _firebaseFirestore.collection(CollectionsNames.users).doc(uId).collection(CollectionsNames.workSamples);

    var response =
        await FirebaseCrud.deleteDocument(collectionRef: collection, docId: wsId);

    return response;
  }
}
