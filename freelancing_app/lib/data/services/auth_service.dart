import 'package:firebase_auth/firebase_auth.dart';
import 'package:freelancing_platform/data/repositories/auth_repository.dart';
import 'package:freelancing_platform/models/user_collections/user_model.dart';

class AuthService {
  AuthService(this._authRepository);

  final AuthRepository _authRepository;

  User? get currentUser => _authRepository.currentUser;

  Future<UserCredential> login({
    required String email,
    required String password,
  }) {
    return _authRepository.login(email: email, password: password);
  }

  Future<void> resetPassword(String email) async {
    final exists = await _authRepository.userExistsByEmail(email);
    if (!exists) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'هذا المستخدم غير موجود',
      );
    }
    await _authRepository.sendPasswordResetEmail(email);
  }

  Future<void> registerUser({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String role,
  }) async {
    final userCredential =
        await _authRepository.register(email: email, password: password);
    final uid = userCredential.user!.uid;
    final newUser = UserModel(
      uid: uid,
      fname: firstName,
      lname: lastName,
      email: email,
      role: role,
    );

    try {
      await _authRepository.saveUser(newUser);
    } catch (_) {
      await _authRepository.deleteCurrentUser();
      rethrow;
    }

    await _authRepository.sendVerificationEmail();
  }

  Future<void> resendVerificationEmail() {
    return _authRepository.sendVerificationEmail();
  }
}
