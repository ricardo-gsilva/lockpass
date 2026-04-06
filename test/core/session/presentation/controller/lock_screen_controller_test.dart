import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/core/session/domain/usecases/get_lock_timeout__session_usercase.dart';
import 'package:lockpass/core/session/domain/usecases/get_pin_status_session_usecase.dart';
import 'package:lockpass/core/session/domain/usecases/unlock_with_credentials_usecase.dart';
import 'package:lockpass/core/session/domain/usecases/unlock_with_pin_usecase.dart';
import 'package:lockpass/core/session/presentation/controller/lock_screen_controller.dart';
import 'package:lockpass/core/session/presentation/state/lock_screen_state.dart';
import 'package:lockpass/core/session/presentation/state/lock_screen_status.dart';
import 'package:mocktail/mocktail.dart';

class _MockUnlockWithPinUseCase extends Mock implements UnlockWithPinUseCase {}

class _MockUnlockWithCredentialsUseCase extends Mock implements UnlockWithCredentialsUseCase {}

class _MockGetLockTimeoutSessionUseCase extends Mock implements GetLockTimeoutSessionUseCase {}

class _MockGetPinStatusSessionUseCase extends Mock implements GetPinStatusSessionUseCase {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LockScreenController', () {
    late _MockUnlockWithPinUseCase unlockWithPinUseCase;
    late _MockUnlockWithCredentialsUseCase unlockWithCredentialsUseCase;
    late _MockGetLockTimeoutSessionUseCase getLockTimeoutSessionUseCase;
    late _MockGetPinStatusSessionUseCase getPinStatusSessionUseCase;

    LockScreenController _controller() => LockScreenController(
          unlockWithPinUseCase: unlockWithPinUseCase,
          unlockWithCredentialUseCase: unlockWithCredentialsUseCase,
          getLockTimeoutSessionUseCase: getLockTimeoutSessionUseCase,
          getPinStatusSessionUseCase: getPinStatusSessionUseCase,
        );

    setUp(() {
      unlockWithPinUseCase = _MockUnlockWithPinUseCase();
      unlockWithCredentialsUseCase = _MockUnlockWithCredentialsUseCase();
      getLockTimeoutSessionUseCase = _MockGetLockTimeoutSessionUseCase();
      getPinStatusSessionUseCase = _MockGetPinStatusSessionUseCase();

      when(() => getLockTimeoutSessionUseCase()).thenReturn(60);
      when(() => getPinStatusSessionUseCase()).thenAnswer((_) async => true);
    });

    Matcher _state({
      bool? showCredentials,
      bool? canSubmit,
      Matcher? status,
    }) {
      var matcher = isA<LockScreenState>();
      if (showCredentials != null) {
        matcher = matcher.having((s) => s.showCredentials, 'showCredentials', showCredentials);
      }
      if (canSubmit != null) {
        matcher = matcher.having((s) => s.canSubmit, 'canSubmit', canSubmit);
      }
      if (status != null) {
        matcher = matcher.having((s) => s.status, 'status', status);
      }
      return matcher;
    }

    blocTest<LockScreenController, LockScreenState>(
      'toggleCredentials toggles showCredentials',
      build: _controller,
      act: (c) => c.toggleCredentials(),
      expect: () => [
        _state(showCredentials: true, canSubmit: false, status: isA<LockScreenInitial>()),
      ],
    );

    blocTest<LockScreenController, LockScreenState>(
      'onPinChanged only emits when validity changes (>= 5)',
      build: _controller,
      act: (c) {
        c.onPinChanged('1');
        c.onPinChanged('12');
        c.onPinChanged('12345');
        c.onPinChanged('12345');
      },
      expect: () => [
        _state(canSubmit: true, status: isA<LockScreenInitial>()),
      ],
    );

    blocTest<LockScreenController, LockScreenState>(
      'onCredentialsChanged enables submit when email has @ and password length >= 6',
      build: _controller,
      act: (c) {
        c.onCredentialsChanged('user', '123456');
        c.onCredentialsChanged('user@', '123456');
        c.onCredentialsChanged('user@a.com', '123456');
      },
      expect: () => [
        _state(canSubmit: false, status: isA<LockScreenInitial>()),
        _state(canSubmit: true, status: isA<LockScreenInitial>()),
      ],
    );

