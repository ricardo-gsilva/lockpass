import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/services/auth/auth_service.dart';
import 'package:lockpass/features/home/domain/usecases/get_current_user_usecase.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthService extends Mock implements AuthService {}

void main() {
  group('GetCurrentUserUseCase', () {
    test('exposes uid and email from AuthService', () {
      final authService = _MockAuthService();
      final useCase = GetCurrentUserUseCase(authService);

      when(() => authService.currentUserId).thenReturn('uid123');
      when(() => authService.currentUserEmail).thenReturn('a@b.com');

      expect(useCase.uid, 'uid123');
      expect(useCase.email, 'a@b.com');
    });
  });
}

