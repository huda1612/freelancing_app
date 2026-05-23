import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:freelancing_platform/core/classes/firebase_crud.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/collections_names.dart';
import 'package:freelancing_platform/models/project_collections/project_task_progress.dart';
import 'package:freelancing_platform/models/project_collections/task_model.dart';

// كله بده تعديل
class ProjectTaskService {
  ProjectTaskService({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firebaseFirestore;

  CollectionReference<Map<String, dynamic>> _tasksRef(String projectId) {
    return _firebaseFirestore
        .collection(CollectionsNames.projects)
        .doc(projectId)
        .collection(CollectionsNames.projectTasks);
  }

  Future<Either<StatusClasses, ProjectTaskProgress>> getTaskProgress({
    required String projectId,
  }) async {
    final res = await getTasks(projectId: projectId);
    return res.map((list) {
      final done = list.where((t) => t.isDone).length;
      return ProjectTaskProgress(done: done, total: list.length);
    });
  }

//ok
  Future<Either<StatusClasses, List<TaskModel>>> getTasks({
    required String projectId,
  }) async {
    final query = _tasksRef(projectId).orderBy('createdAt', descending: false);
    return FirebaseCrud.runGetQuery<TaskModel>(
      query: query,
      fromMap: (data, id) => TaskModel.fromMap(data, id),
    );
  }

//ok
  Future<StatusClasses> addTask({
    required String projectId,
    required String description,
  }) async {
    final collectionRef = _tasksRef(projectId);
    final newTask = TaskModel(id: '', description: description);
    final response = await FirebaseCrud.createDocument(
        collectionRef: collectionRef, body: newTask.toMap());
    return response;
  }

  Future<StatusClasses> updateTask({
    required String projectId,
    required String taskId,
    required Map<String, dynamic> data,
  }) async {
    return FirebaseCrud.updateDocument(
      collectionRef: _tasksRef(projectId),
      docId: taskId,
      body: data,
    );
  }

  Future<StatusClasses> deleteTask({
    required String projectId,
    required String taskId,
  }) async {
    return FirebaseCrud.deleteDocument(
      collectionRef: _tasksRef(projectId),
      docId: taskId,
    );
  }
}
