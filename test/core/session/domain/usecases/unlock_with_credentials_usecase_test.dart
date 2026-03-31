import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/services/auth/auth_service.dart';
import 'package:lockpass/core/session/domain/usecases/unlock_with_credentials_usecase.dart';
import 'package:lockpass/core/session/session_lock_service.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthService extends Mock implements AuthService {}

void main() {
  group('UnlockWithCredentialsUseCase', () {
    test('returns false when auth service returns false', () async {
      final authService = _MockAuthService();
      final sessionLock = SessionLockService()..lock();

      when(
        () => authService.reauthenticateWithPassword(
          email: 'a@b.com',
          password: '123456',
        ),
      ).thenAnswer((_) async => false);

      final useCase = UnlockWithCredentialsUseCase(authService, sessionLock);
      final result = await useCase(email: 'a@b.com', password: '123456');

      expect(result, isFalse);
      expect(sessionLock.isLocked, isTrue);
    });

    test('unlocks and returns true when auth service returns true', () async {
      final authService = _MockAuthService();
      final sessionLock = SessionLockService()..lock();

      when(
        () => authService.reauthenticateWithPassword(
          email: 'a@b.com',
          password: '123456',
        ),
      ).thenAnswer((_) async => true);

      final useCase = UnlockWithCredentialsUseCase(authService, sessionLock);
      final result = await useCase(email: 'a@b.com', password: '123456');

      expect(result, isTrue);
      expect(sessionLock.isLocked, isFalse);
    });
  });
}

