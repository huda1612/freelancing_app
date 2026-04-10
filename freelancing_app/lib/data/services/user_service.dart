import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freelancing_platform/models/user_collections/user_model.dart';

//لازم المستخدم يكون مسجل دخول لاقدر استخدم هالصف
class UserService {
  UserService({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firebaseFirestore;

  Future<UserModel?> fetchUserData(String uid) async {
    final userDoc = await _firebaseFirestore.collection("Users").doc(uid).get();

    if (!userDoc.exists) {
      return null;
    }

    final data = userDoc.data();
    if (data == null) {
      return null;
    }
    return UserModel.fromMap(data, uid);
  }

  // Future<bool> userExistsByUid(String uid) async {
  //   final userDoc = await _firebaseFirestore.collection('Users').doc(uid).get();
  //   return userDoc.exists;
  // }

  Future<void> updateUserData(Map<String, dynamic> newUser, String uid) async {
    await _firebaseFirestore.collection("Users").doc(uid).update(newUser);
  }
}
