import 'package:lockpass/core/errors/auth_errors_type.dart';
import 'package:lockpass/core/services/auth/auth_service.dart';
import 'package:lockpass/core/services/auth/auth_service_impl.dart';
import 'package:lockpass/core/session/session_lock_service.dart';

class LoginWithEmailUseCase {
  final AuthService _authService;
  final SessionLockService _sessionLockService;

  LoginWithEmailUseCase(
    this._authService,
    this._sessionLockService,
  );

  Future<void> call({
    required String email,
    required String password,
  }) async {
    try {
      await _authService.login(email, password);
      _sessionLockService.unlock();
    } on AuthException {
      rethrow;
    } catch (_) {
      throw AuthErrorType.unknown;
    }
  }
}
