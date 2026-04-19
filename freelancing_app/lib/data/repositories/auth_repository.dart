import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freelancing_platform/models/user_collections/user_model.dart';


class AuthRepository {
  AuthRepository({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firebaseFirestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;

  User? get currentUser => _firebaseAuth.currentUser;

  Future<String?> get userRole async {
    if (currentUser != null) {
      final userDoc = await _firebaseFirestore
          .collection('Users')
          .doc(currentUser!.uid)
          .get();
      if (userDoc.exists) {
        return userDoc.data()!['role'] as String?;
      }
    }
    return null;
  }

  Future<UserCredential> login({
    required String email,
    required String password,
  }) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> sendPasswordResetEmail(String email) {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<bool> userExistsByEmail(String email) async {
    final userDoc = await _firebaseFirestore
        .collection('Users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    return userDoc.docs.isNotEmpty;
  }

  Future<UserCredential> register({
    required String email,
    required String password,
  }) {
    return _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> saveUser(UserModel user) {
    return _firebaseFirestore
        .collection('Users')
        .doc(user.uid)
        .set(user.toMap());
  }

  Future<void> deleteCurrentUser() async {
    await _firebaseAuth.currentUser?.delete();
  }

  Future<void> sendVerificationEmail() async {
    final user = _firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      try {
        await user.sendEmailVerification();
      } catch (e) {
        //هاد الخطأ هون غالبا بيطلع بس يضغط اكثر من مره على زر الارسال مرات ورا بعض
        //رح عالج الخطأ بالكنترولر
        rethrow;
      }
    }
  }
}
