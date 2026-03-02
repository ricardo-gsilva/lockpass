import 'package:firebase_auth/firebase_auth.dart';
import 'package:lockpass/core/errors/auth_errors_type.dart';
import 'package:lockpass/core/services/auth/auth_service.dart';

class AuthException implements Exception {
  String message;
  AuthException(this.message);
}

class AuthServiceImpl implements AuthService {
  final FirebaseAuth _auth;  

  AuthServiceImpl({FirebaseAuth? auth})
    : _auth = auth ?? FirebaseAuth.instance;

  @override
  User? get currentUser => _auth.currentUser;

  @override
  String get currentUserId => _auth.currentUser?.uid ?? '';

  @override
  String get currentUserEmail {
    return FirebaseAuth.instance.currentUser?.email ?? '';
  }

  @override
  Future<bool> reauthenticateWithPassword({
    required String email,
    required String password,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;
      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);
      return true;
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code.toAuthErrorType().message);
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      await _auth.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      await _auth.currentUser?.delete();
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code.toAuthErrorType().message);
    }
  }

  @override
  Future<bool> register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code.toAuthErrorType().message);
    }
  }

  @override
  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code.toAuthErrorType().message);
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code.toAuthErrorType().message);
    }
  }

  @override
  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final email = currentUserEmail;

      final isValid = await reauthenticateWithPassword(
        email: email,
        password: currentPassword,
      );

      if (isValid) {
        await _auth.currentUser?.updatePassword(newPassword);
      }
    } on AuthException {
      rethrow;
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code.toAuthErrorType().message);
    }
  }
}
