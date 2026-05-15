import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:freelancing_platform/core/classes/firebase_crud.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/collections_names.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/offer_status.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/project_status.dart';
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

  // Future<Either<StatusClasses, List<OfferModel>>> freelancerOfferOnProject({
  //   required String projectId,
  //   required String freelancerId,
  // }) async {
  //   final query = _firebaseFirestore
  //       .collection(CollectionsNames.offers)
  //       .where("projectId", isEqualTo: projectId)
  //       .where("freelancerId", isEqualTo: freelancerId)
  //       .limit(1);
  //   final res = await FirebaseCrud.runGetQuery(
  //       query: query, fromMap: (data, id) => OfferModel.fromMap(data, id));

  //   return res;
  // }
  /// استعلام واحد بـ [projectId] فقط لتفادي الفهرس المركّب؛ ثم تصفية بالذاكرة.
  Future<Either<StatusClasses, List<OfferModel>>> freelancerOfferOnProject({
    required String projectId,
    required String freelancerId,
  }) async {
    final query = _firebaseFirestore
        .collection(CollectionsNames.offers)
        .where("projectId", isEqualTo: projectId);

    final res = await FirebaseCrud.runGetQuery(
      query: query,
      fromMap: (data, id) => OfferModel.fromMap(data, id),
    );

    return res.map((list) {
      final mine = list.where((o) => o.freelancerId == freelancerId).toList();
      _sortOffersByCreatedAtDesc(mine);
      if (mine.isEmpty) return <OfferModel>[];
      return [mine.first];
    });
  }

  // جلب عروض مشروع معيّن
  // Future<Either<StatusClasses, List<OfferModel>>> getProjectOffers({
  //   required String projectId,
  // }) async {
  //   final query = _firebaseFirestore
  //       .collection(CollectionsNames.offers)
  //       .where("projectId", isEqualTo: projectId)
  //       .orderBy("createdAt", descending: true);

  //   final response = await FirebaseCrud.runGetQuery<OfferModel>(
  //     query: query,
  //     fromMap: (data, id) => OfferModel.fromMap(data, id),
  //   );

  //   return response;
  // }
  // جلب عروض مشروع معيّن
  Future<Either<StatusClasses, List<OfferModel>>> getProjectOffers(
      {required String projectId, bool? justPendingOffers}) async {
    var query;
    if (justPendingOffers != null && justPendingOffers == true) {
      query = _firebaseFirestore
          .collection(CollectionsNames.offers)
          .where("projectId", isEqualTo: projectId)
          .where("status", isEqualTo: OfferStatus.pending);
    } else {
      query = _firebaseFirestore
          .collection(CollectionsNames.offers)
          .where("projectId", isEqualTo: projectId);
    }
    final response = await FirebaseCrud.runGetQuery<OfferModel>(
      query: query,
      fromMap: (data, id) => OfferModel.fromMap(data, id),
    );

    return response.map((list) {
      _sortOffersByCreatedAtDesc(list);
      return list;
    });
  }

  static void _sortOffersByCreatedAtDesc(List<OfferModel> offers) {
    offers.sort((a, b) {
      final ca = a.createdAt;
      final cb = b.createdAt;
      if (ca == null && cb == null) return 0;
      if (ca == null) return 1;
      if (cb == null) return -1;
      return cb.compareTo(ca);
    });
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

  /// قبول عرض معيّن ورفض باقي العروض المعلقة على نفس المشروع تلقائياً.
  Future<StatusClasses> acceptOfferAndRejectOthers({
    required String projectId,
    required String acceptedOfferId,
  }) async {
    try {
      final query = _firebaseFirestore
          .collection(CollectionsNames.offers)
          .where('projectId', isEqualTo: projectId);

      final snapshot = await query.get();
      if (snapshot.docs.isEmpty) {
        return StatusClasses.notFound;
      }
      final hasAccepted = snapshot.docs.any((doc) => doc.id == acceptedOfferId);
      if (!hasAccepted) {
        return StatusClasses.notFound;
      }

      final batch = _firebaseFirestore.batch();
      final ts = FieldValue.serverTimestamp();

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final statusRaw = data['status'];
        if (doc.id == acceptedOfferId) {
          batch.update(doc.reference, {
            'status': OfferStatus.accepted,
            'updatedAt': ts,
          });
        } else if (_isPendingOfferStatus(statusRaw)) {
          batch.update(doc.reference, {
            'status': OfferStatus.rejected,
            'updatedAt': ts,
          });
        }
      }

      await batch.commit();
      return StatusClasses.success;
    } on FirebaseException catch (e) {
      return mapFirestoreError(e);
    } catch (e) {
      return StatusClasses.customError(e.toString());
    }
  }

  Future<StatusClasses> setOfferStatus({
    required String offerId,
    required String status,
  }) async {
    return updateOffer(
      offerId: offerId,
      newData: {
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      },
    );
  }

  bool _isPendingOfferStatus(dynamic raw) {
    final s = raw?.toString() ?? '';
    if (s.isEmpty || s == ProjectStatus.newProject) return true;
    return s == OfferStatus.pending;
  }
}
