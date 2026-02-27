import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/core/extensions/string_validators.dart';
import 'package:lockpass/core/session/domain/usecases/get_lock_timeout__session_usercase.dart';
import 'package:lockpass/core/session/domain/usecases/get_pin_status_session_usecase.dart';
import 'package:lockpass/core/session/domain/usecases/unlock_with_credentials_usecase.dart';
import 'package:lockpass/core/session/domain/usecases/unlock_with_pin_usecase.dart';
import 'package:lockpass/core/session/presentation/state/lock_screen_state.dart';
import 'package:lockpass/core/session/presentation/state/lock_screen_status.dart';

class LockScreenController extends Cubit<LockScreenState> {
  final UnlockWithPinUseCase _unlockWithPinUseCase;
  final UnlockWithCredentialsUseCase _unlockWithCredentialsUseCase;
  final GetLockTimeoutSessionUseCase _getLockTimeoutSessionUseCase;
  final GetPinStatusSessionUseCase _getPinStatusSessionUseCase;

  LockScreenController({
    required UnlockWithPinUseCase unlockWithPinUseCase,
    required UnlockWithCredentialsUseCase unlockWithCredentialUseCase,
    required GetLockTimeoutSessionUseCase getLockTimeoutSessionUseCase,
    required GetPinStatusSessionUseCase getPinStatusSessionUseCase,
  })  : _unlockWithPinUseCase = unlockWithPinUseCase,
        _unlockWithCredentialsUseCase = unlockWithCredentialUseCase,
        _getLockTimeoutSessionUseCase = getLockTimeoutSessionUseCase,
        _getPinStatusSessionUseCase = getPinStatusSessionUseCase,
        super(const LockScreenState());

  void init() {
    getPinVerification();
  }

  void toggleCredentials() {
    emit(state.copyWith(showCredentials: !state.showCredentials));
  }

  void onPinChanged(String value) {
    final isValid = value.trim().length >= 5;

    if (isValid == state.canSubmit) return;

    emit(state.copyWith(canSubmit: isValid));
  }

  void onCredentialsChanged(String email, String password) {
    final isEmailValid = email.contains('@');
    final isPasswordValid = password.trim().length >= 6;

    emit(state.copyWith(
      canSubmit: isEmailValid && isPasswordValid,
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
        status: LockScreenFailure(CoreStrings.fillEmailAndPassword),
      ));
      return;
    }

    emit(state.copyWith(status: const LockScreenLoading()));

    try {
      final success = await _unlockWithCredentialsUseCase(
        email: typedEmail,
        password: typedPassword,
      );

      if (!success) {
        emit(state.copyWith(
          status: LockScreenFailure(CoreStrings.invalidCredentials),
        ));
        return;
      }

      emit(state.copyWith(
        status: const LockScreenSuccess(),
      ));
    } catch (_) {
      emit(state.copyWith(
        status: LockScreenFailure(CoreStrings.credentialsValidationError),
      ));
    }
  }

  Future<void> unlockWithPin(String? pin) async {
    final typedPin = (pin ?? '').trim();

    if (typedPin.length != 5) {
      emit(state.copyWith(
        status: LockScreenFailure(CoreStrings.enterValidPin),
      ));
      return;
    }

    emit(state.copyWith(status: const LockScreenLoading()));

    try {
      final success = await _unlockWithPinUseCase(typedPin);

      if (!success) {
        emit(state.copyWith(
          status: LockScreenFailure(CoreStrings.incorrectPin),
        ));
        return;
      }

      emit(state.copyWith(
        status: const LockScreenSuccess(),
      ));
    } catch (_) {
      emit(state.copyWith(
        status: LockScreenFailure(CoreStrings.pinValidationError),
      ));
    }
  }

  Future<void> unlock({required bool pinOrEmailAndPassword, String? pin, String? email, String? password}) async {
    if (pinOrEmailAndPassword) {
      await unlockWithPin(pin);
    } else {
      await unlockWithCredentials(
        email,
        password,
      );
    }
  }

  int getLockTimeout() {
    return _getLockTimeoutSessionUseCase();
  }

  Future<bool> getPinVerification() async {
    emit(state.copyWith(status: const LockScreenLoading()));

    try {
      final hasPin = await _getPinStatusSessionUseCase();
      emit(state.copyWith(
        status: const LockScreenInitial(),
      ));
      return hasPin;
    } catch (e) {
      emit(state.copyWith(
        status: LockScreenFailure(CoreStrings.pinVerificationError),
      ));
      return false;
    }
  }
}
