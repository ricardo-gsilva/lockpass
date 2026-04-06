import 'package:equatable/equatable.dart';
import 'package:lockpass/features/login/presentation/state/auth_status.dart';

class AuthState extends Equatable {
  final AuthStatus status;
  final bool canSubmitPin;
  final bool canAuthWithPin;

  const AuthState({
    this.status = const AuthInitial(),
    this.canSubmitPin = false,
    this.canAuthWithPin = false,
  });

  AuthState copyWith({
    AuthStatus? status,
    bool? canSubmitPin,
    bool? canAuthWithPin,
  }) {
    return AuthState(
      status: status ?? this.status,
      canSubmitPin: canSubmitPin ?? this.canSubmitPin,
      canAuthWithPin: canAuthWithPin ?? this.canAuthWithPin,
    );
  }

  @override
  List<Object?> get props => [status, canSubmitPin, canAuthWithPin];
}
