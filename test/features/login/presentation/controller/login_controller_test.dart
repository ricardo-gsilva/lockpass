import 'package:bloc_test/bloc_test.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/core/errors/auth_errors_type.dart';
import 'package:lockpass/core/services/auth/auth_service_impl.dart';
import 'package:lockpass/features/login/domain/usecases/check_pin_availability_usecase.dart';
import 'package:lockpass/features/login/domain/usecases/login_with_email_usecase.dart';
import 'package:lockpass/features/login/domain/usecases/login_with_pin_usecase.dart';
import 'package:lockpass/features/login/domain/usecases/register_user_usecase.dart';
import 'package:lockpass/features/login/domain/usecases/reset_password_usecase.dart';
import 'package:lockpass/features/login/presentation/controller/login_controller.dart';
import 'package:lockpass/features/login/presentation/state/auth_state.dart';
import 'package:lockpass/features/login/presentation/state/auth_status.dart';
import 'package:mocktail/mocktail.dart';

class _MockLoginWithEmailUseCase extends Mock implements LoginWithEmailUseCase {}

class _MockCheckPinAvailabilityUseCase extends Mock
    implements CheckPinAvailabilityUseCase {}

class _MockRegisterUserUseCase extends Mock implements RegisterUserUseCase {}

class _MockResetPasswordUseCase extends Mock implements ResetPasswordUseCase {}

class _MockLoginWithPinUseCase extends Mock implements LoginWithPinUseCase {}

