import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/core/services/auth/auth_service.dart';
import 'package:lockpass/core/services/pin/pin_service.dart';
import 'package:lockpass/core/session/domain/usecases/get_pin_status_session_usecase.dart';
import 'package:mocktail/mocktail.dart';

class _MockPinService extends Mock implements PinService {}

class _MockAuthService extends Mock implements AuthService {}

void main() {
  group('GetPinStatusSessionUseCase', () {
    test('throws when unauthenticated', () async {
      final pinService = _MockPinService();
      final authService = _MockAuthService();
      when(() => authService.currentUserId).thenReturn('');

      final useCase = GetPinStatusSessionUseCase(pinService, authService);

      await expectLater(
        () => useCase(),
        throwsA(
          predicate(
            (e) => e is Exception && e.toString().contains(CoreStrings.unauthenticatedUser),
          ),
        ),
      );

      verifyNever(() => pinService.hasPin(any()));
    });

    test('delegates to PinService.hasPin when authenticated', () async {
      final pinService = _MockPinService();
      final authService = _MockAuthService();
      when(() => authService.currentUserId).thenReturn('uid');
      when(() => pinService.hasPin('uid')).thenAnswer((_) async => true);

      final useCase = GetPinStatusSessionUseCase(pinService, authService);
      final result = await useCase();

      expect(result, isTrue);
      verify(() => pinService.hasPin('uid')).called(1);
    });
  });
}

