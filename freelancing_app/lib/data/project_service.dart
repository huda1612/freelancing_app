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
}
