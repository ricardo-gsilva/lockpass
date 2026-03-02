import 'package:lockpass/core/errors/auth_errors_type.dart';
import 'package:lockpass/core/services/auth/auth_service.dart';
import 'package:lockpass/core/services/pin/pin_service.dart';

class AuthenticateTrashWithPinUseCase {
  final AuthService _authService;
  final PinService _pinService;

  AuthenticateTrashWithPinUseCase(
    this._authService,
    this._pinService,
  );

  Future<void> call(String pin) async {
    final uid = _authService.currentUserId;

    if (uid.isEmpty) {
      throw AuthErrorType.requiresRecentLogin;
    }

    try {
      final isValid = await _pinService.validatePin(uid, pin);

      if (!isValid) {
        throw AuthErrorType.invalidCredentials;
      }
    } catch (_) {
      throw AuthErrorType.unknown;
    }
  }
}