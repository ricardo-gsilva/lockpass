import 'package:lockpass/core/constants/core_strings.dart';

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
        AuthErrorType.tooManyRequests => CoreStrings.tooManyAttempts,
        AuthErrorType.networkFailed => CoreStrings.noConnection,
        AuthErrorType.weakPassword => CoreStrings.passwordTooShort,
        AuthErrorType.requiresRecentLogin => CoreStrings.sessionExpired,
        AuthErrorType.internalError => CoreStrings.infoValidationFailed,
        AuthErrorType.unknown => CoreStrings.genericError,
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
      'weak-password' => AuthErrorType.weakPassword,
      'internal-error' => AuthErrorType.internalError,
      'requires-recent-login' => AuthErrorType.requiresRecentLogin,
      'invalid-credential' ||
      'wrong-password' ||
      'user-not-found' ||
      'invalid-login-credentials'
        => AuthErrorType.invalidCredentials,
      _ => AuthErrorType.unknown,         
    };
  }
}
