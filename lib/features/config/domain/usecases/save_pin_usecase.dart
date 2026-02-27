import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/core/services/auth/auth_service.dart';
import 'package:lockpass/core/services/pin/pin_service.dart';

class SavePinUseCase {
  final AuthService _authService;
  final PinService _pinService;

  SavePinUseCase(this._authService, this._pinService);

  Future<void> call(String newPin) async {
    final uid = _authService.currentUserId;
    if (uid.isEmpty) {
      throw Exception(CoreStrings.unauthenticatedUser);
    }

    await _pinService.savePin(uid, newPin);
  }
}