import 'package:equatable/equatable.dart';

sealed class AuthStatus extends Equatable {
  const AuthStatus();

  @override
  List<Object?> get props => const [];
}

class AuthInitial extends AuthStatus {
  const AuthInitial();
}

class AuthLoading extends AuthStatus {
  const AuthLoading();
}

class AuthError extends AuthStatus {
  final String message;
  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

sealed class AuthSuccess extends AuthStatus {
  const AuthSuccess();
}

class EmailAuthenticated extends AuthSuccess {
  const EmailAuthenticated();
}

class PinAuthenticated extends AuthSuccess {
  const PinAuthenticated();
}

class AccountCreated extends AuthSuccess {
  const AccountCreated();
}

class PasswordResetSent extends AuthSuccess {
  const PasswordResetSent();
}
