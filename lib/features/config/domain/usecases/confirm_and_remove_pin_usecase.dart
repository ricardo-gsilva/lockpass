import 'package:lockpass/core/services/auth/auth_service.dart';
import 'package:lockpass/core/services/pin/pin_service.dart';

class ConfirmAndRemovePinUseCase {
  final AuthService _authService;
  final PinService _pinService;

  ConfirmAndRemovePinUseCase(
    this._authService,
    this._pinService,
  );

  Future<void> call(String typedPin) async {
    final uid = _authService.currentUserId;
    if (uid.isEmpty) {
      throw Exception("USER_NOT_AUTHENTICATED");
    }

    final isValid = await _pinService.validatePin(
      uid,
      typedPin.trim(),
    );

    if (!isValid) {
      throw Exception("INVALID_PIN");
    }

    await _pinService.removePin(uid);
  }
}