import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/errors/auth_errors_type.dart';
import 'package:lockpass/core/services/auth/auth_service.dart';
import 'package:lockpass/core/services/auth/auth_service_impl.dart';
import 'package:lockpass/features/login/domain/usecases/register_user_usecase.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthService extends Mock implements AuthService {}

void main() {
  group('RegisterUserUseCase', () {
    test('registers and signs out on success', () async {
      final authService = _MockAuthService();
      final useCase = RegisterUserUseCase(authService);

      when(() => authService.register('a@b.com', '123456'))
          .thenAnswer((_) async => true);
      when(() => authService.signOut()).thenAnswer((_) async => true);

      await useCase(email: 'a@b.com', password: '123456');

      verify(() => authService.register('a@b.com', '123456')).called(1);
      verify(() => authService.signOut()).called(1);
    });

    test('rethrows AuthException from AuthService', () async {
      final authService = _MockAuthService();
      final useCase = RegisterUserUseCase(authService);

      when(() => authService.register(any(), any()))
          .thenThrow(AuthException('invalid'));

      expect(
        () => useCase(email: 'a@b.com', password: '123456'),
        throwsA(isA<AuthException>()),
      );
    });

    test('throws unknown when AuthService throws non-AuthException', () async {
      final authService = _MockAuthService();
      final useCase = RegisterUserUseCase(authService);

      when(() => authService.register(any(), any())).thenThrow(Exception('boom'));

      expect(
        () => useCase(email: 'a@b.com', password: '123456'),
        throwsA(equals(AuthErrorType.unknown)),
      );
    });
  });
}
