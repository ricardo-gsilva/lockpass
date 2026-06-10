import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/errors/auth_errors_type.dart';
import 'package:lockpass/core/services/auth/auth_service.dart';
import 'package:lockpass/core/services/auth/auth_service_impl.dart';
import 'package:lockpass/features/login/domain/usecases/reset_password_usecase.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthService extends Mock implements AuthService {}

void main() {
  group('ResetPasswordUseCase', () {
    test('calls AuthService.resetPassword', () async {
      final authService = _MockAuthService();
      final useCase = ResetPasswordUseCase(authService);

      when(() => authService.resetPassword('a@b.com')).thenAnswer((_) async {});

      await useCase('a@b.com');

      verify(() => authService.resetPassword('a@b.com')).called(1);
    });

    test('rethrows AuthException from AuthService', () async {
      final authService = _MockAuthService();
      final useCase = ResetPasswordUseCase(authService);

      when(() => authService.resetPassword(any())).thenThrow(AuthException('invalid'));

      expect(() => useCase('a@b.com'), throwsA(isA<AuthException>()));
    });

    test('throws unknown when AuthService throws non-AuthException', () async {
      final authService = _MockAuthService();
      final useCase = ResetPasswordUseCase(authService);

      when(() => authService.resetPassword(any())).thenThrow(Exception('boom'));

      expect(() => useCase('a@b.com'), throwsA(equals(AuthErrorType.unknown)));
    });
  });
}
