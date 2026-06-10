import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/services/auth/auth_service.dart';
import 'package:lockpass/core/services/pin/pin_service.dart';
import 'package:lockpass/core/session/domain/usecases/unlock_with_pin_usecase.dart';
import 'package:lockpass/core/session/session_lock_service.dart';
import 'package:mocktail/mocktail.dart';

class _MockPinService extends Mock implements PinService {}

class _MockAuthService extends Mock implements AuthService {}

void main() {
  group('UnlockWithPinUseCase', () {
    test('returns false when uid is empty', () async {
      final pinService = _MockPinService();
      final authService = _MockAuthService();
      final sessionLock = SessionLockService()..lock();

      when(() => authService.currentUserId).thenReturn('');

      final useCase = UnlockWithPinUseCase(pinService, authService, sessionLock);
      final result = await useCase('12345');

      expect(result, isFalse);
      expect(sessionLock.isLocked, isTrue);
      verifyNever(() => pinService.validatePin(any(), any()));
    });

    test('returns false when pin is invalid', () async {
      final pinService = _MockPinService();
      final authService = _MockAuthService();
      final sessionLock = SessionLockService()..lock();

      when(() => authService.currentUserId).thenReturn('uid');
      when(() => pinService.validatePin('uid', '12345')).thenAnswer((_) async => false);

      final useCase = UnlockWithPinUseCase(pinService, authService, sessionLock);
      final result = await useCase('12345');

      expect(result, isFalse);
      expect(sessionLock.isLocked, isTrue);
      verify(() => pinService.validatePin('uid', '12345')).called(1);
    });

    test('unlocks and returns true when pin is valid', () async {
      final pinService = _MockPinService();
      final authService = _MockAuthService();
      final sessionLock = SessionLockService()..lock();

      when(() => authService.currentUserId).thenReturn('uid');
      when(() => pinService.validatePin('uid', '12345')).thenAnswer((_) async => true);

      final useCase = UnlockWithPinUseCase(pinService, authService, sessionLock);
      final result = await useCase('12345');

      expect(result, isTrue);
      expect(sessionLock.isLocked, isFalse);
    });
  });
}

