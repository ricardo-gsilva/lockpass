import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/core/errors/auth_errors_type.dart';
import 'package:lockpass/core/extensions/string_validators.dart';
import 'package:lockpass/core/services/auth/auth_service_impl.dart';
// import 'package:lockpass/core/session/session_lock_service.dart';
import 'package:lockpass/features/login/domain/usecases/check_pin_availability_usecase.dart';
import 'package:lockpass/features/login/domain/usecases/login_with_email_usecase.dart';
import 'package:lockpass/features/login/domain/usecases/login_with_pin_usecase.dart';
import 'package:lockpass/features/login/domain/usecases/register_user_usecase.dart';
import 'package:lockpass/features/login/domain/usecases/reset_password_usecase.dart';
import 'package:lockpass/features/login/presentation/state/auth_state.dart';
import 'package:lockpass/features/login/presentation/state/auth_status.dart';

class LoginController extends Cubit<AuthState> {
  final LoginWithEmailUseCase _loginWithEmailUseCase;
  final CheckPinAvailabilityUseCase _checkPinAvailabilityUseCase;
  final RegisterUserUseCase _registerUserUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final LoginWithPinUseCase _loginWithPinUseCase;

  LoginController({
    required LoginWithEmailUseCase loginWithEmailUseCase,
    required CheckPinAvailabilityUseCase checkPinAvailabilityUseCase,
    required RegisterUserUseCase registerUserUseCase,
    required ResetPasswordUseCase resetPasswordUseCase,
    required LoginWithPinUseCase loginWithPinUseCase,
  })  : _loginWithEmailUseCase = loginWithEmailUseCase,
        _checkPinAvailabilityUseCase = checkPinAvailabilityUseCase,
        _registerUserUseCase = registerUserUseCase,
        _resetPasswordUseCase = resetPasswordUseCase,
        _loginWithPinUseCase = loginWithPinUseCase,
        super(const AuthState());

  Future<void> init() async {
    await checkPinAvailability();
  }

  void _emitStatus(AuthStatus status) {
    emit(state.copyWith(status: status));
  }

  Future<void> checkPinAvailability() async {
    final canUsePin = await _checkPinAvailabilityUseCase();

    emit(state.copyWith(
      canAuthWithPin: canUsePin,
    ));
  }

  Future<void> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    if (!email.isValidEmail) {
      final emailError = email.emailError;
      if (emailError != null) {
        _emitStatus(AuthError(emailError));
        return;
      }
    }

    if (password.isNullOrBlank) {
      _emitStatus(const AuthError("Digite sua senha."));
      return;
    }

    _emitStatus(AuthLoading());

    final stopWatch = Stopwatch()..start();

    try {
      await _loginWithEmailUseCase(
        email: email,
        password: password,
      );

      await _waitMinLoadingTime(stopWatch);

      _emitStatus(EmailAuthenticated());
    } on AuthErrorType catch (type) {
      await _waitMinLoadingTime(stopWatch);
      _emitStatus(AuthError(type.message));
    } on AuthException catch (e) {
      await _waitMinLoadingTime(stopWatch);
      _emitStatus(AuthError(e.message));
    } catch (e) {
      await _waitMinLoadingTime(stopWatch);
      _emitStatus(AuthError(AuthErrorType.unknown.message));
    }
  }

  Future<void> _waitMinLoadingTime(
    Stopwatch stopWatch, {
    Duration minDuration = const Duration(milliseconds: 1500),
  }) async {
    final elapsed = stopWatch.elapsed;
    if (elapsed < minDuration) {
      await Future.delayed(minDuration - elapsed);
    }
  }

  void onPinChanged(String value) {
    final isValid = value.trim().length >= 5;

    if (isValid == state.canSubmitPin) return;

    emit(state.copyWith(canSubmitPin: isValid));
  }

  Future<void> loginWithPin(String typedPin) async {
    _emitStatus(const AuthLoading());

    try {
      final isValid = await _loginWithPinUseCase(typedPin);

      if (!isValid) {
        _emitStatus(const AuthError('PIN incorreto.'));
        return;
      }

      _emitStatus(const PinAuthenticated());
    } on AuthErrorType catch (errorType) {
      _emitStatus(AuthError(errorType.message));
    } catch (_) {
      _emitStatus(
        const AuthError('Erro ao validar o PIN.'),
      );
    }
  }

  Future<void> register({
    required String email,
    required String password,
  }) async {
    _emitStatus(const AuthLoading());

    final stopWatch = Stopwatch()..start();

    try {
      await _registerUserUseCase(
        email: email,
        password: password,
      );

      await _waitMinLoadingTime(stopWatch);

      _emitStatus(const AccountCreated());
    } on AuthErrorType catch (errorType) {
      await _waitMinLoadingTime(stopWatch);
      _emitStatus(AuthError(errorType.message));
    } catch (_) {
      await _waitMinLoadingTime(stopWatch);
      _emitStatus(
        const AuthError("Erro inesperado. Tente novamente."),
      );
    }
  }

  Future<void> resetPassword({required String email}) async {
    if (!email.isValidEmail) {
      final emailError = email.emailError;
      if (emailError != null) {
        _emitStatus(AuthError(emailError));
        return;
      }
    }

    _emitStatus(AuthLoading());

    try {
      await _resetPasswordUseCase(email);

      _emitStatus(PasswordResetSent());
    } on AuthErrorType catch (errorType) {
      _emitStatus(AuthError(errorType.message));
    } catch (_) {
      _emitStatus(
        const AuthError("Erro inesperado. Tente novamente."),
      );
    }
  }
}
