import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/errors/auth_errors_type.dart';
import 'package:lockpass/core/services/auth/auth_service.dart';
import 'package:lockpass/core/services/pin/pin_service.dart';
import 'package:lockpass/core/session/session_lock_service.dart';
import 'package:lockpass/features/login/domain/usecases/login_with_pin_usecase.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthService extends Mock implements AuthService {}

class _MockPinService extends Mock implements PinService {}

class _MockSessionLockService extends Mock implements SessionLockService {}

void main() {
  group('LoginWithPinUseCase', () {
    test('throws requiresRecentLogin when user id is empty', () async {
      final authService = _MockAuthService();
      final pinService = _MockPinService();
      final sessionLockService = _MockSessionLockService();
      final useCase = LoginWithPinUseCase(authService, pinService, sessionLockService);

      when(() => authService.currentUserId).thenReturn('');

      expect(
        () => useCase('12345'),
        throwsA(equals(AuthErrorType.requiresRecentLogin)),
      );
      verifyNever(() => pinService.validatePin(any(), any()));
      verifyNever(() => sessionLockService.unlock());
    });

    test('returns true and unlocks session when pin is valid', () async {
      final authService = _MockAuthService();
      final pinService = _MockPinService();
      final sessionLockService = _MockSessionLockService();
      final useCase = LoginWithPinUseCase(authService, pinService, sessionLockService);

      when(() => authService.currentUserId).thenReturn('uid123');
      when(() => pinService.validatePin('uid123', '12345')).thenAnswer((_) async => true);

      final result = await useCase(' 12345 ');

      expect(result, isTrue);
      verify(() => pinService.validatePin('uid123', '12345')).called(1);
      verify(() => sessionLockService.unlock()).called(1);
    });

    test('returns false and does not unlock when pin is invalid', () async {
      final authService = _MockAuthService();
      final pinService = _MockPinService();
      final sessionLockService = _MockSessionLockService();
      final useCase = LoginWithPinUseCase(authService, pinService, sessionLockService);

      when(() => authService.currentUserId).thenReturn('uid123');
      when(() => pinService.validatePin('uid123', '12345')).thenAnswer((_) async => false);

      final result = await useCase('12345');

      expect(result, isFalse);
      verify(() => pinService.validatePin('uid123', '12345')).called(1);
      verifyNever(() => sessionLockService.unlock());
    });

    test('throws unknown when pin validation throws', () async {
      final authService = _MockAuthService();
      final pinService = _MockPinService();
      final sessionLockService = _MockSessionLockService();
      final useCase = LoginWithPinUseCase(authService, pinService, sessionLockService);

      when(() => authService.currentUserId).thenReturn('uid123');
      when(() => pinService.validatePin(any(), any())).thenThrow(Exception('boom'));

      expect(() => useCase('12345'), throwsA(equals(AuthErrorType.unknown)));
      verifyNever(() => sessionLockService.unlock());
    });
  });
}
