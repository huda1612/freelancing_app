import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:freelancing_platform/core/classes/firebase_crud.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/collections_names.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/project_status.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/task_status.dart';
import 'package:freelancing_platform/models/project_collections/project_task_progress.dart';
import 'package:freelancing_platform/models/project_collections/task_model.dart';

// كله بده تعديل
class ProjectTaskService {
  ProjectTaskService({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firebaseFirestore;

  CollectionReference<Map<String, dynamic>> tasksRef(String projectId) {
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
      final done = list
          .where((t) => t.status == TaskStatus.completedByFreelancer)
          .length;
      return ProjectTaskProgress(done: done, total: list.length);
    });
  }

  Future<StatusClasses> sendSetupTasks(
      {required String projectId, required List<TaskModel> setupTasks}) async {
    final collectionRef = tasksRef(projectId);

    final projectRef =
        _firebaseFirestore.collection(CollectionsNames.projects).doc(projectId);
    final oldTasksSnapshot = await collectionRef.get();

    return await FirebaseCrud.runBatch(action: (batch) async {
      // 1. delete old tasks
      for (final doc in oldTasksSnapshot.docs) {
        batch.delete(doc.reference);
      }

      // 2. add new tasks
      for (final task in setupTasks) {
        final docRef = collectionRef.doc();

        batch.set(docRef, task.toMap());
      }
      // final projectRef = _firebaseFirestore
      //     .collection(CollectionsNames.projects)
      //     .doc(projectId);

      batch.update(projectRef, {
        'status': ProjectStatus.waitingTasksApproval,
      });
    });
  }

//ok
  Future<Either<StatusClasses, List<TaskModel>>> getTasks({
    required String projectId,
  }) async {
    final query = tasksRef(projectId).orderBy('createdAt', descending: false);
    return FirebaseCrud.runGetQuery<TaskModel>(
      query: query,
      fromMap: (data, id) => TaskModel.fromMap(data, id),
    );
  }

//ok
  Future<StatusClasses> addTask({
    required String projectId,
    required String description,
    required double amount,
    bool isExtra = false,
    String? requestedBy,
  }) async {
    final collectionRef = tasksRef(projectId);
    final newTask = TaskModel(
        id: '',
        description: description,
        amount: amount,
        isExtra: isExtra,
        requestedBy: requestedBy,
        status: isExtra ? TaskStatus.requested : TaskStatus.pending);
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
      collectionRef: tasksRef(projectId),
      docId: taskId,
      body: data,
    );
  }

  Future<StatusClasses> deleteTask({
    required String projectId,
    required String taskId,
  }) async {
    return FirebaseCrud.deleteDocument(
      collectionRef: tasksRef(projectId),
      docId: taskId,
    );
  }
}
