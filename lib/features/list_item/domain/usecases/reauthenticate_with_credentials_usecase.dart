import 'package:lockpass/core/errors/auth_errors_type.dart';
import 'package:lockpass/core/services/auth/auth_service.dart';
import 'package:lockpass/core/services/auth/auth_service_impl.dart';

class ReauthenticateWithCredentialsUseCase {
  final AuthService _authService;

  ReauthenticateWithCredentialsUseCase(this._authService);

  Future<void> call({
    required String email,
    required String password,
  }) async {
    try {
      final isValid = await _authService.reauthenticateWithPassword(
        email: email,
        password: password,
      );

      if (!isValid) {
        throw AuthErrorType.invalidCredentials;
      }
    } on AuthException {
      rethrow;
    } catch (_) {
      throw AuthErrorType.unknown;
    }
  }
}
