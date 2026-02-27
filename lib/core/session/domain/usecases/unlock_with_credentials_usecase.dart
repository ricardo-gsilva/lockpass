import 'package:lockpass/core/services/auth/auth_service.dart';
import 'package:lockpass/core/session/session_lock_service.dart';

class UnlockWithCredentialsUseCase {
  final AuthService _authService;
  final SessionLockService _sessionLock;

  UnlockWithCredentialsUseCase(
    this._authService,
    this._sessionLock,
  );

  Future<bool> call({
    required String email,
    required String password,
  }) async {
    final isValid = await _authService.reauthenticateWithPassword(
      email: email,
      password: password,
    );

    if (!isValid) return false;

    _sessionLock.unlock();

    return true;
  }
}