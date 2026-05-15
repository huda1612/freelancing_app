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

  Future<StatusClasses> addProject(ProjectModel project) async {
    final collection = _firebaseFirestore.collection(CollectionsNames.projects);
    return FirebaseCrud.createDocument(
      collectionRef: collection,
      body: project.toMap(),
    );
  }

  Future<StatusClasses> deleteProject(ProjectModel project) async {
    final transactionRes =
        await FirebaseCrud.runTransaction(action: (transaction)async{
          var doc = _firebaseFirestore.collection(CollectionsNames.projects).doc(project.id);
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
  Future<Either<StatusClasses, List<ProjectModel>>> getClientProjects({
    required String clientId,
  }) async {
    final query = _firebaseFirestore
        .collection(CollectionsNames.projects)
        .where('clientId', isEqualTo: clientId);

    return FirebaseCrud.runGetQuery<ProjectModel>(
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
      collectionRef:
          _firebaseFirestore.collection(CollectionsNames.projects),
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
}


