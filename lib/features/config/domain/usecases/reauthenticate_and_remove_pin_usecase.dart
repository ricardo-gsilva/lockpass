import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/core/services/auth/auth_service.dart';
import 'package:lockpass/core/services/pin/pin_service.dart';

class ReauthenticateAndRemovePinUseCase {
  final AuthService _authService;
  final PinService _pinService;

  ReauthenticateAndRemovePinUseCase(
    this._authService,
    this._pinService,
  );

  Future<void> call({
    required String email,
    required String password,
  }) async {
    final uid = _authService.currentUserId;
    if (uid.isEmpty) {
      throw Exception(CoreStrings.unauthenticatedUser);
    }

    await _authService.reauthenticateWithPassword(
      email: email,
      password: password,
    );

    await _pinService.removePin(uid);
  }
}