import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/services/auth/auth_service.dart';
import 'package:lockpass/core/services/pin/pin_service.dart';
import 'package:lockpass/features/login/domain/usecases/check_pin_availability_usecase.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthService extends Mock implements AuthService {}

class _MockPinService extends Mock implements PinService {}

void main() {
  group('CheckPinAvailabilityUseCase', () {
    test('returns false when user id is empty', () async {
      final authService = _MockAuthService();
      final pinService = _MockPinService();
      final useCase = CheckPinAvailabilityUseCase(authService, pinService);

      when(() => authService.currentUserId).thenReturn('');

      final result = await useCase();

      expect(result, isFalse);
      verifyNever(() => pinService.hasPin(any()));
    });

    test('returns true when user has pin', () async {
      final authService = _MockAuthService();
      final pinService = _MockPinService();
      final useCase = CheckPinAvailabilityUseCase(authService, pinService);

      when(() => authService.currentUserId).thenReturn('uid123');
      when(() => pinService.hasPin('uid123')).thenAnswer((_) async => true);

      final result = await useCase();

      expect(result, isTrue);
      verify(() => pinService.hasPin('uid123')).called(1);
    });

    test('returns false when user does not have pin', () async {
      final authService = _MockAuthService();
      final pinService = _MockPinService();
      final useCase = CheckPinAvailabilityUseCase(authService, pinService);

      when(() => authService.currentUserId).thenReturn('uid123');
      when(() => pinService.hasPin('uid123')).thenAnswer((_) async => false);

      final result = await useCase();

      expect(result, isFalse);
      verify(() => pinService.hasPin('uid123')).called(1);
    });
  });
}

