import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:freelancing_platform/core/classes/post_type.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';

class FirebaseCrud {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Either<StatusClasses, List<T>>> runQuery<T>({
    required Query<Map<String, dynamic>> query,
    required T Function(Map<String, dynamic>, String) fromMap,
  }) async {
    if (await checkInternet()) {
      try {
        final snapshot = await query.get();

        final data = snapshot.docs.map((doc) {
          return fromMap(doc.data(), doc.id);
        }).toList();

        return Right(data);
      } on FirebaseException catch (e) {
        return Left(mapFirestoreError(e));
      } catch (e) {
        return Left(StatusClasses.customError(e.toString()));
      }
    } else {
      return Left(StatusClasses.offlineError);
    }
  }
  //how to use
//   final query = FirebaseFirestore.instance
//     .collection("requests")
//     .where("status", isEqualTo: "pending");

// final result = await firebaseCrud.runQuery<RequestModel>(
//   query: query,
//   fromMap: (data, id) => RequestModel.fromMap(data, id),
// );

  Future<Either<StatusClasses, T>> fetchDocument<T>({
    required DocumentReference<Map<String, dynamic>> docRef,
    required T Function(Map<String, dynamic>, String) fromMap,
  }) async {
    if (await checkInternet()) {
      try {
        final doc = await docRef.get();

        if (!doc.exists) {
          return Left(StatusClasses.notFound);
        }

        return Right(fromMap(doc.data()!, doc.id));
      } on FirebaseException catch (e) {
        return Left(mapFirestoreError(e));
      } catch (e) {
        return Left(StatusClasses.customError(e.toString()));
      }
    } else {
      return Left(StatusClasses.offlineError);
    }
  }
  //how to use
//   final docRef = FirebaseFirestore.instance
//     .collection("Users")
//     .doc(uid);

// final result = await firebaseCrud.runDocument<UserModel>(
//   docRef: docRef,
//   fromMap: (data, id) => UserModel.fromMap(data, id),
// );

  Future<StatusClasses> postFirebaseData({
    required String path,
    required PostType type,
    String? docId,
    Map<String, dynamic>? body,
  }) async {
    if (await checkInternet()) {
      try {
        switch (type) {
          case PostType.add:
            await _firestore.collection(path).add(body!);
            break;
          case PostType.update:
            await _firestore.collection(path).doc(docId).update(body!);
            break;
          case PostType.delete:
            await _firestore.collection(path).doc(docId).delete();
            break;
        }
        return StatusClasses.success;
      } on FirebaseException catch (e) {
        return mapFirestoreError(e);
      } catch (e) {
        return StatusClasses.customError(e.toString());
      }
    } else {
      return StatusClasses.offlineError;
    }
  }
}
//بحال النجاح بعرض رسالة نجاح وبحال الخطأ بعرض رسالة الخطأ

StatusClasses mapFirestoreError(FirebaseException e) {
  switch (e.code) {
    case 'permission-denied':
      return StatusClasses.permissionDenied;
    case 'unavailable':
      return StatusClasses.unavailable;
    case 'not-found':
      return StatusClasses.notFound;
    case 'failed-precondition':
      return StatusClasses.indexRequired;
    case 'invalid-argument':
      return StatusClasses.invalidData;
    default:
      return StatusClasses.unknown;
  }
}
