import 'package:lockpass/constants/core_strings.dart';

enum AuthErrorType {
  invalidEmail,
  invalidCredentials,
  userDisabled,
  tooManyRequests,
  networkFailed,
  weakPassword,
  requiresRecentLogin,
  unknown,
  internalError,
}
extension AuthErrorTypeMessage on AuthErrorType {
  String get message => switch (this) {
        AuthErrorType.invalidEmail => CoreStrings.fEmailInvalid,
        AuthErrorType.invalidCredentials => CoreStrings.fInvalidLoginCredentials,
        AuthErrorType.userDisabled => CoreStrings.fUserDisabled,
        AuthErrorType.tooManyRequests => 'Muitas tentativas. Tente novamente em alguns minutos.',
        AuthErrorType.networkFailed => 'Sem conexão. Verifique sua internet.',
        AuthErrorType.weakPassword => 'A nova senha deve ter no mínimo 6 caracteres.',
        AuthErrorType.requiresRecentLogin => 'Sessão expirada. Por segurança, faça login novamente.',
        AuthErrorType.internalError => "Não foi possível validar suas informações. Verifique sua senha atual e sua conexão e tente novamente.",
        AuthErrorType.unknown => 'Algo deu errado. Tente novamente.',        
      };
}
extension FirebaseAuthCodeMapper on String {
  AuthErrorType toAuthErrorType() {
    final code = this.toLowerCase().replaceAll('_', '-');
    return switch (code) {
      'invalid-email' => AuthErrorType.invalidEmail,
      'user-disabled' => AuthErrorType.userDisabled,
      'too-many-requests' => AuthErrorType.tooManyRequests,
      'network-request-failed' => AuthErrorType.networkFailed,
      'weak-password' => AuthErrorType.weakPassword, // Importante para troca de senha
      'internal-error' => AuthErrorType.internalError,
      'requires-recent-login' => AuthErrorType.requiresRecentLogin, // Segurança do Firebase
      'invalid-credential' ||
      'wrong-password' ||
      'user-not-found' ||
      'invalid-login-credentials'
        => AuthErrorType.invalidCredentials,
      _ => AuthErrorType.unknown,         
    };
  }
}
