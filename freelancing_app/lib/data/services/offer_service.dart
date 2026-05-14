import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:freelancing_platform/core/classes/firebase_crud.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/collections_names.dart';
import 'package:freelancing_platform/models/project_collections/offer_model.dart';

class OfferService {
  OfferService({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firebaseFirestore;

  // إضافة عرض جديد
  Future<StatusClasses> addOffer({
    required OfferModel offer,
  }) async {
    final collection = _firebaseFirestore.collection(CollectionsNames.offers);

    final response = await FirebaseCrud.createDocument(
      collectionRef: collection,
      body: offer.toMap(),
    );

    return response;
  }

  // جلب كل عروض فريلانسر
  Future<Either<StatusClasses, List<OfferModel>>> getFreelancerOffers({
    required String freelancerId,
  }) async {
    final query = _firebaseFirestore
        .collection(CollectionsNames.offers)
        .where("freelancerId", isEqualTo: freelancerId)
        .orderBy("createdAt", descending: true);

    final response = await FirebaseCrud.runGetQuery<OfferModel>(
      query: query,
      fromMap: (data, id) => OfferModel.fromMap(data, id),
    );

    return response;
  }

  Future<Either<StatusClasses, List<OfferModel>>> freelancerOfferOnProject({
    required String projectId,
    required String freelancerId,
  }) async {
    final query = _firebaseFirestore
        .collection(CollectionsNames.offers)
        .where("projectId", isEqualTo: projectId)
        .where("freelancerId", isEqualTo: freelancerId)
        .limit(1);
    final res = await FirebaseCrud.runGetQuery(
        query: query, fromMap: (data, id) => OfferModel.fromMap(data, id));

    return res;
  }

  // جلب عروض مشروع معيّن
  Future<Either<StatusClasses, List<OfferModel>>> getProjectOffers({
    required String projectId,
  }) async {
    final query = _firebaseFirestore
        .collection(CollectionsNames.offers)
        .where("projectId", isEqualTo: projectId)
        .orderBy("createdAt", descending: true);

    final response = await FirebaseCrud.runGetQuery<OfferModel>(
      query: query,
      fromMap: (data, id) => OfferModel.fromMap(data, id),
    );

    return response;
  }

  // تعديل عرض
  Future<StatusClasses> updateOffer({
    required String offerId,
    required Map<String, dynamic> newData,
  }) async {
    final collection = _firebaseFirestore.collection(CollectionsNames.offers);

    final response = await FirebaseCrud.updateDocument(
      collectionRef: collection,
      docId: offerId,
      body: newData,
    );

    return response;
  }

  // حذف عرض
  Future<StatusClasses> deleteOffer({
    required String offerId,
  }) async {
    final collection = _firebaseFirestore.collection(CollectionsNames.offers);

    final response = await FirebaseCrud.deleteDocument(
      collectionRef: collection,
      docId: offerId,
    );

    return response;
  }
}
