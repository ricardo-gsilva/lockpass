import 'package:lockpass/core/services/auth/auth_service.dart';

class GetCurrentUserUseCase {
  final AuthService _authService;

  GetCurrentUserUseCase(this._authService);

  String get uid => _authService.currentUserId;

  String? get email => _authService.currentUserEmail;
}