    blocTest<LockScreenController, LockScreenState>(
      'unlockWithCredentials emits failure when email/password invalid',
      build: _controller,
      act: (c) => c.unlockWithCredentials('invalid', ''),
      expect: () => [
        _state(
          status: isA<LockScreenFailure>().having(
            (s) => s.message,
            'message',
            CoreStrings.fillEmailAndPassword,
          ),
        ),
      ],
    );

    blocTest<LockScreenController, LockScreenState>(
      'unlockWithCredentials emits loading then failure when use case returns false',
      build: _controller,
      setUp: () {
        when(
          () => unlockWithCredentialsUseCase(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => false);
      },
      act: (c) => c.unlockWithCredentials('user@a.com', '123456'),
      expect: () => [
        _state(status: isA<LockScreenLoading>()),
        _state(
          status: isA<LockScreenFailure>().having(
            (s) => s.message,
            'message',
            CoreStrings.invalidCredentials,
          ),
        ),
      ],
    );

    blocTest<LockScreenController, LockScreenState>(
      'unlockWithCredentials emits loading then success when use case returns true',
      build: _controller,
      setUp: () {
        when(
          () => unlockWithCredentialsUseCase(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => true);
      },
      act: (c) => c.unlockWithCredentials('user@a.com', '123456'),
      expect: () => [
        _state(status: isA<LockScreenLoading>()),
        _state(status: isA<LockScreenSuccess>()),
      ],
    );

    blocTest<LockScreenController, LockScreenState>(
      'unlockWithCredentials emits loading then failure on exception',
      build: _controller,
      setUp: () {
        when(
          () => unlockWithCredentialsUseCase(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(Exception('boom'));
      },
      act: (c) => c.unlockWithCredentials('user@a.com', '123456'),
      expect: () => [
        _state(status: isA<LockScreenLoading>()),
        _state(
          status: isA<LockScreenFailure>().having(
            (s) => s.message,
            'message',
            CoreStrings.credentialsValidationError,
          ),
        ),
      ],
    );

    blocTest<LockScreenController, LockScreenState>(
      'unlockWithPin emits failure when pin length != 5',
      build: _controller,
      act: (c) => c.unlockWithPin('123'),
      expect: () => [
        _state(
          status: isA<LockScreenFailure>().having(
            (s) => s.message,
            'message',
            CoreStrings.enterValidPin,
          ),
        ),
      ],
    );

    blocTest<LockScreenController, LockScreenState>(
      'unlockWithPin emits loading then failure when use case returns false',
      build: _controller,
      setUp: () {
        when(() => unlockWithPinUseCase(any())).thenAnswer((_) async => false);
      },
      act: (c) => c.unlockWithPin('12345'),
      expect: () => [
        _state(status: isA<LockScreenLoading>()),
        _state(
          status: isA<LockScreenFailure>().having(
            (s) => s.message,
            'message',
            CoreStrings.incorrectPin,
          ),
        ),
      ],
    );

    blocTest<LockScreenController, LockScreenState>(
      'unlockWithPin emits loading then success when use case returns true',
      build: _controller,
      setUp: () {
        when(() => unlockWithPinUseCase(any())).thenAnswer((_) async => true);
      },
      act: (c) => c.unlockWithPin('12345'),
      expect: () => [
        _state(status: isA<LockScreenLoading>()),
        _state(status: isA<LockScreenSuccess>()),
      ],
    );

    blocTest<LockScreenController, LockScreenState>(
      'unlockWithPin emits loading then failure on exception',
      build: _controller,
      setUp: () {
        when(() => unlockWithPinUseCase(any())).thenThrow(Exception('boom'));
      },
      act: (c) => c.unlockWithPin('12345'),
      expect: () => [
        _state(status: isA<LockScreenLoading>()),
        _state(
          status: isA<LockScreenFailure>().having(
            (s) => s.message,
            'message',
            CoreStrings.pinValidationError,
          ),
        ),
      ],
    );

    test('getLockTimeout returns use case result', () {
      when(() => getLockTimeoutSessionUseCase()).thenReturn(30);

      final controller = _controller();
      addTearDown(controller.close);

      expect(controller.getLockTimeout(), 30);
    });

    test('getPinVerification ends in LockScreenInitial and returns use case result', () async {
      when(() => getPinStatusSessionUseCase()).thenAnswer((_) async => false);

      final controller = _controller();
      addTearDown(controller.close);

      final hasPin = await controller.getPinVerification();

      expect(hasPin, isFalse);
      expect(controller.state.status, isA<LockScreenInitial>());
    });
  });
}
