import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/errors/auth_errors_type.dart';
import 'package:lockpass/core/services/auth/auth_service.dart';
import 'package:lockpass/core/services/pin/pin_service.dart';
import 'package:lockpass/features/list_item/domain/usecases/authenticate_with_pin_usecase.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthService extends Mock implements AuthService {}

class _MockPinService extends Mock implements PinService {}

void main() {
  group('AuthenticateTrashWithPinUseCase', () {
    test('throws requiresRecentLogin when uid is empty', () async {
      final authService = _MockAuthService();
      final pinService = _MockPinService();
      final useCase = AuthenticateTrashWithPinUseCase(authService, pinService);

      when(() => authService.currentUserId).thenReturn('');

      expect(
        () => useCase('12345'),
        throwsA(equals(AuthErrorType.requiresRecentLogin)),
      );
      verifyNever(() => pinService.validatePin(any(), any()));
    });

    test('throws invalidCredentials when pin is invalid', () async {
      final authService = _MockAuthService();
      final pinService = _MockPinService();
      final useCase = AuthenticateTrashWithPinUseCase(authService, pinService);

      when(() => authService.currentUserId).thenReturn('uid123');
      when(() => pinService.validatePin('uid123', '12345'))
          .thenAnswer((_) async => false);

      expect(
        () => useCase('12345'),
        throwsA(equals(AuthErrorType.invalidCredentials)),
      );
    });

    test('completes when pin is valid', () async {
      final authService = _MockAuthService();
      final pinService = _MockPinService();
      final useCase = AuthenticateTrashWithPinUseCase(authService, pinService);

      when(() => authService.currentUserId).thenReturn('uid123');
      when(() => pinService.validatePin('uid123', '12345'))
          .thenAnswer((_) async => true);

      await useCase('12345');

      verify(() => pinService.validatePin('uid123', '12345')).called(1);
    });

    test('throws unknown when pin service throws', () async {
      final authService = _MockAuthService();
      final pinService = _MockPinService();
      final useCase = AuthenticateTrashWithPinUseCase(authService, pinService);

      when(() => authService.currentUserId).thenReturn('uid123');
      when(() => pinService.validatePin(any(), any()))
          .thenThrow(Exception('boom'));

      expect(
        () => useCase('12345'),
        throwsA(equals(AuthErrorType.unknown)),
      );
    });
  });
}

