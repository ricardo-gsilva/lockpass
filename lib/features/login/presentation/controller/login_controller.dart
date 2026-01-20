import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/features/login/presentation/state/login_state.dart';
import 'package:lockpass/services/auth_service.dart';
import 'package:lockpass/core/vault/vault_service.dart';

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
    await _vaultService.initializeVaultEnvironment();
    // Se você quiser já checar se existe PIN e auto-ajustar o modo:
    // final hasPin = await _vaultService.hasPin();
    // if (hasPin) {
    //   // Você pode decidir começar no modo PIN ou manter email por padrão.
    //   // emit(state.copyWith(mode: LoginMode.pin));
    // }
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
      isPinLoginMode: !state.isPinLoginMode,
    ));
  }

  Future<void> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final emailValidation = validateEmail(email);
    if (emailValidation != null) {
      emit(
        state.copyWith(
          confirmLogin: false,
          exception: emailValidation,
        ));
        return;
    }
    
    if (password.isEmpty) {
      emit(
        state.copyWith(
          confirmLogin: false,
          exception: "Digite sua senha.",
        ));
        return;
    }

    emit( 
      state.copyWith(
        isLoading: true,
        confirmLogin: false,
        exception: '',
        message: '',
      ),
    );

    final stopWatch = Stopwatch()..start();

    try {
      await _authService.login(email, password);

      await _waitMinLoadingTime(stopWatch);

      await _vaultService.initializeVaultEnvironment();

      emit(
        state.copyWith(
          isLoading: false,
          confirmLogin: true,
          exception: '',
        ),
      );
    } on AuthException catch (e) {

      await _waitMinLoadingTime(stopWatch);

      emit(
        state.copyWith(
          isLoading: false,
          confirmLogin: false,
          exception: e.message,
        ),
      );
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


  /// equivalente ao: checkPinLength()
  bool isPinLengthValid(String pin) => pin.isNotEmpty && pin.length >= 5;

  /// equivalente ao: validarEmail()
  // String? validateEmail(String value) {
  //   if (value.isEmpty) return null;

  //   final emailRegExp = RegExp(CoreStrings.regExpValidateEmail);

  //   if (!emailRegExp.hasMatch(value)) {
  //     return CoreStrings.emailInvalid;
  //   }

  //   return null;
  // }

  String? validateEmail(String value) {
  if (value.isEmpty) return "O e-mail é obrigatório";
  final regex = RegExp(r"^[\w\.-]+@[\w\.-]+\.\w+$");
  if (!regex.hasMatch(value)) return "E-mail inválido";
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

  /// equivalente ao fluxo do PIN na page:
  /// checkPin(pin) -> pinDecrypt() -> isolateCreateZip(path, pin)
  //Future<bool> loginWithPin({required String pin}) async {
  Future<bool> loginWithPin({required String pin}) async {
    try {
      // pin vazio
      if (pin.isEmpty) {
        emit(state.copyWith(exception: CoreStrings.enterYourPin));
        return false;
      }

      // verifica se existe pin salvo
      final hasPin = await _vaultService.hasPin();
      if (!hasPin) {
        emit(state.copyWith(exception: CoreStrings.pinNotCreated));
        return false;
      }

      // valida pin
      final ok = await _vaultService.verifyPin(pin);
      if (!ok) {
        emit(state.copyWith(exception: CoreStrings.pinIncorrect));
        return false;
      }

      // cria vault com pin descriptografado
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
    // Inicia loading e limpa mensagens antigas
    emit(state.copyWith(
      isLoading: true,
      exception: '',
      message: '',
      userCreate: false,
    ));

    try {
      await Future.delayed(Duration(seconds: 2));
      await _authService.register(email, password);

      emit(state.copyWith(
        isLoading: false,
        userCreate: true,
        message: CoreStrings.userCreateSucess,
        shouldPrefill: true,
        prefillEmail: email,
        prefillPassword: password,
      ));

      return true;
    } catch (e) {
      final errorMessage = e is AuthException 
        ? e.message : "Erro inesperado. Tente novamente.";
      
      emit(state.copyWith(
        isLoading: false,
        userCreate: false,
        exception: errorMessage,
      ));

      return false;
    }
  }

  void clearFeedback() {
    emit(state.copyWith(
      resetPass: false,
      exception: '',
      message: '',
    ));
  }

  /// equivalente ao: resetPassword()
  Future<void> resetPassword({required String email}) async {
    final validation = validateEmail(email);
    if (validation != null) {
      emit(state.copyWith(
        resetPass: true,
        exception: validation,
        message: '',
        isLoading: false,
      ));
      return;
    }

    emit(state.copyWith(
      resetPass: true,
      isLoading: true,
      exception: '',
      message: '',
    ));

    try {
      await _authService.resetPassword(email);

      emit(state.copyWith(
        isLoading: false,
        message:
            'Enviamos um e-mail para o endereço que você digitou. O e-mail contém um link para redefinir sua senha!',
      ));
    } on AuthException catch (e) {
      
      emit(state.copyWith(
        isLoading: false,
        exception: e.message,
        ),
      );
    }
  }
}
