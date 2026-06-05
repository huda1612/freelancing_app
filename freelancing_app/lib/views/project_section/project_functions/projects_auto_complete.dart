import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freelancing_platform/core/classes/firebase_crud.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/collections_names.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/project_status.dart';
import 'package:freelancing_platform/models/project_collections/project_model.dart';

///تابع لانهاء المشاريع المنتهيه من اكثر من 3 ايام بشكل تلقائي
///برد لو صار حذف ولا ما صار
Future<List<String>> autoCompleteProjects(List<ProjectModel> projects) async {
  final expiredProjects = projects.where((p) {
    return p.status == ProjectStatus.readyToComplete &&
        _isAutoCompleteExpired(p);
  }).toList();

  if (expiredProjects.isEmpty) return [];

  final firestore = FirebaseFirestore.instance;

  final res = await FirebaseCrud.runTransaction(
    action: (transaction) async {
      for (final project in expiredProjects) {
        final projectRef =
            firestore.collection(CollectionsNames.projects).doc(project.id);

        final snapshot = await transaction.get(projectRef);

        final currentStatus = snapshot['status'];

        // إذا تغيرت الحالة لا تكمل(مشان اذا ال2 دخلوا عالصفحه)
        if (currentStatus != ProjectStatus.readyToComplete) {
          continue;
        }

        transaction.update(projectRef, {
          'status': ProjectStatus.completed,
          'endAt': FieldValue.serverTimestamp(),
        });

        transaction.update(
          firestore.collection(CollectionsNames.users).doc(project.clientId),
          {
            'completed_projects': FieldValue.increment(1),
          },
        );

        if (project.acceptedFreelancerId != null) {
          transaction.update(
            firestore
                .collection(CollectionsNames.users)
                .doc(project.acceptedFreelancerId!),
            {
              'completed_projects': FieldValue.increment(1),
            },
          );
        }
      }
    },
  );
  if (res != StatusClasses.success) {
    return [];
  }
  return expiredProjects.map((p) => p.id).toList();
}

bool _isAutoCompleteExpired(ProjectModel project) {
  if (project.allTasksCompletedAt == null) return false;

  final completedAt = project.allTasksCompletedAt!.toDate();
  final deadline = completedAt.add(const Duration(days: 3));

  return DateTime.now().isAfter(deadline);
}
