import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:freelancing_platform/core/classes/firebase_crud.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/collections_names.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/project_status.dart';
import 'package:freelancing_platform/models/project_collections/project_model.dart';

class ProjectService {
  ProjectService({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firebaseFirestore;

  // DocumentReference<Map<String, dynamic>> projectRef(String projectId) {
  //   return _firebaseFirestore
  //       .collection(CollectionsNames.projects)
  //       .doc(projectId);
  // }

  CollectionReference<Map<String, dynamic>> get projectsCollectionRef {
    return _firebaseFirestore.collection(CollectionsNames.projects);
  }

  Future<Either<StatusClasses, ProjectModel>> getProject(
      String projectId) async {
    final docRef = projectsCollectionRef.doc(projectId);
    return FirebaseCrud.fetchDocument(
      docRef: docRef,
      fromMap: (data, id) => ProjectModel.fromMap(data, id),
    );
  }

  Future<StatusClasses> addProject(ProjectModel project) async {
    final collection = projectsCollectionRef;
    return FirebaseCrud.createDocument(
      collectionRef: collection,
      body: project.toMap(),
    );
  }

  Future<StatusClasses> updateProject(
      {required String projectId, required Map<String, dynamic> body}) async {
    final collection = projectsCollectionRef;
    return FirebaseCrud.updateDocument(
      collectionRef: collection,
      docId: projectId,
      body: body,
    );
  }

  // Future<StatusClasses> deleteNewProject(ProjectModel project) async {
  //   final transactionRes =
  //       await FirebaseCrud.runTransaction(action: (transaction) async {
  //     var doc = _firebaseFirestore
  //         .collection(CollectionsNames.projects)
  //         .doc(project.id);
  //     transaction.delete(doc);

  //     /// جلب العروض الخاصة بالمشروع
  //     final offersQuery = await _firebaseFirestore
  //         .collection(CollectionsNames.offers)
  //         .where("projectId", isEqualTo: project.id)
  //         .get();

  //     // حذف جميع العروض
  //     for (final doc in offersQuery.docs) {
  //       _firebaseFirestore.batch().delete(doc.reference);
  //     }

  //     // تنفيذ كل العمليات دفعة واحدة
  //     await _firebaseFirestore.batch().commit();
  //   });
  //   return transactionRes;
  // }

  Future<StatusClasses> deleteNewProject(ProjectModel project) async {
  return await FirebaseCrud.runBatch(
    action: (batch) async {
      // final batch = _firebaseFirestore.batch();

      final projectRef = _firebaseFirestore
          .collection(CollectionsNames.projects)
          .doc(project.id);

      final offersQuery = await _firebaseFirestore
          .collection(CollectionsNames.offers)
          .where("projectId", isEqualTo: project.id)
          .get();

      batch.delete(projectRef);

      for (final doc in offersQuery.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    },
  );
}

  Future<Either<StatusClasses, List<ProjectModel>>> getOpenProjects() async {
    final query = projectsCollectionRef.where('status',
        isEqualTo: ProjectStatus.newProject);

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

    if (justNewProjects == true) {
      query = projectsCollectionRef
          .where("clientId", isEqualTo: clientId)
          .where("status", isEqualTo: ProjectStatus.newProject);
    } else {
      query = projectsCollectionRef.where('clientId', isEqualTo: clientId);
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
      collectionRef: projectsCollectionRef,
      docId: projectId,
      body: body,
    );
  }


  /// مشاريع المستقل المقبولة مباشرة
  Future<Either<StatusClasses, List<ProjectModel>>> getFreelancerProjects({
    required String freelancerId,
  }) async {
    return await FirebaseCrud.runGetQuery<ProjectModel>(
      query: _firebaseFirestore.collection(CollectionsNames.projects).where(
            'acceptedFreelancerId',
            isEqualTo: freelancerId,
          ),
      fromMap: (data, id) => ProjectModel.fromMap(data, id),
    );
  }
 
}
