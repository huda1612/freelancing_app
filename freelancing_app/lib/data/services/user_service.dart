import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freelancing_platform/core/classes/firebase_crud.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/constants/collections_names.dart';
import 'package:freelancing_platform/models/user_collections/user_model.dart';

//لازم المستخدم يكون مسجل دخول لاقدر استخدم هالصف
class UserService {
  UserService({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firebaseFirestore;

  Future<UserModel?> fetchUserData(String uid) async {
    try {
      final userDoc = await _firebaseFirestore
          .collection(CollectionsNames.users)
          .doc(uid)
          .get();

      if (!userDoc.exists) {
        return null;
      }

      final data = userDoc.data();
      if (data == null) {
        return null;
      }
      return UserModel.fromMap(data, uid);
    } catch (_) {
      rethrow;
    }
  }

  Future<Either<StatusClasses, UserModel>> fetchUserData2(String uid) async {
    final docRef =
        _firebaseFirestore.collection(CollectionsNames.users).doc(uid);
    final response = await FirebaseCrud.fetchDocument<UserModel>(
        docRef: docRef, fromMap: (data, id) => UserModel.fromMap(data, id));
    return response;
  }

  Future<void> updateUserData(Map<String, dynamic> newUser, String uid) async {
    await _firebaseFirestore
        .collection(CollectionsNames.users)
        .doc(uid)
        .update(newUser);
  }

  Future<StatusClasses> updateUserData2(
      Map<String, dynamic> newUser, String uid) async {
    final collection = _firebaseFirestore.collection(CollectionsNames.users);
    final StatusClasses response = await FirebaseCrud.updateDocument(
        collectionRef: collection, docId: uid, body: newUser);
    return response;
  }

  //لحذف مستخدم
  Future<StatusClasses> deleteUser(String uid) async {
    final usersCollection =
        _firebaseFirestore.collection(CollectionsNames.users);
    final userDoc = usersCollection.doc(uid);
    //اول شي بحذف كل المجموعات الفرعيه بالمستخدم
    const subCollections = [
      CollectionsNames.workSamples,
      CollectionsNames.certificate,
      CollectionsNames.reviews,
      CollectionsNames.suggestions,
      CollectionsNames.activities,
    ];
    return await FirebaseCrud.deleteDocumentWithChildren(
        docRef: userDoc, subCollections: subCollections);
  }

  Future<void> updateUsernameCollection(
      String newUsername, String oldUsername) async {
    //اولا بحذف القديم
    await _firebaseFirestore
        .collection(CollectionsNames.usernames)
        .doc(oldUsername)
        .delete();
    //بعدين بخزن الجديد
    var uid = FirebaseAuth.instance.currentUser!.uid;
    await _firebaseFirestore
        .collection(CollectionsNames.usernames)
        .doc(newUsername)
        .set({"uid": uid});
  }
}


  //  Future<StatusClasses> deleteUser(String uid) async {
  //   final usersCollection =
  //       _firebaseFirestore.collection(CollectionsNames.users);
  //   final userDoc = usersCollection.doc(uid);
  // try {
  //   final collections = [
  //     CollectionsNames.workSamples,
  //     CollectionsNames.certificate,
  //     CollectionsNames.reviews,
  //     CollectionsNames.suggestions,
  //     CollectionsNames.activities,
  //   ];

  //   for (final c in collections) {
  //     await _deleteSubCollection(userDoc, c);
  //   }

  //   //اخر شي حذف المستخدم
  //   final StatusClasses response = await FirebaseCrud.deleteDocument(
  //     collectionRef: usersCollection,
  //     docId: uid,
  //   );
  //   return response;
  // } catch (e) {
  //   return StatusClasses.customError(e.toString());
  // }
  // }

  // Future<void> _deleteSubCollection(
  //     DocumentReference userDoc, String name) async {
  //   final batch = _firebaseFirestore.batch();
  //   final snapshot = await userDoc.collection(name).get();

  //   for (var doc in snapshot.docs) {
  //     batch.delete(doc.reference);
  //   }
  //   await batch.commit();
  // }