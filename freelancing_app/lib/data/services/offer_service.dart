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
        .where("freelancerId", isEqualTo: freelancerId);

    final response = await FirebaseCrud.runGetQuery<OfferModel>(
      query: query,
      fromMap: (data, id) => OfferModel.fromMap(data, id),
    );
    return response.map((list) {
      _sortOffersByCreatedAtDesc(list);
      return list;
    });
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
      {required String projectId, bool justPendingOffers = false}) async {
    Query<Map<String, dynamic>> query;
    if (justPendingOffers == true) {
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
  // Future<StatusClasses> acceptOfferAndRejectOthers({
  //   required String projectId,
  //   required String acceptedOfferId,
  //   required String acceptedFreelancerId,
  // }) async {
  //   try {
  //     //جلب العروض للمشروع كلها
  //     final query = _firebaseFirestore
  //         .collection(CollectionsNames.offers)
  //         .where('projectId', isEqualTo: projectId);
  //     final offersResponse = await FirebaseCrud.runGetQuery(
  //         query: query, fromMap: (data, id) => OfferModel.fromMap(data, id));
  //     // final snapshot = await query.get();
  //     return offersResponse.fold((err) {
  //       return err;
  //     }, (offers) {
  //       //هون لازم حدث حاله المشروع ورقم الفريلانسر اللي انقبل

  //       //اذا مافي اي عروض عالمشروع
  //       if (offers.isEmpty) {
  //         return StatusClasses.notFound;
  //       }

  //       //اذا رقم العرض المقبول ما موجود اصلا
  //       final hasAccepted = offers.any((offer) => offer.id == acceptedOfferId);
  //       if (!hasAccepted) {
  //         return StatusClasses.notFound;
  //       }
  //       final res = FirebaseCrud.runTransaction(action: (transiction) async{

  //       });
  //       final response = FirebaseCrud.runBatch(action: (batch) {
  //         final ts = FieldValue.serverTimestamp();

  //         for (final offer in offers) {
  //           // final data = doc.data();
  //           final statusRaw = offer.status;
  //           if (offer.id == acceptedOfferId) {
  //             final docRef = _firebaseFirestore
  //                 .collection(CollectionsNames.offers)
  //                 .doc(offer.id);
  //             batch.update(docRef, {
  //               'status': OfferStatus.accepted,
  //               'updatedAt': ts,
  //             });
  //           } else if (_isPendingOfferStatus(statusRaw)) {
  //             batch.update(doc.reference, {
  //               'status': OfferStatus.rejected,
  //               'updatedAt': ts,
  //             });
  //           }
  //         }
  //       });
  //       // final batch = _firebaseFirestore.batch();

  //       // await batch.commit();
  //       return StatusClasses.success;
  //     });
  //   } on FirebaseException catch (e) {
  //     return mapFirestoreError(e);
  //   } catch (e) {
  //     return StatusClasses.customError(e.toString());
  //   }
  // }

  /// قبول عرض معيّن ورفض باقي العروض المعلقة على نفس المشروع تلقائياً.
  Future<StatusClasses> acceptOfferAndRejectOthers({
    required String projectId,
    required String acceptedOfferId,
    required String acceptedFreelancerId,
  }) async {
    // try {
    final offersQuery = _firebaseFirestore
        .collection(CollectionsNames.offers)
        .where('projectId', isEqualTo: projectId);

    final offersResponse = await FirebaseCrud.runGetQuery(
      query: offersQuery,
      fromMap: (data, id) => OfferModel.fromMap(data, id),
    );

    return await offersResponse.fold(
      (err) async => err,
      (offers) async {
        /// اذا مافي عروض
        if (offers.isEmpty) {
          return StatusClasses.notFound;
        }

        /// اذا العرض المطلوب مو موجود
        final hasAccepted = offers.any((offer) => offer.id == acceptedOfferId);

        if (!hasAccepted) {
          return StatusClasses.notFound;
        }

        final response = await FirebaseCrud.runTransaction(
          action: (transaction) async {
            /// مرجع المشروع
            final projectRef = _firebaseFirestore
                .collection(CollectionsNames.projects)
                .doc(projectId);
            final projectSnap = await transaction.get(projectRef);

            if (!projectSnap.exists) {
              throw Exception("Project not found");
            }

            final data = projectSnap.data() as Map<String, dynamic>;
            final currentStatus = data['status']?.toString();
            if (currentStatus != ProjectStatus.newProject) {
              throw Exception("Project already accepted");
            }
            final ts = FieldValue.serverTimestamp();

            /// تحديث المشروع
            transaction.update(projectRef, {
              'status': ProjectStatus.setup,
              'acceptedFreelancerId': acceptedFreelancerId,
              'acceptedOfferId': acceptedOfferId,
              'updatedAt': ts,
            });

            /// تحديث العروض
            for (final offer in offers) {
              final offerRef = _firebaseFirestore
                  .collection(CollectionsNames.offers)
                  .doc(offer.id);

              /// قبول العرض المحدد
              if (offer.id == acceptedOfferId) {
                transaction.update(offerRef, {
                  'status': OfferStatus.accepted,
                  'updatedAt': ts,
                });
              }

              /// رفض باقي العروض المعلقة فقط
              else if (_isPendingOfferStatus(offer.status)) {
                transaction.update(offerRef, {
                  'status': OfferStatus.rejected,
                  'updatedAt': ts,
                });
              }
            }
          },
        );

        return response;
      },
    );
    // } on FirebaseException catch (e) {
    //   return mapFirestoreError(e);
    // } catch (e) {
    //   return StatusClasses.customError(e.toString());
    // }
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

  ///تابع مساعد هدفه يتحقق إذا حالة العرض تعتبر "معلقة" أو لا
  bool _isPendingOfferStatus(dynamic raw) {
    final s = raw?.toString() ?? '';
    if (s.isEmpty || s == ProjectStatus.newProject) return true;
    return s == OfferStatus.pending;
  }

  /// العرض المقبول على مشروع معيّن (إن وُجد).
  Future<Either<StatusClasses, OfferModel>> getAcceptedOfferForProject({
    required String acceptedOfferId,
  }) async {
    // if (acceptedOfferId != null && acceptedOfferId.isNotEmpty) {
    final docRef = _firebaseFirestore
        .collection(CollectionsNames.offers)
        .doc(acceptedOfferId);
    final offerRes = FirebaseCrud.fetchDocument(
        docRef: docRef, fromMap: (map, id) => OfferModel.fromMap(map, id));
    return offerRes;
  }
}
