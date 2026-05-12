import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freelancing_platform/core/classes/firebase_crud.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/collections_names.dart';
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
}
