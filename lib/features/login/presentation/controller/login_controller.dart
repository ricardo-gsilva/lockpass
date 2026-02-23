import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/core/extensions/string_validators.dart';
import 'package:lockpass/core/session/session_lock_service.dart';
import 'package:lockpass/features/login/presentation/state/auth_state.dart';
import 'package:lockpass/core/services/auth_service.dart';
import 'package:lockpass/core/security/vault/vault_service.dart';
import 'package:lockpass/core/services/pin_service.dart';
import 'package:lockpass/features/login/presentation/state/auth_status.dart';

class LoginController extends Cubit<AuthState> {
  final AuthService _authService;
  final VaultService _vaultService;
  final PinService _pinService;
  final SessionLockService _sessionLockService;

  LoginController({
    required AuthService authService,
    required VaultService vaultService,
    required PinService pinService,
    required SessionLockService sessionLockService,
  })  : _authService = authService,
        _vaultService = vaultService,
        _pinService = pinService,
        _sessionLockService = sessionLockService,
        super(const AuthState());

  Future<void> init() async {
    await _vaultService.initializeVaultEnvironment();
    await checkPinAvailability();
  }

  void _emitStatus(AuthStatus status) {
    emit(state.copyWith(status: status));
  }

  String get _uid => _authService.currentUserId;

  Future<void> checkPinAvailability() async {
    final isAuthenticated = _authService.currentUserId.isNotNullOrBlank;
    final hasPin = await _pinService.hasPin(_uid);

    emit(state.copyWith(
      canAuthWithPin: isAuthenticated && hasPin,
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
      _emitStatus(AuthError("Digite sua senha."));
      return;
    }
    _emitStatus(AuthLoading());

    final stopWatch = Stopwatch()..start();

    try {
      await _authService.login(email, password);
      if (_authService.currentUserId.isEmpty) {
        await _waitMinLoadingTime(stopWatch);
        _emitStatus(AuthError('Usuário não encontrado. Faça login novamente.'));
        return;
      }

      await _waitMinLoadingTime(stopWatch);
      await _vaultService.initializeVaultEnvironment();

      _sessionLockService.unlock();
      _emitStatus(EmailAuthenticated());
    } on AuthException catch (e) {
      await _waitMinLoadingTime(stopWatch);
      _emitStatus(AuthError(e.message));
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
    final uid = _authService.currentUserId;

    if (uid.isEmpty) {
      _emitStatus(AuthError('Sessão expirada. Faça login com e-mail.'));
      return;
    }
    _emitStatus(const AuthLoading());

    try {
      final isValid = await _pinService.validatePin(uid, typedPin.trim());

      if (!isValid) {
        _emitStatus(const AuthError('PIN incorreto.'));
        return;
      }

      _sessionLockService.unlock();

      _emitStatus(const PinAuthenticated());
    } catch (_) {
      _emitStatus(const AuthError('Erro ao validar o PIN.'));
    }
  }

  Future<void> register({
    required String email,
    required String password,
  }) async {
    _emitStatus(const AuthLoading());

    try {
      await Future.delayed(const Duration(seconds: 2));
      await _authService.register(email, password);
      await _authService.sigInOut();
      _emitStatus(const AccountCreated());
    } on AuthException catch (e) {
      _emitStatus(AuthError(e.message));
    } catch (_) {
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
      await _authService.resetPassword(email);

      _emitStatus(PasswordResetSent());
    } on AuthException catch (e) {
      _emitStatus(AuthError(e.message));
    } catch (_) {
      _emitStatus(
        const AuthError("Erro inesperado. Tente novamente."),
      );
    }
  }
}
