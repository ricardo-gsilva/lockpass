// ignore_for_file: prefer_final_fields

import 'package:firebase_auth/firebase_auth.dart';
import 'package:lockpass/constants/core_strings.dart';
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

  _authCheck() {
    _auth.authStateChanges().listen((User? user) {
      userApp = (user == null) ? null : user;
      isLoading = false;
    });
  }

  Future<bool> sigInOut() async {
    try {
      await _auth.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteAccount() async {
    try {
      await _auth.currentUser?.delete();
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code != '200') throw AuthException(e.code);
      return false;
    }
  }

  Future<bool> register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      _getUser();
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw AuthException(CoreStrings.fWeakPassword);
      } else if (e.code == 'email-already-in-use') {
        throw AuthException(CoreStrings.fEmailAlreadyInUse);
      } else if (e.code == 'invalid-email') {
        throw AuthException(CoreStrings.fEmailInvalid);
      }
      return false;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code.toAuthErrorType().message);
      // if (e.code == 'user-not-found') {
      //   throw AuthException(CoreStrings.fUserNotFound);
      // } else if (e.code == 'invalid-email') {
      //   throw AuthException(CoreStrings.fEmailInvalid);
      // } else if (e.code == 'invalid-credential') {
      //   throw AuthException(CoreStrings.fInvalidLoginCredentials);
      // } else if (e.code == 'wrong-password') {
      //   throw AuthException(CoreStrings.fWrongPassword);
      // } else if (e.code == 'user-disabled') {
      //   throw AuthException(CoreStrings.fUserDisabled);
      // } else {
      //   throw AuthException("Não foi possível realizar o login. Tente novamente.");
      // }
    }
  }

  Future<void>resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw AuthException(CoreStrings.fUserNotFound);
      } else if (e.code == 'invalid-email') {
        throw AuthException(CoreStrings.fEmailInvalid);
      } else if (e.code == 'invalid-credential') {
        throw AuthException(CoreStrings.fInvalidLoginCredentials);
      } else if (e.code == 'missing-email') {
        throw AuthException(CoreStrings.missingEmail);
      }
    }
  }

  _getUser() {
    userApp = _auth.currentUser;
  }
}
