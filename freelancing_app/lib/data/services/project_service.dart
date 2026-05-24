import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:freelancing_platform/core/classes/firebase_crud.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/collections_names.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/offer_status.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/project_status.dart';
import 'package:freelancing_platform/data/services/offer_service.dart';
import 'package:freelancing_platform/models/project_collections/offer_model.dart';
import 'package:freelancing_platform/models/project_collections/project_model.dart';

class ProjectService {
  ProjectService({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firebaseFirestore;

  Future<Either<StatusClasses, ProjectModel>> getProject(
      String projectId) async {
    final docRef =
        _firebaseFirestore.collection(CollectionsNames.projects).doc(projectId);
    return FirebaseCrud.fetchDocument(
      docRef: docRef,
      fromMap: (data, id) => ProjectModel.fromMap(data, id),
    );
  }

  Future<StatusClasses> addProject(ProjectModel project) async {
    final collection = _firebaseFirestore.collection(CollectionsNames.projects);
    return FirebaseCrud.createDocument(
      collectionRef: collection,
      body: project.toMap(),
    );
  }

  Future<StatusClasses> deleteProject(ProjectModel project) async {
    final transactionRes =
        await FirebaseCrud.runTransaction(action: (transaction) async {
      var doc = _firebaseFirestore
          .collection(CollectionsNames.projects)
          .doc(project.id);
      transaction.delete(doc);

      /// جلب العروض الخاصة بالمشروع
      final offersQuery = await _firebaseFirestore
          .collection(CollectionsNames.offers)
          .where("projectId", isEqualTo: project.id)
          .get();

      // حذف جميع العروض
      for (final doc in offersQuery.docs) {
        _firebaseFirestore.batch().delete(doc.reference);
      }

      // تنفيذ كل العمليات دفعة واحدة
      await _firebaseFirestore.batch().commit();
    });
    return transactionRes;
  }

  Future<Either<StatusClasses, List<ProjectModel>>> getOpenProjects() async {
    final query = _firebaseFirestore
        .collection(CollectionsNames.projects)
        .where('status', isEqualTo: ProjectStatus.newProject);

    return FirebaseCrud.runGetQuery<ProjectModel>(
      query: query,
      fromMap: (data, id) => ProjectModel.fromMap(data, id),
    );
  }
  //*************************************************** */
  //اضافات جديدية

  /// كل مشاريع العميل (تُصفّى حسب الحالة في الواجهة).
  //ok
  Future<Either<StatusClasses, List<ProjectModel>>> getClientProjects(
      {required String clientId, bool justNewProjects = false}) async {
    Query<Map<String, dynamic>> query;
    // final query = _firebaseFirestore
    //     .collection(CollectionsNames.projects)
    //     .where('clientId', isEqualTo: clientId);

    if (justNewProjects == true) {
      query = _firebaseFirestore
          .collection(CollectionsNames.projects)
          .where("clientId", isEqualTo: clientId)
          .where("status", isEqualTo: ProjectStatus.newProject);
    } else {
      query = _firebaseFirestore
          .collection(CollectionsNames.projects)
          .where('clientId', isEqualTo: clientId);
    }
    return await FirebaseCrud.runGetQuery<ProjectModel>(
      query: query,
      fromMap: (data, id) => ProjectModel.fromMap(data, id),
    );
  }

  Future<StatusClasses> updateProjectStatus({
    required String projectId,
    required String status,
    String? acceptedOfferId,
  }) async {
    final body = <String, dynamic>{
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    };
    if (acceptedOfferId != null) {
      body['acceptedOfferId'] = acceptedOfferId;
    }

    return FirebaseCrud.updateDocument(
      collectionRef: _firebaseFirestore.collection(CollectionsNames.projects),
      docId: projectId,
      body: body,
    );
  }

  Future<StatusClasses> republishProject(String projectId) {
    return updateProjectStatus(
      projectId: projectId,
      status: ProjectStatus.newProject,
    );
  }

  //جديدة

  /// مشاريع المستقل (حيث عرضه مقبولاً على المشروع).
  Future<Either<StatusClasses, List<ProjectModel>>> getFreelancerProjects({
    required String freelancerId,
  }) async {
    final offersRes = await OfferService().getFreelancerOffers(
      freelancerId: freelancerId,
    );

    if (offersRes.isLeft()) {
      return Left(
          offersRes.fold((l) => l, (_) => StatusClasses.customError('')));
    }

    final offers = offersRes.getOrElse(() => <OfferModel>[]);
    final accepted =
        offers.where((o) => o.status == OfferStatus.accepted).toList();
    if (accepted.isEmpty) {
      return Right(<ProjectModel>[]);
    }

    final collection = _firebaseFirestore.collection(CollectionsNames.projects);

    final snapshots = await Future.wait(
      accepted.map((offer) => collection.doc(offer.projectId).get()),
    );

    final projects = <ProjectModel>[];
    for (var i = 0; i < accepted.length; i++) {
      final doc = snapshots[i];
      if (!doc.exists || doc.data() == null) continue;

      final project = ProjectModel.fromMap(doc.data()!, doc.id);
      final offer = accepted[i];
      if (project.acceptedOfferId == null ||
          project.acceptedOfferId == offer.id) {
        projects.add(project);
      }
    }

    return Right(List<ProjectModel>.from(projects));
  }
}
