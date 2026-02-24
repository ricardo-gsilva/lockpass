import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/core/extensions/string_validators.dart';
import 'package:lockpass/core/services/auth_service.dart';
import 'package:lockpass/core/services/pin_service.dart';
import 'package:lockpass/core/session/presentation/state/lock_screen_state.dart';
import 'package:lockpass/core/session/presentation/state/lock_screen_status.dart';
import 'package:lockpass/core/session/session_lock_service.dart';

class LockScreenController extends Cubit<LockScreenState> {
  final PinService _pinService;
  final SessionLockService _sessionLock;
  final AuthService _authService;

  LockScreenController({
    required PinService pinService,
    required SessionLockService sessionLock,
    required AuthService authService,
  })  : _pinService = pinService,
        _sessionLock = sessionLock,
        _authService = authService,
        super(const LockScreenState());

  String get _uid => _authService.currentUserId;

  void toggleCredentials() {
    emit(state.copyWith(showCredentials: !state.showCredentials));
  }

  void onPinChanged(String value) {
    final isValid = value.trim().length >= 5;

    if (isValid == state.canSubmit) return;

    emit(state.copyWith(canSubmit: isValid));
  }

  void onCredentialsChanged(String email, String password) {
    final isEmailValid = email.contains('@'); // ou sua extension
    final isPasswordValid = password.trim().length >= 6;

    emit(state.copyWith(
      canSubmit: isEmailValid && isPasswordValid,
    ));
  }

  void toggleAuthMethod() {
    emit(state.copyWith(
      pinOrEmailAndPassword: !state.pinOrEmailAndPassword,
    ));
  }

  Future<void> unlockWithCredentials(
    String? email,
    String? password,
  ) async {
    final typedEmail = (email ?? '').trim();
    final typedPassword = password ?? '';

    if (!typedEmail.isValidEmail || typedPassword.isEmpty) {
      emit(state.copyWith(
          status: LockScreenFailure("Preencha e-mail e senha corretamente.")));
      return;
    }
    try {
      emit(state.copyWith(status: const LockScreenLoading()));

      final isValid = await _authService.reauthenticateWithPassword(
        email: typedEmail,
        password: typedPassword,
      );

      if (!isValid) {
        emit(state.copyWith(
            status: LockScreenFailure("Credenciais inválidas.")));
        return;
      }

      _sessionLock.unlock();

      emit(state.copyWith(status: const LockScreenSuccess()));
    } catch (_) {
      emit(state.copyWith(
          status: LockScreenFailure("Erro ao validar credenciais.")));
      return;
    }
  }

  Future<void> unlockWithPin(String? pin) async {
    final typedPin = (pin ?? '').trim();

    if (typedPin.length != 5) {
      emit(state.copyWith(status: LockScreenFailure("Digite um PIN válido.")));
      return;
    }
    try {
      emit(state.copyWith(status: const LockScreenLoading()));

      final isValid = await _pinService.validatePin(_uid, typedPin);

      if (!isValid) {
        emit(state.copyWith(status: LockScreenFailure("PIN incorreto.")));
        return;
      }

      _sessionLock.unlock();

      emit(state.copyWith(status: const LockScreenSuccess()));
    } catch (_) {
      emit(state.copyWith(status: LockScreenFailure("Erro ao validar PIN.")));
      return;
    }
  }

  Future<void> unlock({
    String? pin,
    String? email,
    String? password,
  }) async {
    if (!state.pinOrEmailAndPassword) {
      await unlockWithPin(pin);
    } else {
      await unlockWithCredentials(
        email,
        password,
      );
    }
  }

  Future<void> initializeAuthMethod() async {
    emit(state.copyWith(status: const LockScreenLoading()));

    final bool userHasPin = await _pinService.hasPin(_uid);

    emit(state.copyWith(
      status: const LockScreenInitial(),
      pinOrEmailAndPassword: !userHasPin,
    ));
  }
}
