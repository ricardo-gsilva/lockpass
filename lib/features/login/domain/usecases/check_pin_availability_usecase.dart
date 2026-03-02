import 'package:lockpass/core/services/auth/auth_service.dart';
import 'package:lockpass/core/services/pin/pin_service.dart';

class CheckPinAvailabilityUseCase {
  final AuthService _authService;
  final PinService _pinService;

  CheckPinAvailabilityUseCase(
    this._authService,
    this._pinService,
  );

  Future<bool> call() async {
    final uid = _authService.currentUserId;

    if (uid.isEmpty) return false;

    final hasPin = await _pinService.hasPin(uid);

    return hasPin;
  }
}