import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
// import 'package:freelancing_platform/core/classes/post_type.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
// import 'package:freelancing_platform/core/utils/helper_function/check_internet.dart';

class FirebaseCrud {
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<Either<StatusClasses, List<T>>> runGetQuery<T>({
    required Query<Map<String, dynamic>> query,
    required T Function(Map<String, dynamic>, String) fromMap,
  }) async {
    // if (await checkInternet()) {
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
    // } else {
    //   return Left(StatusClasses.offlineError);
    // }
  }


  //****************************how to use******************************************************
//   final query = FirebaseFirestore.instance
//     .collection("requests")
//     .where("status", isEqualTo: "pending");

// final result = await firebaseCrud.runQuery<RequestModel>(
//   query: query,
//   fromMap: (data, id) => RequestModel.fromMap(data, id),
// );
//ملاحظة : لو تابع fromMap عندي اله برامتر واحد فيني استخدمه هيك
// final result = await runGetQuery<SpecializationModel>(query: query, fromMap: (data, id) {
//     return SpecializationModel.fromMap(data);
//   },);


//مثال كامل عن التنفيذ
// Future<void> loadData() async {
//   status = StatusClasses.isloading;
//   update();

//   final result = await runGetQuery(...);

//   result.fold(
//     (error) {
//       status = error;
//     },
//     (data) {
//       myList = data;
//       status = StatusClasses.success;
//     },
//   );

//   update();
// }
  //**********************************************************************************************

  static Future<Either<StatusClasses, T>> fetchDocument<T>({
    required DocumentReference<Map<String, dynamic>> docRef,
    required T Function(Map<String, dynamic>, String) fromMap,
  }) async {
    // if (await checkInternet()) {
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
    // } else {
    //   return Left(StatusClasses.offlineError);
    // }
  }
  //how to use
//   final docRef = FirebaseFirestore.instance
//     .collection("Users")
//     .doc(uid);

// final result = await firebaseCrud.runDocument<UserModel>(
//   docRef: docRef,
//   fromMap: (data, id) => UserModel.fromMap(data, id),
// );

//بحال النجاح بعرض رسالة نجاح وبحال الخطأ بعرض رسالة الخطأ

//اضافة مستند
  static Future<StatusClasses> createDocument({
    required CollectionReference<Map<String, dynamic>> collectionRef,
    String? docId,
    required Map<String, dynamic> body,
  }) async {
    try {
      if (body.isEmpty) {
        return StatusClasses.invalidData;
      }

      if (docId == null) {
        await collectionRef.add(body);
      } else {
        await collectionRef.doc(docId).set(
              body,
              SetOptions(merge: true),
            );
      }

      return StatusClasses.success;
    } on FirebaseException catch (e) {
      return mapFirestoreError(e);
    } catch (e) {
      return StatusClasses.customError(e.toString());
    }
  }

//تحديث مستند
  static Future<StatusClasses> updateDocument({
    required CollectionReference<Map<String, dynamic>> collection,
    required String docId,
    required Map<String, dynamic> body,
  }) async {
    try {
      // if (body.isEmpty) {
      //   return StatusClasses.invalidData;
      // }

      await collection.doc(docId).update(body);

      return StatusClasses.success;
    } on FirebaseException catch (e) {
      return mapFirestoreError(e);
    } catch (e) {
      return StatusClasses.customError(e.toString());
    }
  }

//حذف مستند
  static Future<StatusClasses> deleteDocument({
    required CollectionReference<Map<String, dynamic>> collection,
    required String docId,
  }) async {
    try {
      await collection.doc(docId).delete();

      return StatusClasses.success;
    } on FirebaseException catch (e) {
      return mapFirestoreError(e);
    } catch (e) {
      return StatusClasses.customError(e.toString());
    }
  }
}

StatusClasses mapFirestoreError(FirebaseException e) {
  switch (e.code) {
    case 'unavailable':
    case 'deadline-exceeded':
    case 'network-request-failed':
      return StatusClasses.offlineError;

    case 'permission-denied':
      return StatusClasses.permissionDenied;

    // case 'unavailable':
    //   return StatusClasses.unavailable;
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

// Future<StatusClasses> postFirebaseData({
//   required CollectionReference<Map<String, dynamic>> collection,
//   required PostType type,
//   String? docId,
//   Map<String, dynamic>? body,
// }) async {
//   if (await checkInternet()) {
//     try {
//       //لو النوع ما حذف فلازم اتأكد ان في جسم للطلب
//       if (body == null && type != PostType.delete) {
//         return StatusClasses.invalidData;
//       }

//       //لو كان تحديث او حذف فلازم يعطيني رقم المستند
//       if (docId == null &&
//           (type == PostType.update || type == PostType.delete)) {
//         return StatusClasses.invalidData;
//       }

//       //التصرف حسب نوع العملية
//       switch (type) {
//         case PostType.add:
//           // await _firestore.collection(path).add(body!);
//           //لو ما مدخل رقم فبضيفه عادي وبيتولد الرقم لحاله اما لو مدخل رقم فبضيفه بهالرقم
//           docId == null
//               ? await collection.add(body!)
//               : await collection
//                   .doc(docId)
//                   .set(body!, SetOptions(merge: true));
//           break;
//         case PostType.update:
//           // await _firestore.collection(path).doc(docId).update(body!);
//           await collection.doc(docId).update(body!);
//           break;
//         case PostType.delete:
//           // await _firestore.collection(path).doc(docId).delete();
//           await collection.doc(docId).delete();
//           break;
//       }
//       return StatusClasses.success;
//     } on FirebaseException catch (e) {
//       return mapFirestoreError(e);
//     } catch (e) {
//       return StatusClasses.customError(e.toString());
//     }
//   } else {
//     return StatusClasses.offlineError;
//   }
// }
