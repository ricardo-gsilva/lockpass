import 'package:lockpass/core/errors/auth_errors_type.dart';
import 'package:lockpass/core/services/auth/auth_service.dart';
import 'package:lockpass/core/services/auth/auth_service_impl.dart';

class ResetPasswordUseCase {
  final AuthService _authService;

  ResetPasswordUseCase(this._authService);

  Future<void> call(String email) async {
    try {
      await _authService.resetPassword(email);
    } on AuthException {
      rethrow;
    } catch (_) {
      throw AuthErrorType.unknown;
    }
  }
}
