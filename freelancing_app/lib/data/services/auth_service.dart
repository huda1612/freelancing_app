import 'package:firebase_auth/firebase_auth.dart';
import 'package:freelancing_platform/core/constants/app_keys.dart';
import 'package:freelancing_platform/data/repositories/auth_repository.dart';
import 'package:freelancing_platform/models/user_collections/user_model.dart';
import 'package:freelancing_platform/services/local_storage_service.dart';

class AuthService {
  AuthService(this._authRepository);

  final AuthRepository _authRepository;

  User? get currentUser => _authRepository.currentUser;
  Future<String?> get userRole async => await _authRepository.userRole;

  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    UserCredential uc =
        await _authRepository.login(email: email, password: password);
    //حفظ رقم تعريف المستخدم و دوره بالذاكره المحليه
    LocalStorageService.setStringValue(AppKeys.uid, currentUser!.uid);
    LocalStorageService.setConstantUid();
    final role = await userRole;
    if (role != null) {
      LocalStorageService.setStringValue(AppKeys.role, role);
      LocalStorageService.setConstantRole();
    }
    return uc;
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
      //حفظ رقم تعريف المستخدم و دوره بالذاكره المحليه
      LocalStorageService.setStringValue(AppKeys.uid, currentUser!.uid);
      LocalStorageService.setConstantUid();
      final role = await userRole;
      if (role != null) {
        LocalStorageService.setStringValue(AppKeys.role, role);
        LocalStorageService.setConstantRole();
      }
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
