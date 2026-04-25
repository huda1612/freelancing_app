import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freelancing_platform/core/classes/firebase_crud.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/constants/collections_names.dart';
import 'package:freelancing_platform/models/user_collections/user_model.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_navigation/get_navigation.dart';

//لازم المستخدم يكون مسجل دخول لاقدر استخدم هالصف
class UserService {
  UserService({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firebaseFirestore;

  Future<UserModel?> fetchUserData(String uid) async {
    try {
      final userDoc =
          await _firebaseFirestore.collection("Users").doc(uid).get();

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
