import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
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

  Future<Either<StatusClasses, List<CertificateModel>>> getAllUserCertificate({
    required String uid,
  }) async {
    var query = _firebaseFirestore
        .collection(CollectionsNames.users)
        .doc(uid)
        .collection(CollectionsNames.certificate)
        .orderBy('createdAt', descending: true);
    var response = await FirebaseCrud.runGetQuery<CertificateModel>(
        query: query,
        fromMap: (data, id) => CertificateModel.fromMap(data, id));
    return response;
  }

  Future<StatusClasses> updateCertificate(
      {required Map<String, dynamic> newData,
      required String uid,
      required String cID}) async {
    final collection = _firebaseFirestore
        .collection(CollectionsNames.users)
        .doc(uid)
        .collection(CollectionsNames.certificate);
    final StatusClasses response = await FirebaseCrud.updateDocument(
        collectionRef: collection, docId: cID, body: newData);
    return response;
  }

  //حذف 
  Future<StatusClasses> deleteCertificate(
      {required String uId, required String cId}) async {
    var collection = _firebaseFirestore
        .collection(CollectionsNames.users)
        .doc(uId)
        .collection(CollectionsNames.certificate);

    var response = await FirebaseCrud.deleteDocument(
        collectionRef: collection, docId: cId);

    return response;
  }

  
}
