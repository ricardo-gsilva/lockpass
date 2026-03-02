import 'package:lockpass/core/errors/auth_errors_type.dart';
import 'package:lockpass/core/services/auth/auth_service.dart';
import 'package:lockpass/core/services/auth/auth_service_impl.dart';

class RegisterUserUseCase {
  final AuthService _authService;

  RegisterUserUseCase(this._authService);

  Future<void> call({
    required String email,
    required String password,
  }) async {
    try {
      await _authService.register(email, password);
      await _authService.signOut();
    } on AuthException {
      rethrow;
    } catch (_) {
      throw AuthErrorType.unknown;
    }
  }
}
