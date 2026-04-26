import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freelancing_platform/core/classes/firebase_crud.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/constants/collections_names.dart';
import 'package:freelancing_platform/models/user_collections/certificate_model.dart';

class CertificateService {
  CertificateService({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firebaseFirestore;



  //اضافة شهادة جديده
  Future<StatusClasses> addCertificate({
    required String uid,
    required CertificateModel certificate,
  }) async {
    var collection = _firebaseFirestore
        .collection(CollectionsNames.users)
        .doc(uid)
        .collection(CollectionsNames.certificate);

    var requestBody = certificate.toMap();

    var response = await FirebaseCrud.createDocument(
        collectionRef: collection, body: requestBody);

    return response;
  }


  //حذف شهادة
  // Future<StatusClasses> deleteWorkSample({required String uId , required String wsId }) async {
  //   var collection =
  //       _firebaseFirestore.collection(CollectionsNames.users).doc(uId).collection(CollectionsNames.workSamples);

  //   var response =
  //       await FirebaseCrud.deleteDocument(collectionRef: collection, docId: wsId);

  //   return response;
  // }
}
