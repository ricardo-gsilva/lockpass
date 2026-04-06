import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/errors/auth_errors_type.dart';
import 'package:lockpass/core/services/auth/auth_service.dart';
import 'package:lockpass/core/services/auth/auth_service_impl.dart';
import 'package:lockpass/features/list_item/domain/usecases/reauthenticate_with_credentials_usecase.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthService extends Mock implements AuthService {}

void main() {
  group('ReauthenticateWithCredentialsUseCase', () {
    test('completes when AuthService returns true', () async {
      final authService = _MockAuthService();
      final useCase = ReauthenticateWithCredentialsUseCase(authService);

      when(
        () => authService.reauthenticateWithPassword(
          email: 'a@b.com',
          password: '123456',
        ),
      ).thenAnswer((_) async => true);

      await useCase(email: 'a@b.com', password: '123456');
    });

    test('throws invalidCredentials when AuthService returns false', () async {
      final authService = _MockAuthService();
      final useCase = ReauthenticateWithCredentialsUseCase(authService);

      when(
        () => authService.reauthenticateWithPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => false);

      expect(
        () => useCase(email: 'a@b.com', password: '123456'),
        throwsA(equals(AuthErrorType.invalidCredentials)),
      );
    });

    test('rethrows AuthException', () async {
      final authService = _MockAuthService();
      final useCase = ReauthenticateWithCredentialsUseCase(authService);

      when(
        () => authService.reauthenticateWithPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(AuthException('invalid'));

      expect(
        () => useCase(email: 'a@b.com', password: '123456'),
        throwsA(isA<AuthException>()),
      );
    });

    test('throws unknown when AuthService throws non-AuthException', () async {
      final authService = _MockAuthService();
      final useCase = ReauthenticateWithCredentialsUseCase(authService);

      when(
        () => authService.reauthenticateWithPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(Exception('boom'));

      expect(
        () => useCase(email: 'a@b.com', password: '123456'),
        throwsA(equals(AuthErrorType.unknown)),
      );
    });
  });
}

