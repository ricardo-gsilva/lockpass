import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/errors/auth_errors_type.dart';
import 'package:lockpass/core/services/auth/auth_service.dart';
import 'package:lockpass/core/services/auth/auth_service_impl.dart';
import 'package:lockpass/core/session/session_lock_service.dart';
import 'package:lockpass/features/login/domain/usecases/login_with_email_usecase.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthService extends Mock implements AuthService {}

class _MockSessionLockService extends Mock implements SessionLockService {}

void main() {
  group('LoginWithEmailUseCase', () {
    test('unlocks session on successful login', () async {
      final authService = _MockAuthService();
      final sessionLockService = _MockSessionLockService();
      final useCase = LoginWithEmailUseCase(authService, sessionLockService);

      when(() => authService.login('a@b.com', '123456'))
          .thenAnswer((_) async {});

      await useCase(email: 'a@b.com', password: '123456');

      verify(() => authService.login('a@b.com', '123456')).called(1);
      verify(() => sessionLockService.unlock()).called(1);
    });

    test('rethrows AuthException from AuthService', () async {
      final authService = _MockAuthService();
      final sessionLockService = _MockSessionLockService();
      final useCase = LoginWithEmailUseCase(authService, sessionLockService);

      when(() => authService.login(any(), any()))
          .thenThrow(AuthException('invalid'));

      expect(
        () => useCase(email: 'a@b.com', password: '123456'),
        throwsA(isA<AuthException>()),
      );

      verifyNever(() => sessionLockService.unlock());
    });

    test('throws unknown when AuthService throws non-AuthException', () async {
      final authService = _MockAuthService();
      final sessionLockService = _MockSessionLockService();
      final useCase = LoginWithEmailUseCase(authService, sessionLockService);

      when(() => authService.login(any(), any())).thenThrow(Exception('boom'));

      expect(
        () => useCase(email: 'a@b.com', password: '123456'),
        throwsA(equals(AuthErrorType.unknown)),
      );

      verifyNever(() => sessionLockService.unlock());
    });
  });
}
