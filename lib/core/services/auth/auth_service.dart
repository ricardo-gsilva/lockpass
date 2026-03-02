import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthService {
  String get currentUserId;
  String get currentUserEmail;
  User? get currentUser;

  Future<bool> register(String email, String password);
  Future<void> login(String email, String password);
  Future<bool> signOut();
  Future<void> deleteAccount();

  Future<bool> reauthenticateWithPassword({
    required String email,
    required String password,
  });

  Future<void> resetPassword(String email);

  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  });
}