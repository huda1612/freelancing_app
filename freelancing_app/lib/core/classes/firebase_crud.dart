import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
// import 'package:freelancing_platform/core/utils/helper_function/check_internet.dart';

//كأني ما عالجت حاله عدم تسجيل الدخول بالunauthrized !!!!!!!!!!!!!!!!
//الا لو بس خلص رح اعتمد عالmiddleware
//ممكن وحده نسخه الfirebasefirestore بس بهالحاله لازم احقنها واعمل تابع تهيئه الها !!!!!!!!!!!!!!!!!!!!!

//لاستخدمه
// final crud = Get.find<FirebaseCrud>();
class FirebaseCrud {
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<Either<StatusClasses, List<T>>> runGetQuery<T>({
    required Query<Map<String, dynamic>> query,
    required T Function(Map<String, dynamic>, String) fromMap,
  }) async {
    // if (await checkInternet()) {
    try {
      final snapshot = await query.get();

      //لو البيانات كانت من الكاش ومافي بيانات يعني فاضيه فيعني مافي نت
      //هي مشان ما نلغي دعم الاوف لاين ويقدر يجيب بيانات من الكاش وبنفس الوقت لو مافي شي بالكاش نطلعله ان مافي نت
      if (snapshot.metadata.isFromCache && snapshot.docs.isEmpty) {
        return Left(StatusClasses.offlineError);
      }

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

      // print("4444444444444444444444${doc.id}");
      return Right(fromMap(doc.data()!, doc.id));
    } on FirebaseException catch (e) {
      print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!$e");
      return Left(mapFirestoreError(e));
    } catch (e) {
      print("!!!!!!!!!!!!7687687!!!!!!!!!!!!!!!!!!!$e");

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
    required CollectionReference<Map<String, dynamic>> collectionRef,
    required String docId,
    required Map<String, dynamic> body,
  }) async {
    try {
      // if (body.isEmpty) {
      //   return StatusClasses.invalidData;
      // }

      await collectionRef.doc(docId).update(body);

      return StatusClasses.success;
    } on FirebaseException catch (e) {
      return mapFirestoreError(e);
    } catch (e) {
      return StatusClasses.customError(e.toString());
    }
  }

//حذف مستند
  static Future<StatusClasses> deleteDocument({
    required CollectionReference<Map<String, dynamic>> collectionRef,
    required String docId,
  }) async {
    try {
      await collectionRef.doc(docId).delete();

      return StatusClasses.success;
    } on FirebaseException catch (e) {
      return mapFirestoreError(e);
    } catch (e) {
      return StatusClasses.customError(e.toString());
    }
  }

  // ملاحظة : هذا التابع يحذف المستوى الأول فقط
  static Future<StatusClasses> deleteDocumentWithChildren(
      {required DocumentReference<Map<String, dynamic>> docRef,
      required List<String> subCollections}) async {
    try {
      final firestore = FirebaseFirestore.instance;
      //لان في خد للعمليات الممكن تنفيذها بالbatchالواحد بس 500 واقل
      const int batchLimit = 500;

      for (final sub in subCollections) {
        final snapshot = await docRef.collection(sub).get();

        if (snapshot.docs.isEmpty) continue;

        for (int i = 0; i < snapshot.docs.length; i += batchLimit) {
          final batch = firestore.batch();

          final chunk = snapshot.docs.skip(i).take(batchLimit).toList();

          for (var doc in chunk) {
            batch.delete(doc.reference);
          }

          await batch.commit();
        }
      }
      // for (final sub in subCollections) {
      //   final snapshot = await docRef.collection(sub).get();
      //   if (snapshot.docs.isEmpty) continue;
      //   final batch = FirebaseFirestore.instance.batch();

      //   for (var doc in snapshot.docs) {
      //     batch.delete(doc.reference);
      //   }
      //   await batch.commit();
      // }
      await docRef.delete();
      return StatusClasses.success;
    } on FirebaseException catch (e) {
      return mapFirestoreError(e);
    } catch (e) {
      return StatusClasses.customError(e.toString());
    }
  }

  // static Future<void> _deleteChildren(
  //     DocumentReference<Map<String, dynamic>> docRef,
  //     List<String> subCollections) async {
  //   for (final sub in subCollections) {
  //     final batch = FirebaseFirestore.instance.batch();

  //     final snapshot = await docRef.collection(sub).get();
  //     for (var doc in snapshot.docs) {
  //       batch.delete(doc.reference);
  //     }
  //     await batch.commit();
  //   }

  //   await docRef.delete();
  // }

  //تابع لتنفيذ المناقلات
  static Future<StatusClasses> runTransaction({
    required Future<void> Function(Transaction transaction) action,
  }) async {
    try {
      final firestore = FirebaseFirestore.instance;

      await firestore.runTransaction((transaction) async {
        await action(transaction);
      });

      return StatusClasses.success;
    } on FirebaseException catch (e) {
      return mapFirestoreError(e);
    } catch (e) {
      return StatusClasses.customError(e.toString());
    }
  }
  //معالجه حالات الخطأ عم تصير هون كلها
  //مافي داعي عالح الخطأ داخل المناقله اللي بكتبها بعدين لو في حالة بدها خطـ بعمل رمي للخطأ فبتوقف و هون بينلقط الخطأ
  //هام !! جوا المناقله لا تعدلي الواجهة ولا تعملي update ولا تستندي حاله لمتغير الحاله فقط ارمي خطأ لو بدك يصير خطأ
  // ولا تستخدمي return جوا المناقله فقط ارمي خطأ لو بدك تطلعي منها
// **************************** HOW TO USE ********************************
// هذا التابع يستخدم لتنفيذ عدة عمليات على Firestore بشكل "ذري" (Atomic)
// يعني: يا تنجح كل العمليات مع بعض، يا تفشل كلها.
// ملاحظة مهمة:
// - يجب استخدام transaction.get / transaction.update / transaction.set فقط
// - لا توابع FirebaseCrud العادية داخل transaction
// مثال:
//
// final result = await FirebaseCrud.runTransaction(
//   action: (transaction) async {
//     final firestore = FirebaseFirestore.instance;
//
//     final requestRef = firestore.collection('requests').doc(requestId);
//     final userRef = firestore.collection('users').doc(userId);
//
//     /// قراءة البيانات (مهم داخل transaction)
//     final requestSnap = await transaction.get(requestRef);
//
//     if (!requestSnap.exists) {
//       throw Exception("Request not found");
//     }
//
//     /// تحديث الطلب
//     transaction.update(requestRef, {
//       'status': 'rejected',
//       'rejectComment': 'Not valid',
//     });
//
//     /// تحديث المستخدم
//     transaction.update(userRef, {
//       'requestStatus': 'rejected',
//     });
//   },
// );
//
// if (result == StatusClasses.success) {
//   print("Transaction done successfully");
// } else {
//   print("Error: $result");
// }
}

StatusClasses mapFirestoreError(FirebaseException e) {
  switch (e.code) {
    case 'unavailable':
    case 'deadline-exceeded':
    case 'network-request-failed':
      return StatusClasses.offlineError;

    case 'permission-denied':
      print(e);
      return StatusClasses.permissionDenied;

    // case 'unavailable':
    //   return StatusClasses.unavailable;
    case 'not-found':
      print(e);
      return StatusClasses.notFound;

    case 'failed-precondition':
      print(e);
      return StatusClasses.indexRequired;

    case 'invalid-argument':
      print(e);
      return StatusClasses.invalidData;

    default:
      print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!$e");
      return StatusClasses.customError(e.toString());
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
