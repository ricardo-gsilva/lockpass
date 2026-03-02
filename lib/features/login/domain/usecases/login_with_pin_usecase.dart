import 'package:lockpass/core/errors/auth_errors_type.dart';
import 'package:lockpass/core/services/auth/auth_service.dart';
import 'package:lockpass/core/services/pin/pin_service.dart';
import 'package:lockpass/core/session/session_lock_service.dart';

class LoginWithPinUseCase {
  final AuthService _authService;
  final PinService _pinService;
  final SessionLockService _sessionLockService;

  LoginWithPinUseCase(
    this._authService,
    this._pinService,
    this._sessionLockService,
  );

  Future<bool> call(String typedPin) async {
    final uid = _authService.currentUserId;

    if (uid.isEmpty) {
      throw AuthErrorType.requiresRecentLogin;
    }

    try {
      final isValid =
          await _pinService.validatePin(uid, typedPin.trim());
      if(isValid) _sessionLockService.unlock();
      return isValid;
    } catch (_) {
      throw AuthErrorType.unknown;
    }
  }
}