import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/core/utils/extensions/string_extensions.dart';
import 'package:lockpass/core/utils/validators/validators.dart';
import 'package:lockpass/features/login/presentation/state/login_state.dart';
import 'package:lockpass/services/auth_service.dart';
import 'package:lockpass/core/vault/vault_service.dart';
import 'package:lockpass/services/pin_service.dart';

class LoginController extends Cubit<LoginState> {
  final AuthService _authService;
  final VaultService _vaultService;
  final PinService _pinService;

  LoginController({
    required AuthService authService,
    required VaultService vaultService,
    required PinService pinService,
  })  : _authService = authService,
        _vaultService = vaultService,
        _pinService = pinService,
        super(const LoginState());

  /// equivalente ao: sharedPrefs() + getPlatform() + getPermissionStorage()
  /// (só que agora isso é responsabilidade do Vault)
  Future<void> init() async {
    await _vaultService.initializeVaultEnvironment();
    await checkPinAvailability();
  }

  Future<void> checkPinAvailability() async {
    emit(state.copyWith(isLoading: true));

    final isAuthenticated = _authService.currentUserId.isNotNullOrBlank;
    final hasPin = await _pinService.hasPin();

    emit(state.copyWith(
      isLoading: false,
      canLoginWithPin: isAuthenticated && hasPin,
    ));
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
    if (!email.isValidEmail) {
      emit(
        state.copyWith(
          confirmLogin: false,
          exception: email.emailError,
        ));
        return;
    }
    
    if (password.isBlank) {
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
      if (_authService.currentUserId.isEmpty) {
        await _waitMinLoadingTime(stopWatch);
        emit(state.copyWith(
          isLoading: false,
          confirmLogin: false,
          exception: 'Usuário não encontrado. Faça login novamente.',
        ));
        return;
      }

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

//   String? validateEmail(String value) {
//   if (value.isEmpty) return "O e-mail é obrigatório";
//   final regex = RegExp(r"^[\w\.-]+@[\w\.-]+\.\w+$");
//   if (!regex.hasMatch(value)) return "E-mail inválido";
//   return null;
// }

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

  void onPinChanged(String value) {
    final isValid = value.trim().length >= 5;

    // evita emitir estado igual desnecessariamente
    if (isValid == state.canSubmitPin) return;

    emit(state.copyWith(canSubmitPin: isValid));
  }  

  /// equivalente ao fluxo do PIN na page:
  /// checkPin(pin) -> pinDecrypt() -> isolateCreateZip(path, pin)
  //Future<bool> loginWithPin({required String pin}) async {
  Future<void> loginWithPin(String typedPin) async {
    emit(state.copyWith(
      isLoading: true,
      errorMessage: '',
    ));

    final uid = _authService.currentUserId;

    // 🔴 Sessão não existe → força login normal
    if (uid.isEmpty) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Sessão expirada. Faça login com e-mail.',
      ));
      return;
    }

    try {
      final isValid = await _pinService.validatePin(uid, typedPin.trim());

      if (!isValid) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'PIN incorreto.',
        ));
        return;
      }

      // ✅ PIN correto → usuário já está autenticado
      emit(state.copyWith(
        isLoading: false,
        isAuthenticated: true,
      ));
    } catch (_) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Erro ao validar o PIN.',
        isAuthenticated: false,
      ));
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
    if (!email.isValidEmail) {
      emit(state.copyWith(
        resetPass: true,
        exception: email.emailError,
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
