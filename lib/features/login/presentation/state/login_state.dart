class LoginState {
  final bool userCreate;
  final bool confirmLogin;
  final bool resetPass;
  final String exception;
  final String? message;
  final bool isLoading;
  final bool isPinLoginMode;
  final bool sufixIcon;
  final bool obscureText;
  final bool shouldPrefill;
  final String? prefillEmail;
  final String? prefillPassword;

  const LoginState({
    this.userCreate = false,
    this.confirmLogin = false,
    this.resetPass = false,
    this.exception = '',
    this.message,
    this.isLoading = false,
    this.isPinLoginMode = false,
    this.sufixIcon = true,
    this.obscureText = true,
    this.shouldPrefill = false,
    this.prefillEmail,
    this.prefillPassword,
  });

  LoginState copyWith({
    bool? userCreate,
    bool? confirmLogin,
    bool? resetPass,
    String? exception,
    String? message,
    bool? isLoading,
    bool? isPinLoginMode,
    bool? sufixIcon,
    bool? obscureText,
    bool? shouldPrefill,
    String? prefillEmail,
    String? prefillPassword,
  }) {
    return LoginState(
      userCreate: userCreate ?? this.userCreate,
      confirmLogin: confirmLogin ?? this.confirmLogin,
      resetPass: resetPass ?? this.resetPass,
      exception: exception ?? this.exception,
      message: message ?? this.message,
      isLoading: isLoading ?? this.isLoading,
      isPinLoginMode: isPinLoginMode ?? this.isPinLoginMode,
      sufixIcon: sufixIcon ?? this.sufixIcon,
      obscureText: obscureText ?? this.obscureText,
      shouldPrefill: shouldPrefill ?? this.shouldPrefill,
      prefillEmail: prefillEmail ?? this.prefillEmail,
      prefillPassword: prefillPassword ?? this.prefillPassword,
    );
  }
}