void main() {
  late _MockLoginWithEmailUseCase loginWithEmailUseCase;
  late _MockCheckPinAvailabilityUseCase checkPinAvailabilityUseCase;
  late _MockRegisterUserUseCase registerUserUseCase;
  late _MockResetPasswordUseCase resetPasswordUseCase;
  late _MockLoginWithPinUseCase loginWithPinUseCase;

  LoginController buildController() {
    return LoginController(
      loginWithEmailUseCase: loginWithEmailUseCase,
      checkPinAvailabilityUseCase: checkPinAvailabilityUseCase,
      registerUserUseCase: registerUserUseCase,
      resetPasswordUseCase: resetPasswordUseCase,
      loginWithPinUseCase: loginWithPinUseCase,
    );
  }

  setUp(() {
    loginWithEmailUseCase = _MockLoginWithEmailUseCase();
    checkPinAvailabilityUseCase = _MockCheckPinAvailabilityUseCase();
    registerUserUseCase = _MockRegisterUserUseCase();
    resetPasswordUseCase = _MockResetPasswordUseCase();
    loginWithPinUseCase = _MockLoginWithPinUseCase();
  });

  group('LoginController', () {
    blocTest<LoginController, AuthState>(
      'init emits canAuthWithPin from use case',
      build: () {
        when(() => checkPinAvailabilityUseCase.call())
            .thenAnswer((_) async => true);
        return buildController();
      },
      act: (cubit) => cubit.init(),
      expect: () => const [
        AuthState(canAuthWithPin: true),
      ],
      verify: (_) {
        verify(() => checkPinAvailabilityUseCase.call()).called(1);
      },
    );

    blocTest<LoginController, AuthState>(
      'loginWithEmailAndPassword emits AuthError for invalid email',
      build: buildController,
      act: (cubit) => cubit.loginWithEmailAndPassword('', '123456'),
      expect: () => const [
        AuthState(status: AuthError(CoreStrings.fillField)),
      ],
      verify: (_) {
        verifyNever(() => loginWithEmailUseCase.call(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ));
      },
    );

    blocTest<LoginController, AuthState>(
      'loginWithEmailAndPassword emits AuthError for blank password',
      build: buildController,
      act: (cubit) => cubit.loginWithEmailAndPassword('a@b.com', ''),
      expect: () => const [
        AuthState(status: AuthError('Digite sua senha.')),
      ],
      verify: (_) {
        verifyNever(() => loginWithEmailUseCase.call(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ));
      },
    );

    blocTest<LoginController, AuthState>(
      'onPinChanged emits canSubmitPin true only when length >= 5',
      build: buildController,
      act: (cubit) {
        cubit.onPinChanged('1234');
        cubit.onPinChanged('12345');
        cubit.onPinChanged('12345');
      },
      expect: () => const [
        AuthState(canSubmitPin: true),
      ],
    );

    blocTest<LoginController, AuthState>(
      'loginWithPin emits error when pin is invalid',
      build: () {
        when(() => loginWithPinUseCase.call('12345'))
            .thenAnswer((_) async => false);
        return buildController();
      },
      act: (cubit) => cubit.loginWithPin('12345'),
      expect: () => const [
        AuthState(status: AuthLoading()),
        AuthState(status: AuthError('PIN incorreto.')),
      ],
      verify: (_) {
        verify(() => loginWithPinUseCase.call('12345')).called(1);
      },
    );

    blocTest<LoginController, AuthState>(
      'loginWithPin emits success when pin is valid',
      build: () {
        when(() => loginWithPinUseCase.call('12345'))
            .thenAnswer((_) async => true);
        return buildController();
      },
      act: (cubit) => cubit.loginWithPin('12345'),
      expect: () => const [
        AuthState(status: AuthLoading()),
        AuthState(status: PinAuthenticated()),
      ],
    );

    blocTest<LoginController, AuthState>(
      'loginWithPin maps AuthErrorType to AuthError message',
      build: () {
        when(() => loginWithPinUseCase.call('12345'))
            .thenThrow(AuthErrorType.requiresRecentLogin);
        return buildController();
      },
      act: (cubit) => cubit.loginWithPin('12345'),
      expect: () => [
        const AuthState(status: AuthLoading()),
        AuthState(status: AuthError(AuthErrorType.requiresRecentLogin.message)),
      ],
    );

    blocTest<LoginController, AuthState>(
      'resetPassword emits AuthError for invalid email',
      build: buildController,
      act: (cubit) => cubit.resetPassword(email: ''),
      expect: () => const [
        AuthState(status: AuthError(CoreStrings.fillField)),
      ],
      verify: (_) {
        verifyNever(() => resetPasswordUseCase.call(any()));
      },
    );

    blocTest<LoginController, AuthState>(
      'resetPassword emits success when use case succeeds',
      build: () {
        when(() => resetPasswordUseCase.call('a@b.com'))
            .thenAnswer((_) async {});
        return buildController();
      },
      act: (cubit) => cubit.resetPassword(email: 'a@b.com'),
      expect: () => const [
        AuthState(status: AuthLoading()),
        AuthState(status: PasswordResetSent()),
      ],
    );

    test('loginWithEmailAndPassword enforces minimum loading time', () {
      fakeAsync((async) {
        when(() => loginWithEmailUseCase.call(
              email: 'a@b.com',
              password: '123456',
            )).thenAnswer((_) async {});

        final controller = buildController();
        addTearDown(controller.close);

        final emitted = <AuthState>[];
        final sub = controller.stream.listen(emitted.add);
        addTearDown(sub.cancel);

        var completed = false;
        controller
            .loginWithEmailAndPassword('a@b.com', '123456')
            .then((_) => completed = true);

        async.flushMicrotasks();

        expect(emitted, const [
          AuthState(status: AuthLoading()),
        ]);
        expect(completed, isFalse);

        async.elapse(const Duration(milliseconds: 1500));
        async.flushMicrotasks();

        expect(
          emitted,
          const [
            AuthState(status: AuthLoading()),
            AuthState(status: EmailAuthenticated()),
          ],
        );
        expect(completed, isTrue);
      });
    });

    test('register enforces minimum loading time', () {
      fakeAsync((async) {
        when(() => registerUserUseCase.call(
              email: 'a@b.com',
              password: '123456',
            )).thenAnswer((_) async {});

        final controller = buildController();
        addTearDown(controller.close);

        final emitted = <AuthState>[];
        final sub = controller.stream.listen(emitted.add);
        addTearDown(sub.cancel);

        controller.register(email: 'a@b.com', password: '123456');

        async.flushMicrotasks();
        expect(emitted, const [AuthState(status: AuthLoading())]);

        async.elapse(const Duration(milliseconds: 1500));
        async.flushMicrotasks();

        expect(
          emitted,
          const [
            AuthState(status: AuthLoading()),
            AuthState(status: AccountCreated()),
          ],
        );
      });
    });

    test('loginWithEmailAndPassword maps AuthException to AuthError', () {
      fakeAsync((async) {
        when(() => loginWithEmailUseCase.call(
              email: 'a@b.com',
              password: '123456',
            )).thenThrow(AuthException('Falhou'));

        final controller = buildController();
        addTearDown(controller.close);

        final emitted = <AuthState>[];
        final sub = controller.stream.listen(emitted.add);
        addTearDown(sub.cancel);

        controller.loginWithEmailAndPassword('a@b.com', '123456');

        async.flushMicrotasks();
        expect(emitted, const [AuthState(status: AuthLoading())]);

        async.elapse(const Duration(milliseconds: 1500));
        async.flushMicrotasks();

        expect(
          emitted,
          const [
            AuthState(status: AuthLoading()),
            AuthState(status: AuthError('Falhou')),
          ],
        );
      });
    });
  });
}

