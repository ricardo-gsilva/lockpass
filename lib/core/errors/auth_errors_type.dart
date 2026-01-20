import 'package:lockpass/constants/core_strings.dart';

enum AuthErrorType {
  invalidEmail,
  invalidCredentials,
  userDisabled,
  tooManyRequests,
  networkFailed,
  unknown,
}

extension AuthErrorTypeMessage on AuthErrorType {
  String get message => switch (this) {
        AuthErrorType.invalidEmail => CoreStrings.fEmailInvalid,
        AuthErrorType.invalidCredentials => CoreStrings.fInvalidLoginCredentials,
        AuthErrorType.userDisabled => CoreStrings.fUserDisabled,
        AuthErrorType.tooManyRequests =>
          'Muitas tentativas. Tente novamente em alguns minutos.',
        AuthErrorType.networkFailed =>
          'Sem conexão. Verifique sua internet.',
        AuthErrorType.unknown =>
          'Algo deu errado. Tente novamente.',
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
      'invalid-credential' ||
      'wrong-password' ||
      'user-not-found' ||
      'INVALID_LOGIN_CREDENTIALS' ||
      'invalid-login-credentials'
        => AuthErrorType.invalidCredentials,
      _ => AuthErrorType.unknown,      
    };
  }
}
