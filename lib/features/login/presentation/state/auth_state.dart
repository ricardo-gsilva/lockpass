// class LoginState {
//   final bool userCreate;
//   final bool confirmLogin;
//   final bool resetPass;
//   final String exception;
//   final String message;
//   final bool isLoading;
//   final bool isPinLoginMode;
//   final bool sufixIcon;
//   final bool obscureText;
//   final bool shouldPrefill;
//   final String? prefillEmail;
//   final String? prefillPassword;
//   final bool canLoginWithPin;
//   final String errorMessage;
//   final bool isAuthenticated;
//   final bool canSubmitPin;

//   const LoginState({
//     this.userCreate = false,
//     this.confirmLogin = false,
//     this.resetPass = false,
//     this.exception = '',
//     this.message = '',
//     this.isLoading = false,
//     this.isPinLoginMode = false,
//     this.sufixIcon = true,
//     this.obscureText = true,
//     this.shouldPrefill = false,
//     this.prefillEmail,
//     this.prefillPassword,
//     this.canLoginWithPin = false,
//     this.errorMessage = '',
//     this.isAuthenticated = false,
//     this.canSubmitPin = false,
//   });

//   LoginState copyWith({
//     bool? userCreate,
//     bool? confirmLogin,
//     bool? resetPass,
//     String? exception,
//     String? message,
//     bool? isLoading,
//     bool? isPinLoginMode,
//     bool? sufixIcon,
//     bool? obscureText,
//     bool? shouldPrefill,
//     String? prefillEmail,
//     String? prefillPassword,
//     bool? canLoginWithPin,
//     String? errorMessage,
//     bool? isAuthenticated,
//     bool? canSubmitPin,
//   }) {
//     return LoginState(
//       userCreate: userCreate ?? this.userCreate,
//       confirmLogin: confirmLogin ?? this.confirmLogin,
//       resetPass: resetPass ?? this.resetPass,
//       exception: exception ?? this.exception,
//       message: message ?? this.message,
//       isLoading: isLoading ?? this.isLoading,
//       isPinLoginMode: isPinLoginMode ?? this.isPinLoginMode,
//       sufixIcon: sufixIcon ?? this.sufixIcon,
//       obscureText: obscureText ?? this.obscureText,
//       shouldPrefill: shouldPrefill ?? this.shouldPrefill,
//       prefillEmail: prefillEmail ?? this.prefillEmail,
//       prefillPassword: prefillPassword ?? this.prefillPassword,
//       canLoginWithPin: canLoginWithPin ?? this.canLoginWithPin,
//       errorMessage: errorMessage ?? this.errorMessage,
//       isAuthenticated: isAuthenticated ?? this.isAuthenticated,
//       canSubmitPin: canSubmitPin ?? this.canSubmitPin
//     );
//   }
// }

import 'package:lockpass/features/login/presentation/state/auth_status.dart';

class AuthState {
  final AuthStatus status;
  final bool obscureText;
  final bool canSubmitPin;
  final bool canAuthWithPin;

  const AuthState({
    this.status = const AuthInitial(),
    this.obscureText = true,
    this.canSubmitPin = false,
    this.canAuthWithPin = false,
  });

  AuthState copyWith({
    AuthStatus? status,
    bool? obscureText,
    bool? canSubmitPin,
    bool? canAuthWithPin,
  }) {
    return AuthState(
      status: status ?? this.status,
      obscureText: obscureText ?? this.obscureText,
      canSubmitPin: canSubmitPin ?? this.canSubmitPin,
      canAuthWithPin: canAuthWithPin ?? this.canAuthWithPin,
    );
  }
}
