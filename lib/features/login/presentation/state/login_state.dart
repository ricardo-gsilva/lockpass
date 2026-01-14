class LoginState {
 final bool userCreate;
  final bool confirmLogin;
  final bool resetPass;
  final String exception;
  final bool pinCreated;
  final bool sufixIcon;
  final bool obscureText;

  const LoginState({
    this.userCreate = false,
    this.confirmLogin = false,
    this.resetPass = false,
    this.exception = '',
    this.pinCreated = false,
    this.sufixIcon = true,
    this.obscureText = true,
  });

  LoginState copyWith({
    bool? userCreate,
    bool? confirmLogin,
    bool? resetPass,
    String? exception,
    bool? pinCreated,
    bool? sufixIcon,
    bool? obscureText,
  }) {
    return LoginState(
      userCreate: userCreate ?? this.userCreate,
      confirmLogin: confirmLogin ?? this.confirmLogin,
      resetPass: resetPass ?? this.resetPass,
      exception: exception ?? this.exception,
      pinCreated: pinCreated ?? this.pinCreated,
      sufixIcon: sufixIcon ?? this.sufixIcon,
      obscureText: obscureText ?? this.obscureText,
    );
  }
}