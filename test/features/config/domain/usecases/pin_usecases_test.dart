import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/core/services/auth/auth_service.dart';
import 'package:lockpass/core/services/pin/pin_service.dart';
import 'package:lockpass/features/config/domain/usecases/confirm_and_remove_pin_usecase.dart';
import 'package:lockpass/features/config/domain/usecases/get_pin_status_usecase.dart';
import 'package:lockpass/features/config/domain/usecases/reauthenticate_and_remove_pin_usecase.dart';
import 'package:lockpass/features/config/domain/usecases/save_pin_usecase.dart';
import 'package:lockpass/features/config/domain/usecases/update_pin_usecase.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthService extends Mock implements AuthService {}

class _MockPinService extends Mock implements PinService {}

void main() {
  group('PIN usecases', () {
    test('GetPinStatusUseCase throws when unauthenticated', () async {
      final auth = _MockAuthService();
      final pin = _MockPinService();
      final useCase = GetPinStatusUseCase(pin, auth);

      when(() => auth.currentUserId).thenReturn('');

      expect(() => useCase(), throwsA(isA<Exception>()));
      verifyNever(() => pin.hasPin(any()));
    });

    test('GetPinStatusUseCase returns hasPin', () async {
      final auth = _MockAuthService();
      final pin = _MockPinService();
      final useCase = GetPinStatusUseCase(pin, auth);

      when(() => auth.currentUserId).thenReturn('uid');
      when(() => pin.hasPin('uid')).thenAnswer((_) async => true);

      final result = await useCase();
      expect(result, isTrue);
    });

    test('SavePinUseCase saves pin', () async {
      final auth = _MockAuthService();
      final pin = _MockPinService();
      final useCase = SavePinUseCase(auth, pin);

      when(() => auth.currentUserId).thenReturn('uid');
      when(() => pin.savePin('uid', '12345')).thenAnswer((_) async {});

      await useCase('12345');
      verify(() => pin.savePin('uid', '12345')).called(1);
    });

    test('UpdatePinUseCase throws INVALID_CURRENT_PIN when current pin invalid', () async {
      final auth = _MockAuthService();
      final pin = _MockPinService();
      final useCase = UpdatePinUseCase(auth, pin);

      when(() => auth.currentUserId).thenReturn('uid');
      when(() => pin.validatePin('uid', '11111')).thenAnswer((_) async => false);

      expect(
        () => useCase(currentPin: '11111', newPin: '22222'),
        throwsA(predicate((e) => e.toString().contains('INVALID_CURRENT_PIN'))),
      );
    });

    test('UpdatePinUseCase saves new pin when current pin valid', () async {
      final auth = _MockAuthService();
      final pin = _MockPinService();
      final useCase = UpdatePinUseCase(auth, pin);

      when(() => auth.currentUserId).thenReturn('uid');
      when(() => pin.validatePin('uid', '11111')).thenAnswer((_) async => true);
      when(() => pin.savePin('uid', '22222')).thenAnswer((_) async {});

      await useCase(currentPin: '11111', newPin: '22222');

      verify(() => pin.savePin('uid', '22222')).called(1);
    });

    test('ConfirmAndRemovePinUseCase removes pin when typed pin matches', () async {
      final auth = _MockAuthService();
      final pin = _MockPinService();
      final useCase = ConfirmAndRemovePinUseCase(auth, pin);

      when(() => auth.currentUserId).thenReturn('uid');
      when(() => pin.validatePin('uid', '12345')).thenAnswer((_) async => true);
      when(() => pin.removePin('uid')).thenAnswer((_) async {});

      await useCase(' 12345 ');

      verify(() => pin.validatePin('uid', '12345')).called(1);
      verify(() => pin.removePin('uid')).called(1);
    });

    test('ConfirmAndRemovePinUseCase throws INVALID_PIN when typed pin mismatches', () async {
      final auth = _MockAuthService();
      final pin = _MockPinService();
      final useCase = ConfirmAndRemovePinUseCase(auth, pin);

      when(() => auth.currentUserId).thenReturn('uid');
      when(() => pin.validatePin('uid', '12345')).thenAnswer((_) async => false);

      expect(
        () => useCase('12345'),
        throwsA(predicate((e) => e.toString().contains('INVALID_PIN'))),
      );
      verifyNever(() => pin.removePin(any()));
    });

    test('ReauthenticateAndRemovePinUseCase reauthenticates and removes pin', () async {
      final auth = _MockAuthService();
      final pin = _MockPinService();
      final useCase = ReauthenticateAndRemovePinUseCase(auth, pin);

      when(() => auth.currentUserId).thenReturn('uid');
      when(
        () => auth.reauthenticateWithPassword(
          email: 'a@b.com',
          password: '123456',
        ),
      ).thenAnswer((_) async => true);
      when(() => pin.removePin('uid')).thenAnswer((_) async {});

      await useCase(email: 'a@b.com', password: '123456');

      verify(
        () => auth.reauthenticateWithPassword(
          email: 'a@b.com',
          password: '123456',
        ),
      ).called(1);
      verify(() => pin.removePin('uid')).called(1);
    });

    test('SavePinUseCase throws when unauthenticated', () async {
      final auth = _MockAuthService();
      final pin = _MockPinService();
      final useCase = SavePinUseCase(auth, pin);

      when(() => auth.currentUserId).thenReturn('');

      expect(
        () => useCase('12345'),
        throwsA(predicate((e) => e.toString().contains(CoreStrings.unauthenticatedUser))),
      );
    });
  });
}

