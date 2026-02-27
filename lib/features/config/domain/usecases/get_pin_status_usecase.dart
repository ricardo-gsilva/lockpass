import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/core/services/auth/auth_service.dart';
import 'package:lockpass/core/services/pin/pin_service.dart';

class GetPinStatusUseCase {
  final PinService _pinService;
  final AuthService _authService;

  GetPinStatusUseCase(this._pinService, this._authService);

  Future<bool> call() async {
    final uid = _authService.currentUserId;
    if (uid.isEmpty) throw Exception(CoreStrings.unauthenticatedUser);
    return await _pinService.hasPin(uid);
  }
}