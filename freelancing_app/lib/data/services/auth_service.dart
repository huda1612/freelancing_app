import 'package:firebase_auth/firebase_auth.dart';
import 'package:freelancing_platform/core/classes/user_session.dart';
import 'package:freelancing_platform/data/repositories/auth_repository.dart';
import 'package:freelancing_platform/models/user_collections/user_model.dart';

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
    // final role = await userRole;
    // if (role != null) {
    //   await UserSession.save(uidValue: currentUser!.uid, roleValue: role);
    //   //لو كان الدور ما موجود بالمستند مارح يعتبره مسجل دخول خلص حتى لو كان مسجل بالتطبيق لان مارح تنحفظ الجلسه انتبهي !!!!!!!!!!!!!!!!!
    // } else {
    //   await FirebaseAuth.instance.signOut();
    //   throw Exception("لا يوجد دور للمستخدم!!");
    // }
    await saveUserSession(passedRole: null);
    return uc;
  }

  Future<void> saveUserSession({String? passedRole}) async {
    String? role;
    if (passedRole == null) {
      role = await userRole;
    } else {
      role = passedRole;
    }
    if (role != null) {
      await UserSession.save(uidValue: currentUser!.uid, roleValue: role);
    } else {
      //لو كان الدور ما موجود بالمستند مارح يعتبره مسجل دخول خلص حتى لو كان مسجل بالتطبيق لان مارح تنحفظ الجلسه انتبهي !!!!!!!!!!!!!!!!!
      await FirebaseAuth.instance.signOut();
      //حذف المستخدم عم يصير من الداتا فلو ما انوجد يعني محذوف
      throw Exception("هذا المستخدم محذوف!!");
    }
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
    required String username,
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
      username: username,
      email: email,
      role: role,
    );

    try {
      await _authRepository.saveUser(newUser);
      await saveUserSession(passedRole: role);
      // await UserSession.save(uidValue: currentUser!.uid, roleValue: role);
    } catch (_) {
      await _authRepository.deleteCurrentUser();
      rethrow;
    }

    await _authRepository.sendVerificationEmail();
  }

  Future<void> resendVerificationEmail() {
    try {
      return _authRepository.sendVerificationEmail();
    } catch (_) {
      rethrow; //رح عالج الخطأ بالكنترولر
    }
  }
}
