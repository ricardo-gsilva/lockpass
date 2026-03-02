import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/core/services/auth/auth_service.dart';
import 'package:lockpass/core/services/pin/pin_service.dart';

class UpdatePinUseCase {
  final AuthService _authService;
  final PinService _pinService;

  UpdatePinUseCase(this._authService, this._pinService);

  Future<void> call({
    required String currentPin,
    required String newPin,
  }) async {
    final uid = _authService.currentUserId;
    if (uid.isEmpty) {
      throw Exception(CoreStrings.unauthenticatedUser);
    }

    final isValid = await _pinService.validatePin(uid, currentPin.trim());
    if (!isValid) {
      throw Exception("INVALID_CURRENT_PIN");
    }

    await _pinService.savePin(uid, newPin);
  }
}