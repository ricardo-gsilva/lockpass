import 'package:firebase_auth/firebase_auth.dart';
import 'package:lockpass/core/errors/auth_errors_type.dart';

class AuthException implements Exception {
  String message;
  AuthException(this.message);
}

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? userApp;
  bool isLoading = true;

  AuthService() {
    _authCheck();
  }

  String get currentUserId => _auth.currentUser?.uid ?? '';

  String get currentUserEmail {
    return FirebaseAuth.instance.currentUser?.email ?? '';
  }


  _authCheck() {
    _auth.authStateChanges().listen((User? user) {
      userApp = (user == null) ? null : user;
      isLoading = false;
    });
  }

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

  Future<bool> sigInOut() async {
    try {
      await _auth.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> deleteAccount() async {
    try {
      await _auth.currentUser?.delete();
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code.toAuthErrorType().message);
    }
  }

  Future<bool> register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      _getUser();
      return true;
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code.toAuthErrorType().message);
    }
  }

  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code.toAuthErrorType().message);
    }
  }

  Future<void>resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code.toAuthErrorType().message);
    }
  }

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
      // Repassa o erro de "Senha incorreta" que seu método já lança
      rethrow; 
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code.toAuthErrorType().message);
    }
  }

  _getUser() {
    userApp = _auth.currentUser;
  }
}
