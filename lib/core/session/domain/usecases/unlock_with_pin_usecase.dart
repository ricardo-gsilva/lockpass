import 'package:lockpass/core/services/auth/auth_service.dart';
import 'package:lockpass/core/services/pin/pin_service.dart';
import 'package:lockpass/core/session/session_lock_service.dart';

class UnlockWithPinUseCase {
  final PinService _pinService;
  final AuthService _authService;
  final SessionLockService _sessionLock;

  UnlockWithPinUseCase(
    this._pinService,
    this._authService,
    this._sessionLock,
  );

  Future<bool> call(String pin) async {
    final uid = _authService.currentUserId;

    if (uid.isEmpty) return false;

    final isValid = await _pinService.validatePin(uid, pin);

    if (!isValid) return false;

    _sessionLock.unlock();

    return true;
  }
}