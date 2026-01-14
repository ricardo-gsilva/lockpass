import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/features/login/presentation/state/login_state.dart';
import 'package:lockpass/services/auth_service.dart';
import 'package:lockpass/core/vault/vault_service.dart';

// enum LoginMode { email, pin }

class LoginController extends Cubit<LoginState> {
  final AuthService _authService;
  final VaultService _vaultService;

  LoginController({
    required AuthService authService,
    required VaultService vaultService,
  })  : _authService = authService,
        _vaultService = vaultService,
        super(const LoginState());

  /// equivalente ao: sharedPrefs() + getPlatform() + getPermissionStorage()
  /// (só que agora isso é responsabilidade do Vault)
  Future<void> init() async {
    await _vaultService.init();
    // Se você quiser já checar se existe PIN e auto-ajustar o modo:
    final hasPin = await _vaultService.hasPin();
    if (hasPin) {
      // Você pode decidir começar no modo PIN ou manter email por padrão.
      // emit(state.copyWith(mode: LoginMode.pin));
    }
  }

  /// equivalente ao: visibilityPass()
  void togglePasswordVisibility() {
    final newSufixIcon = !state.sufixIcon;
    emit(state.copyWith(
      sufixIcon: newSufixIcon,
      obscureText: newSufixIcon, // seu padrão atual
    ));
  }

  /// equivalente ao: changeLoginWithPin()
  // void toggleLoginMode() {
  //   final newMode =
  //       state.mode == LoginMode.email ? LoginMode.pin : LoginMode.email;
  //   emit(state.copyWith(mode: newMode, exception: ''));
  // }
  void toggleLoginWithPin() {
    emit(state.copyWith(
      pinCreated: !state.pinCreated,
    ));
  }

  /// equivalente ao: checkPinLength()
  bool isPinLengthValid(String pin) => pin.isNotEmpty && pin.length >= 5;

  /// equivalente ao: validarEmail()
  String? validateEmail(String value) {
    final regExp = RegExp(CoreStrings.regExpValidateEmail);
    if (value.isEmpty) return null;
    if (!regExp.hasMatch(value)) return CoreStrings.emailInvalid;
    return null;
  }

  /// equivalente ao: checkField()
  bool validateEmailAndPassword({
    required String email,
    required String password,
  }) {
    if (email.isEmpty || password.isEmpty) {
      emit(state.copyWith(exception: CoreStrings.manyEmptyFields));
      return false;
    }
    return true;
  }

  /// equivalente ao: login(login, password)
  //Future<bool> loginWithEmail({
  Future<bool> login(String login, String password) async {
    try {
      final ok = await _authService.login(login, password);

      emit(state.copyWith(
        confirmLogin: ok,
        exception: '',
      ));

      return ok;
    } on AuthException catch (e) {
      emit(state.copyWith(
        confirmLogin: false,
        exception: e.message,
      ));
      return false;
    } catch (e) {
      emit(state.copyWith(
        confirmLogin: false,
        exception: e.toString(),
      ));
      return false;
    }
  }

  /// equivalente ao fluxo do PIN na page:
  /// checkPin(pin) -> pinDecrypt() -> isolateCreateZip(path, pin)
  //Future<bool> loginWithPin({required String pin}) async {
  Future<bool> loginWithPin({required String pin}) async {
    try {
      // 1️⃣ pin vazio
      if (pin.isEmpty) {
        emit(state.copyWith(exception: CoreStrings.enterYourPin));
        return false;
      }

      // 2️⃣ verifica se existe pin salvo
      final hasPin = await _vaultService.hasPin();
      if (!hasPin) {
        emit(state.copyWith(exception: CoreStrings.pinNotCreated));
        return false;
      }

      // 3️⃣ valida pin
      final ok = await _vaultService.verifyPin(pin);
      if (!ok) {
        emit(state.copyWith(exception: CoreStrings.pinIncorrect));
        return false;
      }

      // 4️⃣ cria vault com pin descriptografado
      final decryptedPin = await _vaultService.getDecryptedPin();
      await _vaultService.createVault(decryptedPin);

      // limpa erro anterior, se houver
      emit(state.copyWith(exception: ''));

      return true;
    } catch (e) {
      emit(state.copyWith(exception: e.toString()));
      return false;
    }
  }

  /// equivalente ao: register()
  Future<bool> register({
    required String email,
    required String password,
  }) async {
    try {
      await _authService.register(email, password);

      emit(state.copyWith(
        userCreate: true,
        exception: CoreStrings.userCreateSucess,
      ));

      return true;
    } catch (e) {
      emit(state.copyWith(exception: e.toString()));
      return false;
    }
  }

  /// equivalente ao: resetPassword()
  Future<bool> resetPassword({required String email}) async {
    try {
      await _authService.resetPassword(email);

      emit(state.copyWith(
        resetPass: true,
        exception:
            'Um email foi enviado para $email. O email contém um link para redefinir sua senha!',
      ));

      return true;
    } catch (e) {
      emit(state.copyWith(exception: e.toString()));
      return false;
    }
  }
}
