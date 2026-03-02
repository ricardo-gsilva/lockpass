import 'package:lockpass/core/services/auth/auth_service.dart';

class UpdatePasswordUseCase {
  final AuthService _authService;

  UpdatePasswordUseCase(this._authService);

  Future<void> call({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _authService.updatePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );

    await _authService.signOut();
  }
}